from db import get_connection

def add_subject(user_id, subject_name):
    conn = get_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "INSERT INTO subjects (user_id, subject_name) VALUES (%s, %s)",
            (user_id, subject_name)
        )
        conn.commit()
        return {"message": "Subject added successfully"}
    except Exception as e:
        return {"error": str(e)}
    finally:
        conn.close()


def get_subjects(user_id):
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT subject_id, subject_name FROM subjects WHERE user_id=%s",
        (user_id,)
    )
    subjects = cursor.fetchall()
    conn.close()

    return subjects
