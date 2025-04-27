# from flask import Flask,render_template
from app import app  # This pulls in the app instance
from flask import render_template, request, url_for, flash,redirect ,session
from flask_app import app,login_manager
from flask_app.fake_data import mock_classes
from datetime import datetime, date,time, timedelta
from flask_app.models import User
from flask_app.forms.register_form import RegisterForm
from flask_app.forms.login_form import LoginForm
from flask_app.forms.contact_form import ContactForm
from flask_login import login_user, logout_user, login_required, current_user
from flask_app.data_access import get_db_connection,insert_user, check_user_by_email, generate_unique_user_id,insert_address,get_fitness_classes,get_weekly_schedule,update_last_login
from flask_app.data_access import book_class_for_user,get_class_schedule,get_class_info,generate_recurring_schedules,calculate_end_time,get_user_bookings,get_schedule_by_days,get_user_details
from flask_app.data_access import cancel_booking_for_user, purchase_day_pass,add_contact_submission
import os
from werkzeug.security import generate_password_hash
from werkzeug.security import check_password_hash



# define routes():
@app.route('/')
@app.route('/home')
def home():
    return render_template("home.html")

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/services')
def services():
    return render_template('services.html')


@app.route('/classes')
def classes():
    classes = get_fitness_classes()
    return render_template('classes.html', classes=classes)


def get_week_label(schedule_date, start_date):
    """Calculate the week number based on the start date."""
    delta = schedule_date - start_date
    return f"Week {delta.days // 7 + 1}"  # Determine week number


@app.route('/view_schedule', defaults={'class_id': None}, methods=['GET'])
@app.route('/view_schedule/<int:class_id>', methods=['GET'])
def view_schedule(class_id):
    """Displays schedules grouped by Week, Day, and Batch with recurrence."""
    # Handle query parameter
    if class_id is None:
        class_id = request.args.get('class_id', type=int)
    if not class_id:
        return "class_id is missing", 400  # Return HTTP 400 Bad Request

    # Fetch schedules and class info
    class_info = get_class_info(class_id)
    schedules = get_schedule_by_days(class_id)
    print(schedules)
    # Add recurrence for 4 weeks
    recurring_schedules = generate_recurring_schedules(schedules, weeks=4)  # Generate future occurrences

    # Define the batch classification function
    def get_batch_label(start_time):
        """Classifies the start time into a batch (Morning, Afternoon, Evening)."""
        if start_time.hour < 12:
            return "Morning Batch"
        elif 12 <= start_time.hour < 17:
            return "Afternoon Batch"
        else:
            return "Evening Batch"

    # Group schedules by Week and Day
    def get_week_label(schedule_date, start_date):
        """Calculate the week number based on the starting date."""
        delta = schedule_date - start_date
        return f"Week {delta.days // 7 + 1}"  # Determine week number

    grouped_schedules = {}
    week_start_date = date(2025, 4, 21)  # Define the start of Week 1

    for schedule in recurring_schedules:
        # Calculate week label
        week_label = get_week_label(schedule['ScheduleDate'], week_start_date)
        day_with_date = schedule['ScheduleDate'].strftime('%A, %B %d, %Y')

        # Format time and classify batch
        start_time = (datetime.min + schedule['StartTime']).time().strftime('%I:%M %p')
        end_time = (datetime.min + schedule['EndTime']).time().strftime('%I:%M %p')
        batch_label = get_batch_label(datetime.min + schedule['StartTime'])

        if week_label not in grouped_schedules:
            grouped_schedules[week_label] = {}
        if day_with_date not in grouped_schedules[week_label]:
            grouped_schedules[week_label][day_with_date] = []

        grouped_schedules[week_label][day_with_date].append({
            'Batch': batch_label,
            'StartTime': start_time,
            'EndTime': end_time,
            'Location': schedule['Location'],
            'AvailableSeats': schedule['AvailableSeats'],
            'ScheduleID': schedule['ScheduleID'],
            'Price': schedule['Price']  # Add the price here
        })

    return render_template(
        'class_schedule.html',
        class_info=class_info,
        grouped_schedules=grouped_schedules
    )

