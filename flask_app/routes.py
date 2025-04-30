# from flask import Flask,render_template
from app import app  # This pulls in the app instance
from flask import render_template, request, url_for, flash,redirect ,session
from flask_app import app,login_manager
from flask_app.fake_data import mock_classes
from datetime import datetime, date,time, timedelta
from flask_app.models import User
from flask_app.utility import get_nutrition_for_plan, get_benefits_for_plan
from flask_app.forms.register_form import RegisterForm
from flask_app.forms.login_form import LoginForm
from flask_app.forms.contact_form import ContactForm
from flask_app.errors import internal_error,not_found_error

from flask_login import login_user, logout_user, login_required, current_user
from flask_app.data_access import get_db_connection,insert_user, check_user_by_email, generate_unique_user_id,insert_address,get_fitness_classes,get_weekly_schedule,update_last_login
from flask_app.data_access import book_class_for_user,get_class_schedule,get_class_info,generate_recurring_schedules,calculate_end_time,get_user_bookings,get_schedule_by_days,get_user_details
from flask_app.data_access import cancel_booking_for_user, purchase_day_pass,add_contact_submission,get_trainers, get_admin_by_email,fetch_registered_users,fetch_fitness_classes,add_fitness_class,delete_fitness_class,edit_fitness_class
import os
from werkzeug.security import generate_password_hash
from werkzeug.security import check_password_hash

# Replace 'your_new_password' with the password you want to use
# plaintext_password = 'sarah@123'
# hashed_password = generate_password_hash(plaintext_password)
# print("New Hashed Password:", hashed_password)

# plaintext_password = 'admin@123'
# hashed_password = generate_password_hash(plaintext_password)
# print("Hashed Password:", hashed_password)

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
    recurring_schedules = generate_recurring_schedules(schedules, weeks=2)  # Generate future occurrences

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
    week_start_date = date(2025, 4, 28)  # Define the start of Week 1

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
        return redirect(url_for('login', next=request.referrer))

    user_id = session['user_id']  # Retrieve logged-in user's ID
    db_connection = get_db_connection()
    cursor = db_connection.cursor(dictionary=True)

    try:
        # Check if the user has already booked this class
        query_check_booking = """
            SELECT 1 FROM classbooking
            WHERE UserID = %s AND ScheduleID = %s AND BookingStatus = 'Booked';
        """
        cursor.execute(query_check_booking, (user_id, schedule_id))
        existing_booking = cursor.fetchone()
        if existing_booking:
            flash('You have already booked this class. Please check your schedule in your '
                  '<a href="' + url_for('dashboard') + '" class="text-pink font-weight-bold">dashboard</a>.', 'warning')
            return redirect(request.referrer or url_for('view_schedule', class_id=schedule_id))

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

        booking_result = book_class_for_user(user_id, schedule_id)
        print(f"Booking result: {booking_result}")
        if booking_result == "DuplicateBooking":
            flash('You have already booked this class. Please check your schedule in your '
                  '<a href="' + url_for('dashboard') + '" class="text-pink font-weight-bold">dashboard</a>.', 'warning')
        elif booking_result == "NoSeats":
            flash('Unable to book the class. No seats are available.', 'danger')
        elif booking_result == "Success":
            try:
                if not active_day_pass:
                    # Record payment for pay-per-class bookings
                    query_payment = """
                        INSERT INTO payment (UserID, PaymentDate, Amount, Status, PaymentType, ScheduleID)
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """
                    payment_date = datetime.now()
                    cursor.execute(query_payment,
                                   (user_id, payment_date, class_fee, 'Paid', 'PayPerClass', schedule_id))
                    db_connection.commit()
                    flash(f'Class booked successfully! 🎉 Payment of £{class_fee:.2f} recorded. View your classes in your '
                        '<a href="' + url_for('dashboard') + '" class="text-pink font-weight-bold">dashboard</a>.',
                        'success')
                else:
                    flash('Class booked successfully! 🎉 Your active Day Pass covers this booking.', 'success')
            except Exception as e:
                db_connection.rollback()
                flash(f"Error processing payment: {str(e)}", 'danger')
        else:  # Handle unexpected errors or issues in `book_class_for_user`
            flash('Unable to book the class. Please try again later.', 'danger')
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
    trainers = get_trainers()
    return render_template('instructors.html', trainers=trainers)

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

        today = datetime.today()
        age = today.year - date_of_birth.year
        if today.month < date_of_birth.month or (today.month == date_of_birth.month and today.day < date_of_birth.day):
            age -= 1  # Adjust age if birthday hasn't occurred yet this year

        # Check if age is below 18
        if age < 18:
            flash('You must be at least 18 years old to register.', 'danger')
            return redirect(url_for('register'))

        # Ensure required fields are not empty
        if not all([first_name, last_name, email, password, confirm_password]):
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

        # Check if email exists in the user table
        user_data = check_user_by_email(email)
        # Call the function to fetch admin data
        #email = 'sarah.williams@gym.com'
        admin_data = get_admin_by_email(email)
        print(admin_data)

        # if user_data is None:
        #     flash('Email does not exist. Please register first.', 'danger')
        #     return redirect(url_for('login'))# Handle user login
            # Handle user login
        if user_data:
            if check_password_hash(user_data['Password'], password):
                user = User.get(user_data['UserID'])  # Load user instance
                login_user(user)  # Flask-Login's login function
                session['user_id'] = user_data['UserID']
                session['user_role'] = 'user'  # Mark as regular user# Set user_id in session
                flash('User login successful!', 'success')

                # Redirect to the intended page or user dashboard
                next_page = request.args.get('next')
                if next_page:
                    return redirect(next_page)
                print("Session Data:", session)
                return redirect(url_for('dashboard'))  # Default redirect for users
            else:
                flash('Incorrect password for user. Please try again.', 'danger')
        elif admin_data:  # Handle admin login
            print("Admin Data:", admin_data)  # Debugging: Confirm admin data is fetched
            print("Entered Password:", password)  # Debugging: Show the entered password
            print("Stored Hashed Password:", admin_data['Password'])
            if check_password_hash(admin_data['Password'], password):
                print("Password matches!")
                session['admin_logged_in'] = True  # Set admin session
                session['user_role'] = 'admin'
                session['admin_email'] = admin_data['Email']   # Store admin email
                flash('Admin login successful!', 'success')

                print("Session Data:", session)
                # Redirect to the intended page or admin dashboard
                next_page = request.args.get('next')
                if next_page:
                    return redirect(next_page)
                return redirect(url_for('admin_dashboard'))  # Default redirect for admins
            else:
                print("Password does not match.")
                flash('Incorrect password for admin. Please try again.', 'danger')
        else:
            # Email not found in either table
            flash('Email does not exist. Please register or contact admin.', 'danger')

    return render_template('login.html', form=form)


