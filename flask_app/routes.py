# from flask import Flask,render_template
from app import app  # This pulls in the app instance
from flask import render_template
from flask_app import app


# def register_routes():
@app.route('/home')
def home():
    return render_template("index.html")
