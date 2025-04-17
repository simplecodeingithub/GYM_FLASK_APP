# from flask import Flask,render_template
from app import app  # This pulls in the app instance
from flask import render_template, request
from flask_app import app


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
    return render_template('classes.html')

@app.route('/membership-plans')
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