@app.route('/admin-dashboard')
def admin_dashboard():
    # Add admin-specific functionality here
    return render_template('admin_dashboard.html')



@app.route('/dashboard', methods=['GET'])
def dashboard():
    """Display user-specific dashboard content."""
    if 'user_id' not in session:
        flash('You need to log in to access your dashboard.', 'danger')
        return redirect(url_for('login'))

    user_id = session['user_id']

    # Initialize variables
    active_day_pass = None
    payments = []
    active_membership = None
    bookings = []
    user_details = None
    first_time_login = False

    cursor = None

    try:
        # Establish database connection
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)

        # Fetch active day pass
        query_day_pass = """
            SELECT * FROM day_pass
            WHERE UserID = %s AND PurchaseDate = CURDATE() AND PassStatus = 'Active'
        """
        print("Executing query: ", query_day_pass)
        cursor.execute(query_day_pass, (user_id,))
        active_day_pass = cursor.fetchone()  # Ensure result is fetched
        print("Active Day Pass: ", active_day_pass)


        # Fetch payment history
        query_payments = """
            SELECT PaymentDate, Amount, PaymentType, Status
            FROM payment
            WHERE UserID = %s
        """
        print("Executing query: ", query_payments)
        cursor.execute(query_payments, (user_id,))
        payments = cursor.fetchall()  # Fetch all results
        print("Payments: ", payments)

        # Fetch active membership details
        query_active_membership = """
            SELECT ms.SubscriptionID, m.MembershipType, ms.JoinDate, ms.ExpiryDate
            FROM membership_subscription ms
            JOIN membership m ON ms.MembershipID = m.MembershipID
            WHERE ms.UserID = %s AND ms.ExpiryDate > CURDATE()
            ORDER BY ms.ExpiryDate DESC
            LIMIT 1;
        """
        cursor.execute(query_active_membership, (user_id,))
        active_membership = cursor.fetchone()
        print("Active Membership: ", active_membership)

        # Fetch bookings and user details
        bookings = get_user_bookings(user_id)
        user_details = get_user_details(user_id)

        if user_details is None:
            flash('Error fetching user details.', 'danger')
            return redirect(url_for('login'))

        # Check for first-time login
        first_time_login = user_details.get('LastLogin') is None
        update_last_login(user_id)

    except Exception as e:
        print("Error occurred during database operation: ", e)
        flash('A database error occurred. Please try again later.', 'danger')
        return redirect(url_for('login'))

    except Exception as e:
        print("Unexpected error: ", e)
        flash('An unexpected error occurred. Please try again later.', 'danger')
        return redirect(url_for('login'))

    finally:
        # Safely close cursor
        if cursor:
            try:
                cursor.close()
            except Exception as e:
                print("Error closing cursor:", e)
        # Close connection explicitly
        if db:
            try:
                db.close()
            except Exception as e:
                print("Error closing connection:", e)

    return render_template(
        'dashboard.html',
        bookings=bookings,
        active_day_pass=active_day_pass,
        payments=payments,
        active_membership=active_membership,
        first_time_login=first_time_login,
        user_details=user_details
    )



