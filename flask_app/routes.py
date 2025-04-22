# from flask import Flask,render_template
from app import app  # This pulls in the app instance
from flask import render_template, request, url_for, flash,redirect
from flask_app import app,login_manager
from flask_app.fake_data import mock_classes
from datetime import datetime, date
from flask_app.models import User
from flask_app.forms.register_form import RegisterForm
from flask_app.forms.login_form import LoginForm
from flask_login import login_user, logout_user, login_required, current_user
from flask_app.data_access import get_db_connection,insert_user, check_user_by_email, generate_unique_user_id,insert_address
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
    selected_date_str = request.args.get('date')
    selected_date = None
    filtered_classes = []

    if selected_date_str:
        selected_date = datetime.strptime(selected_date_str, '%Y-%m-%d').date()
        for cls in mock_classes:
            filtered_schedule = [
                s for s in cls['schedule'] if s['ScheduleDate'] == selected_date
            ]
            if filtered_schedule:
                filtered_classes.append({
                    **cls,
                    "schedule": filtered_schedule
                })
    else:
        filtered_classes = mock_classes

    return render_template('classes.html', classes=filtered_classes, selected_date=selected_date_str)

@app.route('/book_class/<int:schedule_id>')
def book_class(schedule_id):
    for cls in mock_classes:
        for schedule in cls["schedule"]:
            if schedule["ScheduleID"] == schedule_id:
                if schedule["AvailableSeats"] > 0:
                    schedule["AvailableSeats"] -= 1
                    flash("Successfully booked!", "success")
                else:
                    flash("Sorry, no seats available!", "danger")
                break
    return redirect(url_for('classes'))



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

        if check_user_by_email(email):
            flash('Email already exists. Please use a different one.', 'danger')
            return redirect(url_for('register'))

        if password != confirm_password:
            flash('Passwords do not match!', 'danger')
            return redirect(url_for('register'))

        try:
            print("Inserting address...")
            address_id = insert_address(street, city, state_region, postal_code, country)
            print(f"Address inserted successfully with AddressID: {address_id}")
            if not address_id:
                raise Exception("Address insertion failed.")

            print("Inserting user...")
            hashed_password = generate_password_hash(password)
            print(f"Calling insert_user with: {first_name}, {last_name}, {email}, {hashed_password}, {phone}, {address_id}, {date_of_birth}")
            insert_user(first_name, last_name, email, hashed_password, phone, address_id, date_of_birth)
            print("User successfully inserted.")
        except Exception as e:
            flash(f"Error during registration: {e}", 'danger')
            return redirect(url_for('register'))

        flash('Registration successful! Please log in.', 'success')
        return redirect(url_for('login'))

    return render_template('register.html', form=form)


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()

    if form.validate_on_submit():  # Ensure this runs only on POST with valid data
        email = form.email.data.strip().lower()  # Normalize email format
        password = form.password.data

        # Retrieve user data from the database
        user_data = check_user_by_email(email)
        if user_data is None:
            flash('Email does not exist. Please register first.', 'danger')
            return redirect(url_for('login'))

        # Check password validity
        if check_password_hash(user_data['Password'], password):
            user = User.get(user_data['UserID'])  # Load user via User model
            login_user(user)
            flash('Login successful!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Incorrect password. Please try again.', 'danger')

    return render_template('login.html', form=form)  # Pass the form to the template

@app.route('/dashboard')
@login_required  # Protect the dashboard route
def dashboard():
    # Access the current user's information via `current_user`
    email = current_user.email
    return render_template('dashboard.html', email=email)


@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("You've been logged out.", "info")
    return redirect(url_for('login'))


@app.route('/view-users')
def view_users():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM gym_user")
    users = cursor.fetchall()
    cursor.close()
    db.close()
    return str(users)  # or jsonify(users) if you import jsonify

# @app.route('/book/<int:schedule_id>', methods=['POST'])
# def book_class(schedule_id):
#     # Do booking logic here...
#     return render_template('book_class.html')

