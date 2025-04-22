from flask import Flask
import os
from flask_login import LoginManager

app = Flask(__name__)

# Generate a random secret key for sessions and CSRF protection
SECRET_KEY = os.urandom(32)
app.config['SECRET_KEY'] = SECRET_KEY

# Initialize LoginManager
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'  # Redirect unauthenticated users to the login page

# Import routes and models after initializing the app
from flask_app import routes
from flask_app.models import User
from flask_app.data_access import get_db_connection

@login_manager.user_loader
def load_user(user_id):
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM gym_user WHERE UserID = %s", (user_id,))
    user_data = cursor.fetchone()
    cursor.close()
    db.close()

    if user_data:
        return User(id=user_data['UserID'], first_name=user_data['FirstName'], last_name=user_data['LastName'],
                    email=user_data['Email'], password=user_data['Password'], phone=user_data.get('PhoneNumber'))
    return None
