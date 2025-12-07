from flask import Blueprint, request, jsonify
from services.subject_service import add_subject, get_subjects

subject = Blueprint("subject", __name__)

@subject.route("/subjects", methods=["POST"])
def create_subject():
    data = request.json
    result = add_subject(data["user_id"], data["subject_name"])
    return jsonify(result)

@subject.route("/subjects/<int:user_id>", methods=["GET"])
def fetch_subjects(user_id):
    subjects = get_subjects(user_id)
    return jsonify(subjects)