@app.route('/book_class/<int:schedule_id>', methods=['POST'])
def book_class(schedule_id):
    """Allows logged-in users to book a class."""
    if 'user_id' not in session:
        flash('You need to log in to book a class.', 'danger')
        return redirect(url_for('login', next=request.referrer))  # Redirect to login if user is not logged in

    user_id = session['user_id']  # Retrieve logged-in user's ID
    db_connection = get_db_connection()
    cursor = db_connection.cursor(dictionary=True)

    try:
        # Check if user has an active Day Pass
        query_check_day_pass = """
            SELECT * FROM day_pass
            WHERE UserID = %s AND PurchaseDate = CURDATE() AND PassStatus = 'Active';
        """
        cursor.execute(query_check_day_pass, (user_id,))
        active_day_pass = cursor.fetchone()
        print(f"Active Day Pass: {active_day_pass}")

        # Fetch the class price dynamically
        query_class_price = """
            SELECT fc.Price
            FROM fitness_class fc
            JOIN class_schedule cs ON fc.class_id = cs.class_id
            WHERE cs.ScheduleID = %s;
        """
        cursor.execute(query_class_price, (schedule_id,))
        price_data = cursor.fetchone()
        if not price_data:
            flash('Error: Class price not found.', 'danger')
            return redirect(request.referrer or url_for('view_schedule', class_id=schedule_id))
        class_fee = price_data['Price']
        print(f"Class Fee: {class_fee}")

        # Booking logic
        if active_day_pass:
            flash('You already have an active Day Pass. Booking your class now.', 'info')

        booking_success = book_class_for_user(user_id, schedule_id)
        if booking_success:
            if not active_day_pass:
                try:
                    query_payment = """
                        INSERT INTO payment (UserID, PaymentDate, Amount, Status, PaymentType, ScheduleID)
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """
                    payment_date = datetime.now()
                    cursor.execute(query_payment, (user_id, payment_date, class_fee, 'Paid', 'PayPerClass', schedule_id))
                    db_connection.commit()
                    flash(f'Class booked successfully! 🎉 Payment of £{class_fee:.2f} recorded. View your classes in your '
                          '<a href="' + url_for('dashboard') + '" class="text-pink font-weight-bold">dashboard</a>', 'success')
                except Exception as e:
                    db_connection.rollback()
                    flash(f"Error processing payment: {str(e)}", 'danger')
            else:
                flash('Class booked successfully! 🎉 Your active Day Pass covers this booking.', 'success')
        else:
            flash('Unable to book the class. It may be full.', 'danger')

    except Exception as e:
        db_connection.rollback()
        print(f"Booking error: {e}")
        app.logger.error(f"Booking error: {str(e)}")
        flash('Something went wrong while booking the class. Please try again later.', 'danger')

    finally:
        cursor.close()

    return redirect(request.referrer or url_for('view_schedule', class_id=schedule_id))


@app.route('/membership_plans', methods=['GET'])
def membership_plans():
    """Display available membership plans."""
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    try:
        # Fetch all membership plans
        query = "SELECT * FROM membership;"
        cursor.execute(query)
        membership_plans = cursor.fetchall()
    finally:
        cursor.close()
        db.close()

    return render_template('membership_plans.html', membership_plans=membership_plans)



@app.route('/instructors')
def instructors():
    return render_template('instructors.html')

@app.route('/trainers')
def trainers_redirect():
    return redirect(url_for('instructors'))

@app.route('/day_pass', methods=['GET'])
def day_pass():
    # Render the Day Pass page
    return render_template('day_pass.html')

@app.route('/purchase_day_pass', methods=['POST'], endpoint='purchase_day_pass')
def purchase_day_pass_route():  # Renamed to avoid conflicts
    user_id = session.get('user_id')
    if not user_id:
        flash("Please log in to purchase a Day Pass.", "danger")
        return redirect(url_for('login', next=url_for('day_pass')))

    # Initialize the database connection
    db = get_db_connection()
    if not db or not db.is_connected():
        flash("Database connection failed. Please try again later.", "danger")
        return redirect(url_for('dashboard'))

    # Call the helper function
    result = purchase_day_pass(db, user_id)

    # Flash the result and redirect
    flash(result["message"], result["status"])
    return redirect(url_for('dashboard'))


