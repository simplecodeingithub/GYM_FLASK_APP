# from flask import Flask,render_template
from app import app  # This pulls in the app instance
from flask import render_template, request, url_for, flash,redirect ,session
from flask_app import app,login_manager
from flask_app.fake_data import mock_classes
from datetime import datetime, date,time, timedelta
from flask_app.models import User
from flask_app.forms.register_form import RegisterForm
from flask_app.forms.login_form import LoginForm
from flask_login import login_user, logout_user, login_required, current_user
from flask_app.data_access import get_db_connection,insert_user, check_user_by_email, generate_unique_user_id,insert_address,get_fitness_classes,get_weekly_schedule,update_last_login
from flask_app.data_access import  book_class_for_user,get_class_schedule,get_class_info,generate_recurring_schedule,calculate_end_time,get_user_bookings,get_schedule_by_days,get_user_details
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

from datetime import datetime

@app.route('/view_schedule/<int:class_id>', methods=['GET'])
def view_schedule(class_id):
    """Displays schedules grouped by DayOfWeek and formatted datetime."""
    # Get class information and schedule data (replace with your DB functions)
    class_info = get_class_info(class_id)
    schedules = get_schedule_by_days(class_id)  # Fetch schedules

    # Group and format schedules
    grouped_schedules = {}
    for schedule in schedules:
        # Format the date and time
        schedule_date = schedule['ScheduleDate']  # Assuming it's a date object
        start_time = (datetime.min + schedule['StartTime']).time()  # Convert timedelta to time
        end_time = (datetime.min + schedule['EndTime']).time()      # Convert timedelta to time

        formatted_date = schedule_date.strftime('%Y-%m-%d')
        formatted_start_time = start_time.strftime('%I:%M %p')  # 12-hour format with AM/PM
        formatted_end_time = end_time.strftime('%I:%M %p')

        # Group by DayOfWeek and ScheduleDate
        day_date_key = f"{schedule['DayOfWeek']} ({formatted_date})"
        if day_date_key not in grouped_schedules:
            grouped_schedules[day_date_key] = []

        grouped_schedules[day_date_key].append({
            'ScheduleDate': formatted_date,
            'StartTime': formatted_start_time,
            'EndTime': formatted_end_time,
            'Location': schedule['Location'],
            'AvailableSeats': schedule['AvailableSeats'],
            'ScheduleID': schedule['ScheduleID'],  # Required for booking
        })

    # Render the grouped schedules in the template
    return render_template(
        'class_schedule.html',
        class_info=class_info,
        grouped_schedules=grouped_schedules
    )



# @app.route('/view_schedule/<int:class_id>', methods=['GET'])
# def view_schedule(class_id):
#     """Displays schedules grouped by DayOfWeek and ScheduleDate."""
#     class_info = get_class_info(class_id)
#     schedules = get_schedule_by_days(class_id)  # Fetch schedules
#
#     # Group schedules by DayOfWeek and ScheduleDate
#     grouped_schedules = {}
#     for schedule in schedules:
#         # Use both DayOfWeek and ScheduleDate as grouping keys
#         day_date_key = f"{schedule['DayOfWeek']} ({schedule['ScheduleDate']})"
#         if day_date_key not in grouped_schedules:
#             grouped_schedules[day_date_key] = []
#         grouped_schedules[day_date_key].append(schedule)
#
#     return render_template(
#         'class_schedule.html',
#         class_info=class_info,
#         grouped_schedules=grouped_schedules
#     )



@app.route('/book_class/<int:schedule_id>', methods=['POST'])
def book_class(schedule_id):
    """Allows logged-in users to book a class."""
    if 'user_id' not in session:
        flash('You need to log in to book a class.', 'danger')
        return redirect(url_for('login', next=request.referrer))  # Redirect to login if user is not logged in

    user_id = session['user_id']  # Retrieve logged-in user's ID
    booking_success = book_class_for_user(user_id, schedule_id)  # Call booking logic

    if booking_success:
        flash('Class booked successfully!', 'success')
    else:
        flash('Unable to book the class. It may be full.', 'danger')

    # Redirect back to the schedule page
    return redirect(request.referrer or url_for('view_schedule', class_id=schedule_id))



@app.route('/membership_plans')
def membership_plans():
    return render_template('membership_plans.html')

@app.route('/trainers')
def trainers():
    return render_template('trainers.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/search')
def search():
    query = request.args.get('query')
    # You can customize this later to actually do something
    return f"<h2>Search Results for: <em>{query}</em></h2>"


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
    bookings = get_user_bookings(user_id)  # Fetch bookings for the logged-in user
    user_details = get_user_details(user_id)  # Fetch personal details, including LastLogin

    # Ensure user_details is not None
    if user_details is None:
        flash('Error fetching user details.', 'danger')
        return redirect(url_for('login'))

    # Check if the user is logging in for the first time
    first_time_login = user_details.get('LastLogin') is None

    # Update LastLogin timestamp (optional, to stop repeated first-time login logic)
    update_last_login(user_id)

    return render_template(
        'dashboard.html',
        bookings=bookings,
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



@app.route('/view-users')
def view_users():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM gym_user")
    users = cursor.fetchall()
    cursor.close()
    db.close()
    return str(users)  # or jsonify(users) if you import jsonify



