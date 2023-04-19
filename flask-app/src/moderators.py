from flask import Blueprint, request, jsonify, make_response
from src import db


def _run_and_respond(query):
    """Helper Method:
    Runs the given SQL against the database, returning the JSON-ified results"""
    cursor = db.get_db().cursor()
    cursor.execute(query)
    json_list = []
    # Post doesn't return any data -> desc field is null
    if cursor.description:
        row_headers = [desc[0] for desc in cursor.description]
        data = cursor.fetchall()
        for row in data:
            json_list.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_list))
    response.status_code = 200
    response.mimetype = "application/json"
    return response

moderators = Blueprint("moderators", __name__)

@moderators.route("/users", methods=["GET"])
def get_users():
    """Gets all the users accounts"""
    # NOTE: if you get field `Banned` the flask function `jsonify` (above) doesn't know how to decode a 1/0 into True/False and usually errors out
    # Probably could be fixed but eh
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone, Banned = 1 AS isBanned FROM Accounts;")

@moderators.route("/rentees", methods=["GET"])
def get_rentees():
    """Gets all the Rentee users accounts"""
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone, Banned = 1 AS isBanned FROM Accounts JOIN Rentees ON Accounts.Email = Rentees.AccountEmail;")

@moderators.route("/renters", methods=["GET"])
def get_renters():
    """Gets all the Renter users accounts"""
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone, Banned = 1 AS isBanned FROM Accounts JOIN Renters ON Accounts.Email = Renters.AccountEmail;")

@moderators.route("/users/ban/<email>", methods=["PUT"])
def ban_user(email):
    """Bans the user's account"""
    return _run_and_respond(
        f"UPDATE Accounts SET Banned = 1 WHERE Email = '{email}';"
    )

@moderators.route("/users/unban/<email>", methods=["PUT"])
def unban_user(email):
    """Unbans the user's account"""
    return _run_and_respond(
        f"UPDATE Accounts SET Banned = 0 WHERE Email = '{email}';"
    )

@moderators.route("/users/<email>", methods=["GET"])
def get_user(email):
    """Gets the details of a user's account"""
    return _run_and_respond(
        f"""
        SELECT Email, FirstName, LastName, City, State, Zip, Phone, Banned = 1 AS isBanned, CreditCardNumber, ExpiryDate, BankName, AccountName
        FROM ((SELECT * FROM Accounts WHERE Email = '{email}') AC
        LEFT JOIN Rentees ON AC.Email = Rentees.AccountEmail)
        LEFT JOIN Renters ON AC.Email = Renters.AccountEmail;
        """
    )
@moderators.route("/units/<unitID>", methods=["GET"])
def get_listing(unitID):
    """Permanently deletes an unit listing"""
    return _run_and_respond(
        f"""SELECT * FROM Units WHERE UnitID = '{unitID}';
        """
    )
@moderators.route("/units/<unitID>", methods=["DELETE"])
def delete_listing(unitID):
    """Permanently deletes an unit listing"""
    return _run_and_respond(
        f"""DELETE FROM Units WHERE UnitID = '{unitID}';
        """
    )

@moderators.route("/users/<email>", methods=["POST"])
def new_test_user(email):
    """Creates a new test user"""
    # NOTE: currently, all optional fields are required
    form = request.form
    password = form["password"]
    firstName = form["firstName"]
    lastName = form["lastName"]
    city = form["city"]
    state = form["state"]
    zipcode = form["zip"]
    phone = form["phone"]
    return _run_and_respond(
        f"""
        INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone, Banned)
        VALUES ('{email}', '{password}', '{firstName}', '{lastName}', '{city}', '{state}', '{zipcode}', '{phone}', 0);
        """
    )
