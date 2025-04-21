# from flask import Flask,render_template
from app import app  # This pulls in the app instance
from flask import render_template, request, url_for, flash,redirect
from flask_app import app
from flask_app.fake_data import mock_classes
from datetime import datetime, date

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

@app.route('/register')
def register():
    return render_template('register.html')

@app.route('/login')
def login():
    return render_template('login.html')


# @app.route('/book/<int:schedule_id>', methods=['POST'])
# def book_class(schedule_id):
#     # Do booking logic here...
#     return render_template('book_class.html')

