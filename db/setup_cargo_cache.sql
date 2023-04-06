-- Set Up Database
DROP DATABASE IF EXISTS cargocache;
CREATE DATABASE cargocache;
USE cargocache;

-- Create Tables
CREATE TABLE Accounts
(
    Email     VARCHAR(100) UNIQUE NOT NULL,
    -- Password required
    Password  VARCHAR(30)         NOT NULL,
    FirstName VARCHAR(30)         NOT NULL,
    LastName  VARCHAR(30)         NOT NULL,
    City      VARCHAR(70)         NOT NULL,
    -- 2-letter code
    State     CHAR(2)             NOT NULL,
    Zip       CHAR(5)             NOT NULL,
    Phone     VARCHAR(12)         NOT NULL,
    PRIMARY KEY (Email)
);

CREATE TABLE Rentees
(
    AccountEmail  VARCHAR(100) UNIQUE NOT NULL,
    BankName      VARCHAR(40)         NOT NULL,
    AccountNumber VARCHAR(20)         NOT NULL,
    AccountName   VARCHAR(40)         NOT NULL,
    PRIMARY KEY (AccountEmail),
    CONSTRAINT fk_rentees_accounts FOREIGN KEY (AccountEmail) REFERENCES Accounts (Email) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Units
(
    UnitID              INT UNIQUE    NOT NULL AUTO_INCREMENT,
    City                VARCHAR(70)   NOT NULL,
    -- State 2-letter code
    State               CHAR(2)       NOT NULL,
    -- 5-digit zip
    Zip                 CHAR(5)       NOT NULL,
    UnitNumber          INT           NOT NULL,
    PrimaryAccountEmail VARCHAR(100)  NOT NULL,
    Name                VARCHAR(20),
    Description         MEDIUMTEXT,
    -- Max Price = $9,999,999.99
    ListedPrice         DECIMAL(9, 2) NOT NULL,
    -- Max Size = 9,999,999.999 ft^2
    Size                DECIMAL(10, 3),
    PRIMARY KEY (UnitID),
    CONSTRAINT fk_units_rentees FOREIGN KEY (PrimaryAccountEmail) REFERENCES Rentees (AccountEmail) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE UnitPictures
(
    UnitID    INT        NOT NULL,
    PictureID INT UNIQUE NOT NULL AUTO_INCREMENT,
    Picture   BLOB       NOT NULL,
    PRIMARY KEY (UnitID, PictureID),
    CONSTRAINT fk_unitpictures_units FOREIGN KEY (UnitID) REFERENCES Units (UnitID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CoRenteeUnits
(
    UnitID       INT          NOT NULL,
    AccountEmail VARCHAR(100) NOT NULL,
    PRIMARY KEY (UnitID, AccountEmail),
    CONSTRAINT fk_corenteeunits_units FOREIGN KEY (UnitID) REFERENCES Units (UnitID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_corenteeunits_rentees FOREIGN KEY (AccountEmail) REFERENCES Rentees (AccountEmail) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Attributes
(
    Name        VARCHAR(20) NOT NULL,
    Description MEDIUMTEXT,
    PRIMARY KEY (Name)
);

CREATE TABLE AttributeUnit
(
    UnitID        INT         NOT NULL,
    AttributeName VARCHAR(20) NOT NULL,
    PRIMARY KEY (UnitID, AttributeName),
    CONSTRAINT fk_attrunit_units FOREIGN KEY (UnitID) REFERENCES Units (UnitID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_attrunit_attrs FOREIGN KEY (AttributeName) REFERENCES Attributes (Name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Renters
(
    AccountEmail     VARCHAR(100) NOT NULL,
    CreditCardNumber VARCHAR(20)  NOT NULL,
    CreditCardInfo   VARCHAR(10)  NOT NULL,
    ExpiryDate       DATE         NOT NULL,
    PRIMARY KEY (AccountEmail),
    CONSTRAINT fk_renters_accounts FOREIGN KEY (AccountEmail) REFERENCES Accounts (Email) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Blocks
(
    AccountEmail VARCHAR(100) NOT NULL,
    BlockedEmail VARCHAR(100) NOT NULL,
    PRIMARY KEY (AccountEmail, BlockedEmail),
    CONSTRAINT fk_blocks_accounts FOREIGN KEY (AccountEmail) REFERENCES Accounts (Email) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_blocks_renters FOREIGN KEY (BlockedEmail) REFERENCES Renters (AccountEmail) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RenterWatchingUnits
(
    UnitID       INT          NOT NULL,
    AccountEmail VARCHAR(100) NOT NULL,
    PRIMARY KEY (UnitID, AccountEmail),
    CONSTRAINT fk_watchingunits_units FOREIGN KEY (UnitID) REFERENCES Units (UnitID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_watchingunits_renters FOREIGN KEY (AccountEmail) REFERENCES Renters (AccountEmail) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Terms
(
    TermsID   INT UNIQUE    NOT NULL AUTO_INCREMENT,
    StartDate DATE          NOT NULL,
    EndDate   DATE          NOT NULL,
    Price     DECIMAL(9, 2) NOT NULL
);

CREATE TABLE Leases
(
    UnitID       INT          NOT NULL,
    AccountEmail VARCHAR(100) NOT NULL,
    TermsID      INT          NOT NULL,
    PRIMARY KEY (UnitID, AccountEmail, TermsID),
    CONSTRAINT fk_leases_units FOREIGN KEY (UnitID) REFERENCES Units (UnitID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_leases_renters FOREIGN KEY (AccountEmail) REFERENCES Renters (AccountEmail) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_leases_terms FOREIGN KEY (TermsID) REFERENCES Terms (TermsID) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Mock Data
-- TODO: On Mockaroo
