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
