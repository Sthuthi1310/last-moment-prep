from flask import Flask, jsonify, request
from flask_cors import CORS
from db import get_connection

app = Flask(__name__)
CORS(app)

# Home route - just to check backend is running
@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Backend Running Successfully 🚀"})

# Test database connection
@app.route("/test-db", methods=["GET"])
def test_db():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT DATABASE();")
        result = cursor.fetchone()
        cursor.close()
        conn.close()
        return jsonify({"database": result[0]})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Example route to test POST requests
@app.route("/test-post", methods=["GET", "POST"])
def test_post():
    if request.method == "POST":
        data = request.json
        return jsonify({"received_data": data})
    else:
        return jsonify({"message": "Send a POST request to see the response"})


if __name__ == "__main__":
    app.run(debug=True)
