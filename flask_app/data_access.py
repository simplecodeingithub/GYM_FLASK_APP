import mysql.connector
from mysql.connector import Error
from werkzeug.security import generate_password_hash
from werkzeug.security import check_password_hash


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
    Fetches all fitness classes from the database, including class name, description, and image URL.
    """
    try:
        # Establish a database connection
        connection = get_db_connection()
        if connection is None:
            print("Failed to connect to the database.")
            return []

        # Create a cursor object to execute SQL queries
        cursor = connection.cursor()
        query = "SELECT class_name, description, image_url FROM fitness_class"

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