# @app.route('/instructors')
# def instructor():
#     return render_template('instructors.html')

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    form = ContactForm()  # Create an instance of the ContactForm

    if request.method == 'POST' and form.validate_on_submit():
        # Access form data
        name = form.name.data
        email = form.email.data
        message = form.message.data

        # Save the data to the database
        add_contact_submission(name, email, message)

        # Render the form again with a success message
        return render_template('contact.html', form=form, thank_message="Thank you for your message! We'll get back to you shortly.")

    # Render the form for a GET request
    return render_template('contact.html', form=form)



@app.route('/search', methods=['GET'])
def search():
    query = request.args.get('query')

    # Redirect based on predefined options
    if query == "classes":
        return redirect(url_for('classes'))
    elif query == "trainers":
        return redirect(url_for('instructors'))
    elif query == "membership":
        return redirect(url_for('membership_plans'))

    # Fallback for unexpected input
    return render_template('search_results.html', message="Select an option from Search Suggestions!")


@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm()

    if form.validate_on_submit():
        first_name = form.first_name.data
        last_name = form.last_name.data
        email = form.email.data.strip().lower()  # Normalize email
        password = form.password.data
        confirm_password = form.confirm_password.data
        phone = form.phone.data
        street = form.street.data
        city = form.city.data
        state_region = form.state_region.data
        postal_code = form.postal_code.data
        country = form.country.data
        date_of_birth = form.date_of_birth.data  # New field for DateOfBirth

        # Ensure required fields are not empty
        if not first_name or not last_name or not email or not password or not confirm_password:
            flash('All fields are required!', 'danger')
            return redirect(url_for('register'))

        if check_user_by_email(email):
            flash('Email already exists. Please use a different one.', 'danger')
            return redirect(url_for('register'))

        if password != confirm_password:
            flash('Passwords do not match!', 'danger')
            return redirect(url_for('register'))

        try:
            print("Inserting address...")
            address_id = insert_address(street, city, state_region, postal_code, country)
            if not address_id:
                raise Exception("Address insertion failed.")

            print("Inserting user...")
            hashed_password = generate_password_hash(password)
            insert_user(first_name, last_name, email, hashed_password, phone, address_id, date_of_birth)

        except Exception as e:
            flash(f"Error during registration: {e}", 'danger')
            return redirect(url_for('register'))

        flash('Registration successful! Please log in.', 'success')
        return redirect(url_for('login'))

    return render_template('register.html', form=form)


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()

    if form.validate_on_submit():  # Ensure form data is valid
        email = form.email.data.strip().lower()  # Normalize email
        password = form.password.data

        # Check if user exists in the database
        user_data = check_user_by_email(email)
        if user_data is None:
            flash('Email does not exist. Please register first.', 'danger')
            return redirect(url_for('login'))

        # Verify the password
        if check_password_hash(user_data['Password'], password):
            user = User.get(user_data['UserID'])  # Load user instance
            login_user(user)  # Flask-Login's login function
            session['user_id'] = user_data['UserID']  # Set user_id in session
            flash('Login successful!', 'success')

            # Redirect to the intended page
            next_page = request.args.get('next')
            if next_page:
                return redirect(next_page)
            return redirect(url_for('dashboard'))  # Default redirect
        else:
            flash('Incorrect password. Please try again.', 'danger')

    return render_template('login.html', form=form)


