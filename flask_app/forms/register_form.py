from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField
from wtforms.validators import DataRequired, Email, EqualTo, Length,Regexp
from wtforms.fields import DateField

class RegisterForm(FlaskForm):
    first_name = StringField('First Name', validators=[DataRequired(), Length(max=50)])
    last_name = StringField('Last Name', validators=[DataRequired(), Length(max=50)])
    email = StringField('Email', validators=[DataRequired(), Email(), Length(max=100)])
    password = PasswordField('Password', validators=[
        DataRequired(),
        Length(min=8, message="Password must be at least 8 characters long."),
        Regexp(r'^[A-Za-z0-9@._!*#$%^&()]+$',
               message="Use only letters, numbers, or special characters.")
    ])

    confirm_password = PasswordField('Confirm Password', validators=[
        DataRequired(),
        EqualTo('password', message="Passwords must match."),
    ])
    phone = StringField('Phone', validators=[Length(max=15)])  # Optional field
    date_of_birth = DateField('Date of Birth', validators=[DataRequired()])  # New field
    # Address fields
    street = StringField('Street', validators=[DataRequired(), Length(max=255)])
    city = StringField('City', validators=[DataRequired(), Length(max=100)])
    state_region = StringField('State/Region', validators=[DataRequired(), Length(max=100)])
    postal_code = StringField('Postal Code', validators=[DataRequired(), Length(max=20)])
    country = SelectField('Country', choices=[
        ('UK', 'United Kingdom'),
        ('US', 'United States'),
        ('CA', 'Canada'),
        ('AU', 'Australia')
    ], default='UK')
    submit = SubmitField('Register')
