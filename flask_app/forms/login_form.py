from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired, Email ,Length, Regexp

class LoginForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[
        DataRequired(message="Password is required."),
        Length(min=8, message="Password must be at least 8 characters long."),
        Regexp(r'^[A-Za-z0-9@._!*#$%^&()]+$',
               message="Use only letters, numbers, or special characters.")
    ])
    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')