@app.route('/dashboard', methods=['GET'])
def dashboard():
    """Display user-specific dashboard content."""
    if 'user_id' not in session:
        flash('You need to log in to access your dashboard.', 'danger')
        return redirect(url_for('login'))

    user_id = session['user_id']

    try:
        # Establish database connection
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)

        # Fetch active day pass
        query_day_pass = """
            SELECT * FROM day_pass
            WHERE UserID = %s AND PurchaseDate = CURDATE() AND PassStatus = 'Active'
        """
        cursor.execute(query_day_pass, (user_id,))
        active_day_pass = cursor.fetchone()

        # Fetch payment history
        query_payments = """
            SELECT PaymentDate, Amount, PaymentType, Status
            FROM payment
            WHERE UserID = %s
        """
        cursor.execute(query_payments, (user_id,))
        payments = cursor.fetchall()

        # Debug: Print fetched payments
        print("Payments fetched from database:", payments)

        query_active_membership = """
            SELECT ms.SubscriptionID, m.MembershipType, ms.JoinDate, ms.ExpiryDate
            FROM membership_subscription ms
            JOIN membership m ON ms.MembershipID = m.MembershipID
            WHERE ms.UserID = %s AND ms.ExpiryDate > CURDATE();
        """
        cursor.execute(query_active_membership, (user_id,))
        active_membership = cursor.fetchone()

        # Other logic (e.g., bookings, first-time login)
        bookings = get_user_bookings(user_id)
        user_details = get_user_details(user_id)

        if user_details is None:
            flash('Error fetching user details.', 'danger')
            return redirect(url_for('login'))

        first_time_login = user_details.get('LastLogin') is None
        update_last_login(user_id)

    finally:
        cursor.close()
        connection.close()

    return render_template(
        'dashboard.html',
        bookings=bookings,
        active_day_pass=active_day_pass,
        payments=payments,
        active_membership=active_membership, # Ensure payments is defined here
        first_time_login=first_time_login,
        user_details=user_details
    )


@app.route('/logout', methods=['GET'])
def logout():
    """Logs out the user and clears session variables."""
    session.pop('user_id', None)  # Remove user_id from the session
    session.clear()  # Optional: Clear the entire session to prevent lingering data
    flash('You have been logged out.', 'success')
    return redirect(url_for('login'))  # Redirect to login page


@app.route('/cancel_booking/<int:schedule_id>', methods=['POST'])
def cancel_booking(schedule_id):
    """Handles booking cancellation."""
    if 'user_id' not in session:
        flash('You need to log in to cancel a booking.', 'danger')
        return redirect(url_for('login'))

    user_id = session['user_id']
    success = cancel_booking_for_user(user_id, schedule_id)

    if success:
        flash('Booking successfully canceled.', 'success')
    else:
        flash('Failed to cancel booking. Please try again.', 'danger')

    return redirect(url_for('dashboard'))


    # Replace 123 with a sample ID
@app.route('/purchase_membership/<int:membership_id>', methods=['POST'])
def purchase_membership(membership_id):
    """Allows users to purchase a membership."""
    user_id = session.get('user_id')
    if not user_id:
        flash("Please log in to purchase a membership.", "danger")
        return redirect(url_for('login'))

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)  # Use dictionary=True to avoid tuple issues

    try:
        # Fetch membership details
        query_membership = "SELECT * FROM membership WHERE MembershipID = %s;"
        cursor.execute(query_membership, (membership_id,))
        membership = cursor.fetchone()  # Result will now be a dictionary

        if not membership:
            flash("Invalid membership plan selected.", "danger")
            return redirect(url_for('membership_plans'))

        # Calculate subscription dates
        join_date = datetime.today().date()
        expiry_date = join_date + timedelta(days=membership['DurationMonths'] * 30)  # Assuming DurationMonths is a float

        # Insert subscription into membership_subscription table
        query_subscription = """
            INSERT INTO membership_subscription (UserID, MembershipID, JoinDate, ExpiryDate)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query_subscription, (user_id, membership_id, join_date, expiry_date))
        db.commit()

        flash(f"You have successfully purchased the {membership['MembershipType']} membership!", "success")
        return redirect(url_for('dashboard'))

    except Exception as e:
        db.rollback()
        flash(f"Error processing membership: {str(e)}", "danger")
        return redirect(url_for('membership_plans'))

    finally:
        cursor.close()
        db.close()


@app.route('/view-users')
def view_users():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM gym_user")
    users = cursor.fetchall()
    cursor.close()
    db.close()
    return str(users)  # or jsonify(users) if you import jsonify



