import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Sthuthi@sql13",
        database="study_tracker"  # change to your db name
    )
