# Some set up for the application

from flask import Flask, jsonify, make_response
from flaskext.mysql import MySQL

# Import the various routes (Blueprints)
from src.sellers import sellers
from src.moderators import moderators
from src.views import views

# from src.customers.customers import customers
# from src.products.products  import products

# create a MySQL object that we will use in other parts of the API
db = MySQL()


def create_app():
    app = Flask(__name__)

    # secret key that will be used for securely signing the session
    # cookie and can be used for any other security related needs by
    # extensions or your application
    app.config["SECRET_KEY"] = "someCrazyS3cR3T!Key.!"

    # these are for the DB object to be able to connect to MySQL.
    app.config["MYSQL_DATABASE_USER"] = "root"
    app.config["MYSQL_DATABASE_PASSWORD"] = open("/secrets/db_root_password.txt").readline()
    app.config["MYSQL_DATABASE_HOST"] = "db"
    app.config["MYSQL_DATABASE_PORT"] = 3306
    app.config["MYSQL_DATABASE_DB"] = "cargocache"

    # Initialize the database object with the settings above.
    db.init_app(app)

    # Add a default route
    @app.route("/")
    def welcome():
        return "<h1>Welcome to the sickest website ever</h1>"

    # Register the routes that we just imported so they can be properly handled
    app.register_blueprint(views, url_prefix="/v")
    app.register_blueprint(sellers, url_prefix="/s")
    app.register_blueprint(moderators, url_prefix="/m")
    # app.register_blueprint(customers, url_prefix="/c")
    # app.register_blueprint(products, url_prefix="/p")

    return app


def _run_and_respond(query):
    """Runs the given SQL against the database, returning the JSON-ified results"""
    cursor = db.get_db().cursor()
    cursor.execute(query)
    row_headers = [desc[0] for desc in cursor.description]
    json_list = []
    data = cursor.fetchall()
    for row in data:
        json_list.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_list))
    response.status_code = 200
    response.mimetype = "application/json"
    return response
