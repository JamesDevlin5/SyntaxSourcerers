   from flask import Blueprint, request

from src import _run_and_respond

moderators = Blueprint("moderators", __name__)


@moderators.route("/units", methods=["GET"])
def get_units():
    """Example"""
    # Can remove this whenever
    return _run_and_respond("SELECT * FROM Units;")

@moderators.route("/users", methods=["GET"])
def get_users():
    """Gets all the users accounts"""
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone, Banned FROM Accounts;")

@moderators.route("/users", methods=["GET"])
def get_rentees():
    """Gets all the Rentee users accounts"""
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone, Banned FROM Accounts JOIN Rentees ON Accounts.Email = Rentees.AccountEmail;")

@moderators.route("/users", methods=["GET"])
def get_renters():
    """Gets all the Renter users accounts"""
    return _run_and_respond("SELECT Email, FirstName, LastName, City, State, Zip, Phone, Banned FROM Accounts JOIN Renters ON Accounts.Email = Renters.AccountEmail;")

@moderators.route("/users/<accountEmail>", methods=["PUT"])
def ban_user(accountEmail):
    """Bans the user's account"""
    return _run_and_respond(
        f"UPDATE Accounts SET Banned = 1 WHERE Email = {accountEmail};"
    )

@moderators.route("/users/<accountEmail>", methods=["PUT"])
def unban_user(accountEmail):
    """Unbans the user's account"""
    return _run_and_respond(
        f"UPDATE Accounts SET Banned = 0 WHERE Email = {accountEmail};"
    )

@moderators.route("/users/<accountEmail>", methods=["GET"])
def get_user(accountEmail):
    """Gets the details of a user's account"""
    return _run_and_respond(
        f"""
        SELECT Email, FirstName, LastName, City, State, Zip, Phone, Banned, CreditCardNumber, ExpiryDate, BankName, AccountName
        FROM ((SELECT * FROM Accounts WHERE Email = {accountEmail}) AC
        LEFT JOIN Rentees ON AC.Email = Rentees.AccountEmail)
        LEFT JOIN Renters ON AC.Email = Renters.AccountEmail;
        """
    )
@moderators.route("/users/<email>", methods=["DELETE"])
def delete_account(email):
    """Permanently deletes an account"""
    return _run_and_respond(
        f"""DELETE FROM Accounts WHERE Email = {email};
        """
    )
@moderators.route("/units/<unitID>", methods=["DELETE"])
def delete_listing(unitID):
    """Permanently deletes an unit listing"""
    return _run_and_respond(
        f"""DELETE FROM Units WHERE UnitID = {unitID};
        """
    )
@moderators.route("/users/<accountEmail>", methods=["PUT"])
def new_test_user(email):
    """Updates a user's account information"""
    # NOTE: currently, all optional fields are required
    form = request.form
    password = form.get("password", None)
    firstName = form.get("firstName", None)
    lastName = form.get("lastName", None)
    city = form.get("city", None)
    state = form.get("state", None)
    zipcode = form.get("zip", None)
    phone = form.get("phone", None)
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
