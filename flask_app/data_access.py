import mysql.connector
from mysql.connector import Error
from werkzeug.security import generate_password_hash
from werkzeug.security import check_password_hash
from datetime import datetime, timedelta


def get_db_connection():
    """
    This function establishes and returns a connection to the MySQL database.
    """
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",  # Your MySQL username
            password="password",  # Your MySQL password
            database="gym_app",  # Your database name
            autocommit=True  # Auto commit to immediately save changes
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

def execute_query(query, params=None):
    """
    Executes a single query. Optionally accepts parameters to pass to the query.
    Returns the result of the query if it’s a SELECT statement.
    """
    connection = get_db_connection()
    if connection is None:
        return None
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params or ())
        if query.strip().upper().startswith('SELECT'):
            result = cursor.fetchall()  # Return all rows for SELECT queries
            return result
        connection.commit()  # Commit for other queries (INSERT, UPDATE, DELETE)
    except Error as err:
        print(f"Error executing query: {err}")
    finally:
        cursor.close()
        connection.close()

def insert_address(street, city, state_region, postal_code, country):
    """
    Insert address into the 'address' table and return the AddressID of the newly inserted row.
    """
    db = get_db_connection()
    cursor = db.cursor()
    try:
        cursor.execute("""
            INSERT INTO address (Street, City, StateRegion, PostalCode, Country)
            VALUES (%s, %s, %s, %s, %s)
        """, (street, city, state_region, postal_code, country))
        db.commit()
        address_id = cursor.lastrowid  # Get the AddressID of the newly inserted address
        print(f"Address inserted with AddressID: {address_id}")
        return address_id
    except mysql.connector.Error as err:
        print(f"Error inserting address: {err}")
        return None
    finally:
        cursor.close()
        db.close()

