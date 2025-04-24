from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired, Email ,Length, Regexp

class LoginForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[
        DataRequired(),
        Length(min=8, max=128),
        Regexp(r'^[A-Za-z0-9@._!*#$%^&()]+$',
               message="Password must contain only letters, numbers, and special characters.")
    ])
    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')
