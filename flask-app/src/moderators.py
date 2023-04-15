from flask import Blueprint, request

from src import _run_and_respond

moderators = Blueprint("moderators", __name__)


@moderators.route("/units", methods=["GET"])
def get_units():
    """Example"""
    return _run_and_respond("SELECT * FROM Units;")
