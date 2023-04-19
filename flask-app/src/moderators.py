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
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone FROM Accounts;")

@moderators.route("/rentees", methods=["GET"])
def get_rentees():
    """Gets all the Rentee users accounts"""
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone FROM Accounts JOIN Rentees ON Accounts.Email = Rentees.AccountEmail;")

@moderators.route("/renters", methods=["GET"])
def get_renters():
    """Gets all the Renter users accounts"""
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone FROM Accounts JOIN Renters ON Accounts.Email = Renters.AccountEmail;")

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
        SELECT Email, FirstName, LastName, City, State, Zip, Phone, CreditCardNumber, ExpiryDate, BankName, AccountName
        FROM ((SELECT * FROM Accounts WHERE Email = '{email}') AC
        LEFT JOIN Rentees ON AC.Email = Rentees.AccountEmail)
        LEFT JOIN Renters ON AC.Email = Renters.AccountEmail;
        """
    )

@moderators.route("/users/<email>", methods=["DELETE"])
def delete_account(email):
    """Permanently deletes an account"""
    return _run_and_respond(
        f"DELETE FROM Accounts WHERE Email = '{email}';"
    )

@moderators.route("/units/<int:unitID>", methods=["DELETE"])
def delete_listing(unitID):
    """Permanently deletes an unit listing"""
    return _run_and_respond(
        f"DELETE FROM Units WHERE UnitID = {unitID};"
    )
@moderators.route("/users/<accountEmail>", methods=["PUT"])
def new_test_user(email):
    """Updates a user's account information"""
    # NOTE: currently, all optional fields are required
    form = request.form
    if "password" in form:
        password = "'" + form["password"] + "'"
    else:
        password = "NULL"
    if "firstName" in form:
        firstName = "'" + form["firstName"] + "'"
    else:
        firstName = "NULL"
    if "lastName" in form:
        lastName = "'" + form["lastName"] + "'"
    else:
        lastName = "NULL"
    if "city" in form:
        city = "'" + form["city"] + "'"
    else:
        city = "NULL"
    if "state" in form:
        state = "'" + form["state"] + "'"
    else:
        state = "NULL"
    if "zip" in form:
        zipcode = "'" + form["zip"] + "'"
    else:
        zipcode = "NULL"
    if "phone" in form:
        phone = "'" + form["phone"] + "'"
    else:
        phone = "NULL"

    return _run_and_respond(
        f"""
        UPDATE Accounts 
        SET 
            Password = CASE WHEN {password} IS NOT NULL THEN {password} ELSE Password END,
            FirstName = CASE WHEN {firstName} IS NOT NULL THEN {firstName} ELSE FirstName END,
            LastName = CASE WHEN {lastName} IS NOT NULL THEN {lastName} ELSE LastName END,
            City = CASE WHEN {city} IS NOT NULL THEN {city} ELSE City END,
            State = CASE WHEN {state} IS NOT NULL THEN {state} ELSE State END,
            Phone = CASE WHEN {phone} IS NOT NULL THEN {phone} ELSE Phone END,
            Zip =  CASE WHEN {zipcode} IS NOT NULL THEN {zipcode} ELSE Zip END,
        WHERE Email = {email};
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
