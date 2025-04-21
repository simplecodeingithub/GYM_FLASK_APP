from datetime import date, timedelta

def generate_day_of_week(d):
    return d.strftime('%A')

# # Base start date (Monday)
# base_date = date(2025, 4, 21)

# Always use the current Monday as base
today = date.today()
base_date = today - timedelta(days=today.weekday())  # gets this week's Monday

mock_classes = [
    {
        "ClassID": 1,
        "ClassName": "Yoga",
        "Description": "Peaceful yoga session...",
        "schedule": [
            {
                "ScheduleID": 100 + i,
                "ScheduleDate": base_date + timedelta(days=offset),
                "DayOfWeek": generate_day_of_week(base_date + timedelta(days=offset)),
                "StartTime": "8:00 AM",
                "EndTime": "9:00 AM",
                "Location": "Studio A",
                "AvailableSeats": 12 - (i % 3)  # Just to vary seat availability
            }
            for i, offset in enumerate(range(0, 28, 7))  # Monday for 4 weeks
        ] + [
            {
                "ScheduleID": 200 + i,
                "ScheduleDate": base_date + timedelta(days=offset),
                "DayOfWeek": generate_day_of_week(base_date + timedelta(days=offset)),
                "StartTime": "6:00 PM",
                "EndTime": "7:00 PM",
                "Location": "Studio B",
                "AvailableSeats": 10 - (i % 4)
            }
            for i, offset in enumerate(range(3, 31, 7))  # Thursday for 4 weeks
        ]
    },
    {
        "ClassID": 2,
        "ClassName": "Strength Training",
        "Description": "Build strength and endurance...",
        "schedule": [
            {
                "ScheduleID": 300 + i,
                "ScheduleDate": base_date + timedelta(days=offset),
                "DayOfWeek": generate_day_of_week(base_date + timedelta(days=offset)),
                "StartTime": "10:00 AM",
                "EndTime": "11:00 AM",
                "Location": "Studio C",
                "AvailableSeats": 8
            }
            for i, offset in enumerate(range(1, 29, 7))  # Tuesday for 4 weeks
        ]
    }
]