@app.route('/logout', methods=['GET'])
def logout():
    """Logs out the user and clears session variables."""
    session.pop('user_id', None)  # Remove user_id from the session
    session.pop('admin_logged_in', None)
    session.pop('user_role', None)  # Clear role
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
    cursor = db.cursor(dictionary=True)

    try:
        # Fetch user details to check for first-time login and update LastLogin
        query_user = "SELECT * FROM gym_user WHERE UserID = %s"
        cursor.execute(query_user, (user_id,))
        user_details = cursor.fetchone()

        if not user_details:
            flash("User not found.", "danger")
            return redirect(url_for('login'))

        # First-time login check and update LastLogin
        first_time_login = user_details.get('LastLogin') is None
        if first_time_login:
            flash("Welcome! This is your first login. Let's get started!", "success")
        update_last_login(user_id)

        # Fetch membership details
        query_membership = "SELECT MembershipType, DurationMonths, Price FROM membership WHERE MembershipID = %s;"
        cursor.execute(query_membership, (membership_id,))
        membership = cursor.fetchone()

        if not membership:
            flash("Invalid membership plan selected.", "danger")
            return redirect(url_for('membership_plans'))

        # Check for active membership
        query_active_membership = """
            SELECT ms.*, m.MembershipType
            FROM membership_subscription ms
            JOIN membership m ON ms.MembershipID = m.MembershipID
            WHERE ms.UserID = %s AND ms.ExpiryDate >= %s
            ORDER BY ms.ExpiryDate DESC
            LIMIT 1;
        """
        join_date = datetime.today().date()
        cursor.execute(query_active_membership, (user_id, join_date))
        active_membership = cursor.fetchone()

        if active_membership:
            flash(f"You already have an active {active_membership['MembershipType']} membership until {active_membership['ExpiryDate']}.", "info")
            return redirect(url_for('dashboard'))

        # Calculate expiry date for new subscription
        expiry_date = join_date + timedelta(days=membership['DurationMonths'] * 30)

        # Insert new subscription
        query_subscription = """
            INSERT INTO membership_subscription (UserID, MembershipID, JoinDate, ExpiryDate)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query_subscription, (user_id, membership_id, join_date, expiry_date))

        query_payment = """
                    INSERT INTO payment (PaymentDate, Amount, Status, PaymentType, UserID)
                    VALUES (%s, %s, %s, %s, %s)
                """
        payment_date = datetime.now()
        payment_status = 'Paid'
        cursor.execute(query_payment,
                       (payment_date, membership['Price'], payment_status, 'Membership Purchase', user_id))

        # Update user's MembershipID in the gym_user table
        query_update_user = """
            UPDATE gym_user
            SET MembershipID = %s
            WHERE UserID = %s
        """
        cursor.execute(query_update_user, (membership_id, user_id))

        db.commit()
        flash(f"You have successfully purchased the {membership['MembershipType']} membership!", "success")
        return redirect(url_for('dashboard'))

    except Exception as e:
        db.rollback()
        print(f"Error occurred: {e}")  # Debugging purposes
        flash("An error occurred while processing your membership. Please try again later.", "danger")
        return redirect(url_for('membership_plans'))

    finally:
        cursor.close()
        db.close()


# Admin pages

@app.route('/view-registered-users')
def view_registered_users():
    users = fetch_registered_users()  # Fetch data from the database
    return render_template('view_registered_users.html', users=users)


@app.route('/manage-classes', methods=['GET'])
def manage_classes():
    classes = fetch_fitness_classes()
    return render_template('manage_classes.html', classes=classes)

# Admin Routes for Fitness Classes

@app.route('/add-class-form', methods=['GET'])
def add_class_form():
    return render_template('add_class_form.html')  # HTML form for adding a class


@app.route('/add-class', methods=['POST'])
def add_class_route():
    class_name = request.form['class_name']
    description = request.form['description']
    price = float(request.form['price']) if request.form['price'] else None
    max_participants = int(request.form['max_participants']) if request.form['max_participants'] else None
    image_url = request.form['image_url']
    add_fitness_class(class_name, description, price, max_participants, image_url)
    return redirect(url_for('manage_classes'))



@app.route('/nutrition')
def nutrition():
    return render_template('nutrition_details.html')



@app.route('/on_demand')
def on_demand():
    return render_template('on_demand.html')


@app.route('/test-500')
def test_500():
    raise Exception("Intentional 500 error for testing")


# @app.route('/edit-class-form', methods=['GET'])
# def edit_class_form():
#     return render_template('edit_class_form.html')  # HTML form for adding a class
#
# @app.route('/edit-class/<int:class_id>', methods=['POST'])
# def edit_class_route(class_id):
#     class_name = request.form['class_name']
#     description = request.form['description']
#     price = float(request.form['price']) if request.form['price'] else None
#     max_participants = int(request.form['max_participants']) if request.form['max_participants'] else None
#     image_url = request.form['image_url']
#     edit_fitness_class(class_id, class_name, description, price, max_participants, image_url)
#     return redirect(url_for('manage_classes'))
#
# @app.route('/delete-class-form', methods=['GET'])
# def delete_class_form():
#     return render_template('delete_class_form.html')  # HTML form for adding a class
#
# @app.route('/delete-class/<int:class_id>', methods=['POST'])
# def delete_class_route(class_id):
#     delete_fitness_class(class_id)
#     return redirect(url_for('manage_classes'))
#

