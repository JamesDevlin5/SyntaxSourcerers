from flask import Blueprint, jsonify, make_response, request

from src import db


def _run_and_respond(query):
    """Runs the given SQL against the database, returning the JSON-ified results"""
    cursor = db.get_db().cursor()
    cursor.execute(query)
    json_list = []
    if cursor.description:
        row_headers = [desc[0] for desc in cursor.description]
        data = cursor.fetchall()
        for row in data:
            json_list.append(dict(zip(row_headers, row)))
    response = make_response(jsonify(json_list))
    response.status_code = 200
    response.mimetype = "application/json"
    return response


sellers = Blueprint("sellers", __name__)


@sellers.route("/listings/<email>", methods=["GET"])
def get_listings(email):
    """Gets all the unit listings associated with the owner's Email"""
    # NOTE: offer choice to select a specific unit from this list
    return _run_and_respond(
        f"SELECT * FROM Units WHERE PrimaryAccountEmail = '{email}';"
    )


@sellers.route("/listings/<email>", methods=["POST"])
def new_unit_listing(email):
    """Creates a new advertisement for a unit being sold by the user"""
    # NOTE: currently, all optional fields are required
    form = request.form
    city = form["city"]
    state = form["state"]
    zipcode = form["zip"]
    unit_num = form["unitNumber"]
    name = form["name"]
    description = form["description"]
    # Price is of the form ######.## (a number w/ 2 decimal points)
    price = form["price"]
    # Size is of the form ######.### (a number w/ 3 decimal points)
    size = form["size"]
    return _run_and_respond(
        f"""
        INSERT INTO Units (City,State,Zip,UnitNumber,PrimaryAccountEmail,Name,Description,ListedPrice,Size)
        VALUES ('{city}', '{state}', {zipcode}, {unit_num}, '{email}', '{name}', '{description}', {price}, {size});
        """
    )


@sellers.route("/listings/<int:unitID>", methods=["GET"])
def get_unit_listing(unitID):
    """Gets detailed information about one specific unit"""
    return _run_and_respond(f"SELECT * FROM Units WHERE UnitID = {unitID};")


@sellers.route("/listings/<int:unitID>/price", methods=["PUT"])
def set_unit_price(unitID):
    """Change the price for the specific unit

    Requires a form with input of new price"""
    new_price = request.form["price"]
    return _run_and_respond(
        f"UPDATE Units SET ListedPrice = {new_price} WHERE UnitID = {unitID};"
    )


@sellers.route("/listings/<int:unitID>/size", methods=["PUT"])
def set_unit_size(unitID):
    """Change the size (in square ft, with 3 decimal points) for the specific unit

    Requires a form with input of new size"""
    new_size = request.form["size"]
    return _run_and_respond(
        f"UPDATE Units SET Size = {new_size} WHERE UnitID = {unitID};"
    )


@sellers.route("/listings/<int:unitID>/pictures", methods=["GET"])
def get_unit_pictures(unitID):
    """Gets all pictures associated with this unit"""
    return _run_and_respond(
        f"SELECT * FROM UnitPictures WHERE UnitID = {unitID};"
    )


@sellers.route("/listings/<int:unitID>/pictures", methods=["POST"])
def add_unit_picture(unitID):
    """Adds a new picture to a specific unit being sold by this seller

    Requires a form to input the id associated with the new picture"""
    pic_id = request.form["pictureID"]
    return _run_and_respond(
        f"""
        INSERT INTO UnitPictures (UnitID, PictureID)
        VALUES ({unitID}, {pic_id});
        """
    )


@sellers.route(
    "/listings/<int:unitID>/pictures/<int:picID>", methods=["DELETE"]
)
def rm_unit_picture(unitID, picID):
    """Removes an existing picture from a specific unit being sold by this seller"""
    return _run_and_respond(
        f"DELETE FROM UnitPictures WHERE UnitID = {unitID} AND PictureID = {picID};"
    )


@sellers.route("/listings/<int:unitID>/attributes", methods=["GET"])
def get_unit_attributes(unitID):
    """Gets all attributes associated with this unit"""
    return _run_and_respond(
        f"""
        SELECT DISTINCT Attributes.Name AS 'Name', Attributes.Description AS 'Description'
        FROM Attributes
        JOIN AttributeUnit ON Attributes.Name = AttributeUnit.AttributeName
        JOIN Units USING (UnitID)
        WHERE AttributeUnit.UnitID = {unitID};
        """
    )
