# 🏋️‍♀️ Girl Coded – Fitness Class Booking System

## 📌 Overview
**Girl Coded** is a web-based gym management application **exclusively for women**, built to streamline fitness class booking, membership access, and admin control. The system enables users to register, log in, book or cancel classes, purchase memberships or day passes, and view personal dashboards. Admins have the ability to manage users and class schedules.

---

## 🛠️ Tech Stack

- **Frontend**: HTML, CSS, Bootstrap, JavaScript  
- **Backend**: Python (Flask framework)  
- **Database**: MySQL    
- **Hosting**: Localhost / Flask server

---

## 🚀 Features

### 👩‍💻 User Functionality (Women-Only)
- 🔐 **Register/Login**: Secure user authentication
- 🏠 **Dashboard**:
  - View booked fitness classes
  - Active membership status
  - Day pass access
- 🧘 **Fitness Classes**:
  - View morning and evening classes
  - Book or cancel sessions
- 💳 **Membership**:
  - Choose a membership plan for extended access
- 🎟️ **Day Pass**:
  - Purchase a one-day gym access pass

### 🛠️ Admin Functionality
- 🔐 **Admin Register/Login**: Separate admin access route
- 👥 **Manage Users**: View and manage registered women users
- 📅 **Manage Classes**: Add, update, or delete class schedules and instructors

---

## 🧭 Routes Summary

| Route | Description |
|-------|-------------|
| `/` | Home page |
| `/about` | About Girl Coded Gym |
| `/services` | Services dropdown |
| `/services/fitness-classes` | View/book fitness classes |
| `/services/membership` | Choose a membership plan |
| `/services/day-pass` | Purchase a day pass |
| `/services/on-demand` | Access workout videos on demand |
| `/instructors` | View all gym instructors |
| `/nutrition-coaching` | Explore nutrition plans |
| `/contact-us` | Submit contact form |
| `/search-options` | Search and filter classes |
| `/dashboard` | User dashboard |
| `/login` | User login |
| `/register` | User registration |
| `/admin-register` | Admin login/registration |

---

## 🗃️ Database Schema (MySQL)

| Table | Description |
|-------|-------------|
| `users` | Stores user info (id, name, email, password, membership_status, day_pass_status) |
| `classes` | Stores class info (id, name, time, date, instructor, status) |
| `bookings` | Stores class bookings (id, user_id, class_id, status) |
| `admins` | Stores admin info (id, name, email, password) |

---

## ⚙️ Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/simplecodeingithub/GYM_FLASK_APP.git
   cd GYM_FLASK_APP
   
2. **Create and activate a virtual environment**
   ```bash
   # Create virtual environment
   python -m venv venv

   # Activate on Windows
   venv\Scripts\activate

   # OR activate on Mac/Linux
   source venv/bin/activate
   
3. **Install required packages**
   ```bash
   pip install -r requirements.txt

4. **Configure the MySQL database**
   ```python
   # Ensure MySQL is installed and running on your system
   # Create a new database (e.g., gym_db)
   # Update your database connection in db_connection.py

   connection = mysql.connector.connect(
       host="localhost",
       user="your_mysql_username",
       password="your_mysql_password",
       database="gym_db"
   )

5. **Import the SQL file (if provided)**
   ```bash
   # Open MySQL Workbench
   # Import the .sql file into your gym_db database to create the required tables

6. **Run the Flask application**
   ```bash
   python app.py

7. **Access the application**
   ```bash
   http://127.0.0.1:5000/






