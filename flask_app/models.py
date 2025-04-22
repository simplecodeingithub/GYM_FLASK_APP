from flask_login import UserMixin

class User(UserMixin):
    def __init__(self, id, first_name, last_name, email, password, phone=None):
        self.id = id  # This is required for Flask-Login to identify the user
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.password = password
        self.phone = phone

    @staticmethod
    def get(user_id):
        # Fetch user from the database
        from flask_app.data_access import get_db_connection  # Avoid circular imports
        db = get_db_connection()
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT * FROM gym_user WHERE UserID = %s", (user_id,))
        user_data = cursor.fetchone()
        cursor.close()
        db.close()

        if user_data:
            return User(
                id=user_data['UserID'],
                first_name=user_data['FirstName'],
                last_name=user_data['LastName'],
                email=user_data['Email'],
                password=user_data['Password'],
                phone=user_data.get('PhoneNumber')
            )
        return None