def insert_user(first_name, last_name, email, password, phone, address_id, date_of_birth, membership_id=None):
    """
    Insert a new user into the gym_user table using the AddressID obtained after inserting the user's address.
    """
    db = get_db_connection()
    cursor = db.cursor()

    user_id = f"GMUK{str(generate_unique_user_id()).zfill(4)}"
    print(f"Generated UserID: {user_id}")

    try:
        print(f"Inserting user with UserID: {user_id}, FirstName: {first_name}, LastName: {last_name}, Email: {email}, Password: {password}, Phone: {phone}, DateOfBirth: {date_of_birth}, AddressID: {address_id}, MembershipID: {membership_id}")

        cursor.execute("""
            INSERT INTO gym_user (UserID, FirstName, LastName, Email, Password, PhoneNumber, AddressID, MembershipID, DateOfBirth)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (user_id, first_name, last_name, email, password, phone, address_id, membership_id, date_of_birth))

        print(f"Query executed. Rows affected: {cursor.rowcount}")
        db.commit()
        print(f"User {first_name} {last_name} inserted successfully!")

    except mysql.connector.Error as err:
        print(f"Error inserting user: {err}")
    finally:
        cursor.close()
        db.close()


def check_user_by_email(email):
    """
    Check if a user with the given email exists in the database.
    Returns user data if exists, None otherwise.
    """
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)  # Use dictionary to get the result as a dict
    cursor.execute("SELECT * FROM gym_user WHERE Email = %s", (email,))
    user_data = cursor.fetchone()  # Fetch the first matching result
    cursor.close()
    db.close()
    return user_data  # Returns None if no user is found, or the user data if exists

def generate_unique_user_id():
    """
    Generate a unique UserID by finding the highest existing GMUK ID and incrementing it.
    """
    db = get_db_connection()
    cursor = db.cursor()

    cursor.execute("""
        SELECT UserID 
        FROM gym_user 
        WHERE UserID LIKE 'GMUK%' 
        ORDER BY CAST(SUBSTRING(UserID, 5) AS UNSIGNED) DESC 
        LIMIT 1
    """)
    result = cursor.fetchone()
    cursor.close()
    db.close()

    if result:
        last_id = result[0]  # e.g., "GMUK1006"
        next_number = int(last_id[4:]) + 1
    else:
        next_number = 1001  # Starting point if no users exist

    return next_number


def get_fitness_classes():
    """
    Fetches all fitness classes from the database, including class ID, class name, description, and image URL.
    """
    try:
        # Establish a database connection
        connection = get_db_connection()
        if connection is None:
            print("Failed to connect to the database.")
            return []

        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()

        # Update query to include class_id
        query = "SELECT class_id, class_name, description, image_url FROM fitness_class"

        # Execute the query
        cursor.execute(query)
        results = cursor.fetchall()

        # Close the connection
        cursor.close()
        connection.close()

        # Return the fetched results
        return results
    except Error as e:
        print(f"Error fetching data from database: {e}")
        return []


def get_class_schedule(class_id, date=None, start_time=None):
    """Fetch schedules for a specific fitness class, with optional filters."""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    query = """
        SELECT 
            cs.ScheduleDate, 
            cs.DayOfWeek, 
            cs.Location, 
            cs.StartTime, 
            cs.EndTime, 
            cs.AvailableSeats, 
            cs.ScheduleID, 
            fc.Price
        FROM class_schedule cs
        JOIN fitness_class fc ON cs.ClassID = fc.ClassID
        WHERE cs.ClassID = %s
    """
    params = [class_id]

    if date:
        query += " AND cs.ScheduleDate = %s"
        params.append(date)
    if start_time:
        query += " AND cs.StartTime >= %s"
        params.append(start_time)

    query += " ORDER BY cs.ScheduleDate, cs.StartTime"

    try:
        cursor.execute(query, params)
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def get_weekly_schedule(class_id):
    """Fetch schedules for the current week, including price."""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    query = """
        SELECT 
            cs.*, 
            fc.Price, 
            DATE_ADD(CURDATE(), INTERVAL (WEEKDAY(CURDATE()) - WEEKDAY(cs.ScheduleDate)) DAY) AS NextOccurrence
        FROM class_schedule cs
        JOIN fitness_class fc ON cs.ClassID = fc.ClassID
        WHERE cs.ClassID = %s
        AND (cs.DayOfWeek IS NULL OR cs.DayOfWeek = DAYNAME(CURDATE()))
        ORDER BY NextOccurrence, cs.StartTime
    """
    try:
        cursor.execute(query, (class_id,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def get_class_info(class_id):
    """Fetch class details for a specific class."""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM fitness_class WHERE class_id = %s", (class_id,))
        result = cursor.fetchone()
        if result is None:
            raise ValueError(f"No class found with class_id = {class_id}")
        return result
    except Exception as e:
        print(f"Error fetching class info: {e}")  # Log the error
        return None
    finally:
        cursor.close()
        connection.close()



def book_class_for_user(user_id, schedule_id):
    """Books a class for the user and reduces available seats."""
    connection = get_db_connection()
    cursor = connection.cursor()
    try:
        cursor.execute("SELECT AvailableSeats FROM class_schedule WHERE ScheduleID = %s", (schedule_id,))
        schedule = cursor.fetchone()

        print(f"Schedule fetched: {schedule}")  # Debug log

        if schedule and schedule[0] > 0:  # Access tuple by index
            cursor.execute("""
                INSERT INTO classbooking (UserID, ScheduleID, BookingDate, BookingStatus)
                VALUES (%s, %s, NOW(), 'Booked')
            """, (user_id, schedule_id))

            print(f"Inserted booking for UserID: {user_id}, ScheduleID: {schedule_id}")  # Debug log

            cursor.execute("""
                UPDATE class_schedule
                SET AvailableSeats = AvailableSeats - 1
                WHERE ScheduleID = %s
            """, (schedule_id,))
            connection.commit()

            print(f"Reduced available seats for ScheduleID: {schedule_id}")  # Debug log
            return True
        else:
            print("No available seats or schedule not found.")  # Debug log
            return False
    except Exception as e:
        print(f"Error during booking: {e}")
        return False
    finally:
        cursor.close()
        connection.close()



def get_user_bookings(user_id):
    """Fetch bookings for the logged-in user."""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT 
                cb.BookingStatus, 
                cs.ScheduleDate, 
                cs.StartTime, 
                fc.class_name, 
                cs.ScheduleID,
                CONCAT(t.FirstName, ' ', t.LastName) AS TrainerName -- Added TrainerName
            FROM 
                classbooking cb
            JOIN 
                class_schedule cs ON cb.ScheduleID = cs.ScheduleID
            JOIN 
                fitness_class fc ON cs.class_id = fc.class_id
            JOIN 
                trainer t ON cs.TrainerID = t.TrainerID -- Join with trainer table
            WHERE 
                cb.UserID = %s
            ORDER BY 
                cs.ScheduleDate, cs.StartTime
        """, (user_id,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


def cancel_booking_for_user(user_id, schedule_id):
    """Cancels a booking for the user and increases available seats."""
    connection = get_db_connection()
    cursor = connection.cursor()
    try:
        # Delete booking record for the user and schedule
        cursor.execute("""
            DELETE FROM classbooking 
            WHERE UserID = %s AND ScheduleID = %s
        """, (user_id, schedule_id))

        # Update available seats for the class
        cursor.execute("""
            UPDATE class_schedule
            SET AvailableSeats = AvailableSeats + 1
            WHERE ScheduleID = %s
        """, (schedule_id,))
        connection.commit()

        print(f"Booking canceled for UserID: {user_id}, ScheduleID: {schedule_id}")  # Debug log
        return True
    except Exception as e:
        print(f"Error during cancellation: {e}")  # Debug log
        return False
    finally:
        cursor.close()
        connection.close()

def get_schedule_by_days(class_id):
    """Fetch schedules grouped by days of the week for a specific class, including price."""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    try:
        query = """
            SELECT 
                cs.ScheduleDate, 
                cs.DayOfWeek, 
                cs.Location, 
                cs.StartTime, 
                cs.EndTime, 
                cs.AvailableSeats, 
                cs.ScheduleID, 
                fc.Price  -- Fetch Price from fitness_class table
            FROM class_schedule cs
            JOIN fitness_class fc ON cs.class_id = fc.class_id  -- Join on class_id
            WHERE cs.class_id = %s
            ORDER BY cs.ScheduleDate, cs.StartTime;
        """
        cursor.execute(query, (class_id,))
        return cursor.fetchall()
    finally:
        cursor.close()
        connection.close()


# def get_schedule_by_days(class_id):
#     """Fetch schedules grouped by days of the week for a specific class."""
#     connection = get_db_connection()
#     cursor = connection.cursor(dictionary=True)
#     try:
#         query = """
#             SELECT
#                 ScheduleDate,
#                 DayOfWeek,
#                 Location,
#                 StartTime,
#                 EndTime,
#                 AvailableSeats,
#                 ScheduleID
#             FROM class_schedule
#             WHERE class_id = %s
#             ORDER BY ScheduleDate,
#                 FIELD(DayOfWeek, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
#                 StartTime;
#         """
#         cursor.execute(query, (class_id,))
#         return cursor.fetchall()
#     finally:
#         cursor.close()
#         connection.close()


def update_last_login(user_id):
    """Update the LastLogin timestamp for a user."""
    connection = get_db_connection()
    cursor = connection.cursor()
    try:
        cursor.execute("UPDATE gym_user SET LastLogin = NOW() WHERE UserID = %s", (user_id,))
        connection.commit()
    finally:
        cursor.close()
        connection.close()

def get_user_details(user_id):
    """Fetch personal details for the user."""
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT UserID, FirstName, LastName, Email, LastLogin
            FROM gym_user
            WHERE UserID = %s
        """, (user_id,))
        user_details = cursor.fetchone()
        print(f"User details fetched: {user_details}")  # Debug log
        return user_details
    finally:
        cursor.close()
        connection.close()



def generate_recurring_schedules(schedules, weeks=4):
    """Generate recurring schedules for the next `weeks` for the same days of the week."""
    recurring_schedules = []
    for schedule in schedules:
        for week in range(weeks):
            new_schedule = schedule.copy()
            new_schedule['ScheduleDate'] += timedelta(days=7 * week)  # Repeat every 7 days
            recurring_schedules.append(new_schedule)
    return recurring_schedules

def calculate_end_time(start_time, duration):
    """
    Calculates the end time given a start time and duration.
    :param start_time: Start time (e.g., '09:00:00')
    :param duration: Duration in hours
    :return: End time as string
    """
    start_time_obj = datetime.strptime(start_time, '%H:%M:%S')
    end_time_obj = start_time_obj + timedelta(hours=duration)
    return end_time_obj.strftime('%H:%M:%S')


def purchase_day_pass(db, user_id):
    """Process the purchase of a Day Pass for the user."""
    if not user_id:
        return {"status": "error", "message": "Invalid user ID provided."}

    if not db.is_connected():
        return {"status": "error", "message": "Database connection is not active."}

    cursor = db.cursor(dictionary=True)

    try:
        # Check if the user already has an active Day Pass for today
        query_check = """
            SELECT * FROM day_pass
            WHERE UserID = %s AND PurchaseDate = CURDATE() AND PassStatus = 'Active';
        """
        cursor.execute(query_check, (user_id,))
        existing_pass = cursor.fetchone()

        if existing_pass:
            return {"status": "info", "message": "You already have an active Day Pass for today."}

        # Insert a new Day Pass record
        query_insert = """
            INSERT INTO day_pass (UserID, PurchaseDate, PassStatus)
            VALUES (%s, %s, 'Active')
        """
        purchase_date = datetime.today().date()
        cursor.execute(query_insert, (user_id, purchase_date))

        # Add a payment record
        query_payment = """
            INSERT INTO payment (UserID, PaymentDate, Amount, Status, PaymentType)
            VALUES (%s, %s, %s, %s, %s)
        """
        payment_date = datetime.now()
        amount = 20.00  # Day Pass price
        cursor.execute(query_payment, (user_id, payment_date, amount, 'Paid', 'DayPass'))

        # Commit the transaction
        db.commit()

        return {"status": "success", "message": "Day Pass purchased successfully!"}

    except Exception as e:
        # Rollback the transaction in case of an error
        print(f"Error processing Day Pass purchase: {str(e)}")  # Debug log
        db.rollback()
        return {"status": "error", "message": "Error processing Day Pass purchase. Please try again later."}

    finally:
        if cursor:
            cursor.close()

def add_contact_submission(name, email, message):
    db = get_db_connection()
    cursor = db.cursor()
    query = "INSERT INTO contact_us (Name, Email, Message) VALUES (%s, %s, %s)"
    values = (name, email, message)
    cursor.execute(query, values)
    db.commit()
    cursor.close()

def get_trainers():
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    query = "SELECT FirstName, LastName, Email, PhoneNumber, Specialization FROM Trainer"
    cursor.execute(query)
    trainers = cursor.fetchall()
    cursor.close()
    connection.close()
    return trainers


def get_admin_by_email(email):
    """
    Fetch admin details by email from the MySQL database using get_db_connection.
    :param email: The admin's email to query.
    :return: A dictionary containing admin details or None if not found.
    """
    # Use the existing get_db_connection function to connect to the database
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)  # Cursor returns results as dictionaries
    try:
        # Query the admin table for the given email
        sql_query = "SELECT * FROM admin WHERE Email = %s"
        cursor.execute(sql_query, (email,))
        admin = cursor.fetchone()  # Fetch the first matching result
        return admin  # Returns a dictionary or None
    finally:
        cursor.close()  # Ensure the cursor is closed
        connection.close()  # Ensure the connection is closed after the query
