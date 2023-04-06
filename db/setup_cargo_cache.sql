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
-- Accounts
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('nsouthwell0@paginegialle.it', 'rTt7a40zHZ', 'Nickie', 'Southwell', 'Tacoma', 'WA', '98417', '253-407-6174');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('gever1@spotify.com', 'vj2h1T', 'Georgy', 'Ever', 'Chicago', 'IL', '60686', '312-256-4348');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('dwyllcocks2@ameblo.jp', '4bhkYhTj', 'Doria', 'Wyllcocks', 'Omaha', 'NE', '68144', '402-985-3400');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('bshalloe3@washington.edu', 'KQI796', 'Bobine', 'Shalloe', 'Fullerton', 'CA', '92640', '559-498-4936');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('kbeed4@sourceforge.net', 'GyDan6r', 'Karoly', 'Beed', 'Philadelphia', 'PA', '19196', '215-544-6314');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('mhammatt5@taobao.com', 'sjsy2UlYNJ', 'Marylynne', 'Hammatt', 'El Paso', 'TX', '88546', '915-652-8398');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('porehead6@taobao.com', 'lYRq9xEZes2F', 'Paton', 'Orehead', 'New York City', 'NY', '10155', '646-728-8213');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('pgookey7@about.me', 'dchLsAX5V', 'Phyllida', 'Gookey', 'Raleigh', 'NC', '27658', '919-115-2515');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('jbilliard8@sfgate.com', '5Fi3Oz6gigs', 'Jessie', 'Billiard', 'Memphis', 'TN', '38150', '901-407-6596');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('ostudd9@bbb.org', 'Qx8ibZH017wD', 'Oralla', 'Studd', 'Bradenton', 'FL', '34210', '727-121-5036');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('bbaudrya@bravesites.com', 'xKXIjNoZ', 'Breanne', 'Baudry', 'Phoenix', 'AZ', '85099', '602-950-6669');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('fcattanachb@yahoo.com', 'SrnXvxRkV8', 'Faustina', 'Cattanach', 'Fresno', 'CA', '93773', '559-712-4625');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('bguiotc@pcworld.com', 'MfTVvfrlk', 'Bord', 'Guiot', 'Palm Bay', 'FL', '32909', '561-286-5187');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('scanod@japanpost.jp', 'whl39sTT9zeq', 'Sile', 'Cano', 'San Diego', 'CA', '92160', '619-417-9324');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('rhubbinse@theglobeandmail.com', 'Lk5RhjOBUED', 'Ronny', 'Hubbins', 'Harrisburg', 'PA', '17105',
        '717-509-3446');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('oveschambref@hhs.gov', 'vXmZILdO', 'Olenolin', 'Veschambre', 'Evanston', 'IL', '60208', '847-164-9592');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('ksimonettg@hubpages.com', 'DJ3uciirkY', 'Kort', 'Simonett', 'Canton', 'OH', '44710', '330-123-4891');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('vcappelh@adobe.com', 'MMJENOf4qxS', 'Valentina', 'Cappel', 'Fort Wayne', 'IN', '46896', '260-742-5567');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('dlatani@usgs.gov', '6wrMyffIJH6U', 'Deborah', 'Latan', 'Los Angeles', 'CA', '90071', '818-488-6565');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('jtowsj@about.me', 'Ajoa8XPYv6X', 'Jarvis', 'Tows', 'Anaheim', 'CA', '92812', '714-144-5938');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('mofieldk@oakley.com', 'fBaH7cDQIFQ', 'Malinda', 'Ofield', 'Bloomington', 'IL', '61709', '309-750-0703');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('sheaneyl@prnewswire.com', 'D6iRdd2BkK', 'Starlin', 'Heaney`', 'San Antonio', 'TX', '78296', '210-631-6472');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('dlongmeadm@live.com', 'MafuhZi8', 'Deb', 'Longmead', 'Cape Coral', 'FL', '33915', '239-749-1720');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('bizaksn@cisco.com', 'J1ZUDf', 'Bettine', 'Izaks', 'Hartford', 'CT', '06105', '203-261-3222');
INSERT INTO Accounts (Email, Password, FirstName, LastName, City, State, Zip, Phone)
VALUES ('mmoscropo@aol.com', 'm6J8UYL4KK', 'Massimiliano', 'Moscrop', 'Louisville', 'KY', '40280', '502-940-6081');

-- Rentees
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('nsouthwell0@paginegialle.it', 'Wikibox', '80-654-9594', 'Aimée');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('gever1@spotify.com', 'Youopia', '61-636-3495', 'Zoé');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('dwyllcocks2@ameblo.jp', 'Voolia', '99-417-0860', 'Rachèle');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('bshalloe3@washington.edu', 'Ainyx', '45-574-6277', 'Cinéma');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('kbeed4@sourceforge.net', 'Mydo', '89-209-8253', 'Örjan');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('mhammatt5@taobao.com', 'Oyondu', '94-534-4181', 'Audréanne');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('porehead6@taobao.com', 'Vimbo', '91-312-7334', 'Séverine');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('pgookey7@about.me', 'Jamia', '41-441-7317', 'Maïly');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('jbilliard8@sfgate.com', 'Oodoo', '55-692-9158', 'Célestine');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('ostudd9@bbb.org', 'Skaboo', '86-643-6198', 'Jú');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('bbaudrya@bravesites.com', 'Trilia', '62-837-3779', 'Anaëlle');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('fcattanachb@yahoo.com', 'Yakijo', '78-668-7768', 'Cécilia');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('bguiotc@pcworld.com', 'Roombo', '87-557-4163', 'Lorène');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('scanod@japanpost.jp', 'Wikido', '99-451-9720', 'Réservés');
INSERT INTO Rentees (AccountEmail, BankName, AccountNumber, AccountName)
VALUES ('rhubbinse@theglobeandmail.com', 'Muxo', '46-771-0788', 'Noémie');

-- Units
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Minneapolis', 'MN', '55480', '72315', 'nsouthwell0@paginegialle.it', 'Oakridge',
        'Occlusion of Right Innominate Vein, Perc Endo Approach', 80163.11, 4793.25);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('San Jose', 'CA', '95108', '706', 'nsouthwell0@paginegialle.it', 'Doe Crossing',
        'Extirpation of Matter from L Sternoclav Jt, Open Approach', 65727.63, 5124.25);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Milwaukee', 'WI', '53215', '05', 'pgookey7@about.me', 'Memorial',
        'Fusion T-lum Jt w Nonaut Sub, Post Appr P Col, Perc Endo', 68368.35, 5185.98);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Springfield', 'IL', '62764', '3405', 'kbeed4@sourceforge.net', 'Beilfuss',
        'Dilation of R Thyroid Art with 3 Drug-elut, Open Approach', 20475.07, 8134.13);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Saint Paul', 'MN', '55127', '12', 'gever1@spotify.com', 'Kipling',
        'Excision of Right Lung, Percutaneous Approach, Diagnostic', 31145.23, 3610.82);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Colorado Springs', 'CO', '80930', '154', 'nsouthwell0@paginegialle.it', 'Nevada',
        'Insertion of Infusion Device into L Tarsal Jt, Perc Approach', 97334.60, 7524.97);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Charlotte', 'NC', '28225', '862', 'gever1@spotify.com', 'Randy',
        'Revision of Drainage Device in L Pleural Cav, Open Approach', 73732.07, 261.03);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Richmond', 'VA', '23225', '3484', 'gever1@spotify.com', 'Lawn',
        'Fragmentation in Respiratory Tract, External Approach', 20340.98, 2094.73);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Albuquerque', 'NM', '87105', '4', 'nsouthwell0@paginegialle.it', 'Jana',
        'Bypass Ileum to Trans Colon w Nonaut Sub, Perc Endo', 16873.47, 9357.99);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('New York City', 'NY', '10125', '2', 'bshalloe3@washington.edu', 'Pankratz',
        'LDR Brachytherapy of Spinal Cord using Oth Isotope', 17308.19, 4907.67);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Portland', 'OR', '97240', '750', 'mhammatt5@taobao.com', 'Sunfield',
        'Excision of Right Hand Artery, Open Approach', 28223.13, 5365.90);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Washington', 'DC', '20397', '44', 'mhammatt5@taobao.com', 'Burrows',
        'Release Bilateral Spermatic Cords, Open Approach', 57570.18, 7388.82);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Seattle', 'WA', '98121', '1', 'bshalloe3@washington.edu', 'Stoughton',
        'Extirpation of Matter from Int Mamm, L Lymph, Open Approach', 26366.78, 4926.40);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Cedar Rapids', 'IA', '52405', '1', 'pgookey7@about.me', 'Toban', 'CT Scan of R Knee using H Osm Contrast',
        24593.40, 4473.22);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Delray Beach', 'FL', '33448', '7', 'mhammatt5@taobao.com', 'Basil',
        'Introduce of Oxazolidinones into Pleural Cav, Perc Approach', 95794.15, 5545.52);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Santa Cruz', 'CA', '95064', '502', 'pgookey7@about.me', 'Trailsway',
        'Excision of Spleen, Percutaneous Endoscopic Approach', 62451.54, 4242.26);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Cincinnati', 'OH', '45233', '5', 'gever1@spotify.com', 'Dorton',
        'Revision of Drainage Device in Low Art, Perc Endo Approach', 75264.75, 2027.43);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Sparks', 'NV', '89436', '470', 'pgookey7@about.me', 'Kinsman',
        'Resection of Left Upper Lung Lobe, Perc Endo Approach', 33111.32, 3818.24);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('San Jose', 'CA', '95123', '84877', 'porehead6@taobao.com', 'Pawling',
        'Excision of Esophagogastric Junction, Percutaneous Approach', 33570.31, 3330.93);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Atlanta', 'GA', '30316', '5712', 'kbeed4@sourceforge.net', 'Forster',
        'Alteration of R Knee with Autol Sub, Perc Approach', 28814.46, 1391.00);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Brooklyn', 'NY', '11231', '82982', 'kbeed4@sourceforge.net', 'Rigney',
        'HDR Brachytherapy of Chest Wall using Oth Isotope', 49440.48, 292.15);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Atlanta', 'GA', '30380', '0', 'kbeed4@sourceforge.net', 'Ridgeview',
        'Restrict R Mid Lobe Bronc w Intralum Dev, Perc Endo', 52227.70, 6127.39);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Pittsburgh', 'PA', '15230', '82', 'mhammatt5@taobao.com', 'Fuller',
        'Repair Pharynx, Via Natural or Artificial Opening', 81013.38, 1626.80);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Washington', 'DC', '20088', '05', 'pgookey7@about.me', 'Browning',
        'Insertion of Int Fix into R Temporomandib Jt, Perc Approach', 63192.09, 2872.45);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Rockford', 'IL', '61105', '53', 'kbeed4@sourceforge.net', 'Londonderry',
        'Drainage of Trachea, Open Approach, Diagnostic', 7743.33, 1117.24);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Honolulu', 'HI', '96815', '06', 'bshalloe3@washington.edu', 'Clarendon',
        'Drainage of L Foot Tendon with Drain Dev, Perc Endo Approach', 74832.40, 9951.54);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Rockford', 'IL', '61105', '5', 'dwyllcocks2@ameblo.jp', 'Birchwood', 'Resection of Tongue, Open Approach',
        89810.63, 471.02);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Anchorage', 'AK', '99599', '2395', 'porehead6@taobao.com', 'Corscot',
        'Orofacial Myofunctional Assessment using Other Equipment', 63629.39, 2368.92);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Kansas City', 'MO', '64130', '49492', 'pgookey7@about.me', 'Dunning',
        'Drainage of Abdominal Aorta, Perc Endo Approach, Diagn', 11573.33, 7111.39);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Gulfport', 'MS', '39505', '9', 'nsouthwell0@paginegialle.it', 'Spaight',
        'Bypass Abd Aorta to Abd Aorta w Synth Sub, Perc Endo', 92904.56, 8785.76);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Los Angeles', 'CA', '90189', '2522', 'pgookey7@about.me', 'Burrows',
        'Supplement Upper Vein with Nonaut Sub, Perc Endo Approach', 20145.10, 488.71);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Trenton', 'NJ', '08619', '0579', 'kbeed4@sourceforge.net', 'Scofield',
        'Removal of Nonaut Sub from R Patella, Open Approach', 7426.72, 3661.85);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('New York City', 'NY', '10034', '3306', 'kbeed4@sourceforge.net', 'Randy',
        'Removal of Drainage Device from Upper Back, Extern Approach', 86841.42, 8849.31);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Peoria', 'IL', '61629', '6', 'mhammatt5@taobao.com', 'Sommers',
        'Revision of Synthetic Substitute in Left Ulna, Perc Approach', 24812.01, 9617.91);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Toledo', 'OH', '43656', '2', 'bshalloe3@washington.edu', 'Scoville',
        'Drainage of Left Inguinal Region, Open Approach, Diagnostic', 39409.67, 3985.31);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Dallas', 'TX', '75358', '2', 'porehead6@taobao.com', 'Sutteridge',
        'Supplement C-thor Disc with Nonaut Sub, Perc Approach', 32818.39, 3797.79);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Lincoln', 'NE', '68505', '4366', 'kbeed4@sourceforge.net', 'Pond',
        'Supplement L Renal Art with Autol Sub, Perc Endo Approach', 55608.07, 6780.09);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Wichita', 'KS', '67236', '9', 'kbeed4@sourceforge.net', 'Quincy', 'Plain Radiography of Paranasal Sinuses',
        38748.50, 524.13);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Saint Louis', 'MO', '63169', '35852', 'porehead6@taobao.com', 'Lyons',
        'Fusion of Right Elbow Joint, Perc Endo Approach', 81550.83, 7144.44);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Honolulu', 'HI', '96835', '951', 'bshalloe3@washington.edu', 'Lakewood Gardens',
        'Restriction of Portal Vein, Percutaneous Endoscopic Approach', 72213.66, 5730.67);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Washington', 'DC', '20299', '10', 'pgookey7@about.me', 'New Castle',
        'Replace of L Finger Phalanx with Autol Sub, Perc Approach', 13078.53, 7414.39);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Arlington', 'VA', '22205', '88905', 'nsouthwell0@paginegialle.it', 'Green Ridge',
        'Alteration of Bi Breast with Nonaut Sub, Perc Approach', 6808.33, 6379.26);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Tacoma', 'WA', '98405', '14425', 'nsouthwell0@paginegialle.it', 'Westridge',
        'Supplement Right Rib with Autol Sub, Perc Approach', 21122.70, 4705.23);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Oakland', 'CA', '94627', '374', 'kbeed4@sourceforge.net', 'Mariners Cove',
        'Restriction of Celiac Artery, Perc Endo Approach', 84744.89, 9220.00);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Phoenix', 'AZ', '85030', '4327', 'dwyllcocks2@ameblo.jp', 'Melvin',
        'Supplement T-lum Disc with Autol Sub, Open Approach', 50786.75, 6423.50);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Providence', 'RI', '02905', '8266', 'mhammatt5@taobao.com', 'Gale',
        'Extraction of R Foot Subcu/Fascia, Perc Approach', 24550.40, 1691.38);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Huntsville', 'AL', '35895', '309', 'pgookey7@about.me', 'Main', 'Repair Left Frontal Bone, External Approach',
        75827.95, 5278.45);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('San Mateo', 'CA', '94405', '46', 'bshalloe3@washington.edu', '6th',
        'Replace of R Metatarsophal Jt with Nonaut Sub, Open Approach', 54352.33, 6242.13);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Newark', 'NJ', '07188', '1', 'dwyllcocks2@ameblo.jp', 'Lakeland',
        'Reposition Median Nerve, Percutaneous Endoscopic Approach', 15716.97, 2759.26);
INSERT INTO Units (City, State, Zip, UnitNumber, PrimaryAccountEmail, Name, Description, ListedPrice, Size)
VALUES ('Trenton', 'NJ', '08619', '7', 'bshalloe3@washington.edu', 'East',
        'Fluoroscopy Bi Int Carotid w Oth Contrast, Laser Intraop', 79560.09, 2329.42);

-- Unit Pictures
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (1, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (2, x'Two');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (3, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (4, x'Four');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (5, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (6, x'Six');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (7, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (8, x'Eight');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (9, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (10, x'Ten');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (10, x'Ten');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (11, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (12, x'Twelve');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (13, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (14, x'Fourteen');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (15, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (17, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (17, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (17, x'One');
INSERT INTO UnitPictures (UnitID, Picture)
VALUES (17, x'One');

-- Co-Rentee Units
INSERT INTO CoRenteeUnits (UnitID, AccountEmail)
VALUES (4, 'fcattanachb@yahoo.com');
INSERT INTO CoRenteeUnits (UnitID, AccountEmail)
VALUES (4, 'bbaudrya@bravesites.com');
INSERT INTO CoRenteeUnits (UnitID, AccountEmail)
VALUES (4, 'bguiotc@pcworld.com');
INSERT INTO CoRenteeUnits (UnitID, AccountEmail)
VALUES (7, 'scanod@japanpost.jp');
INSERT INTO CoRenteeUnits (UnitID, AccountEmail)
VALUES (7, 'rhubbinse@theglobeandmail.com');

-- Attributes
INSERT INTO Attributes (Name, Description)
VALUES ('Heat', 'A heating system capable of warming your unit, keeping your items safe from the cold.');
INSERT INTO Attributes (Name, Description)
VALUES ('A/C', 'A cooling system capable of freezing your unit, keeping your items safe from the heat.');

-- Attribute Unit
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (1, 'Heat');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (1, 'A/C');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (2, 'Heat');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (2, 'A/C');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (3, 'Heat');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (4, 'Heat');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (5, 'Heat');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (6, 'Heat');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (7, 'A/C');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (8, 'A/C');
INSERT INTO AttributeUnit (UnitID, AttributeName)
VALUES (9, 'A/C');

-- Renters
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('sheaneyl@prnewswire.com', '5108755708753941', 'mastercard', '2024-11');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('sheaneyl@prnewswire.com', '5108750473201051', 'mastercard', '2023-10');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('dlatani@usgs.gov', '5108751044279717', 'mastercard', '2022-11');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('bizaksn@cisco.com', '5108752851951257', 'mastercard', '2023-04');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('bizaksn@cisco.com', '5048378848524750', 'mastercard', '2024-11');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('jtowsj@about.me', '5108752937014377', 'mastercard', '2024-08');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('mofieldk@oakley.com', '5048376828956984', 'mastercard', '2023-06');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('mmoscropo@aol.com', '5108751329810434', 'mastercard', '2023-03');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('mofieldk@oakley.com', '5048375250780979', 'mastercard', '2023-06');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('mofieldk@oakley.com', '5108755544125064', 'mastercard', '2024-12');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('ksimonettg@hubpages.com', '5108753505170542', 'mastercard', '2024-05');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('sheaneyl@prnewswire.com', '5048377874210912', 'mastercard', '2025-08');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('bizaksn@cisco.com', '5108758770165465', 'mastercard', '2023-12');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('mmoscropo@aol.com', '5048378958079462', 'mastercard', '2024-05');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('jtowsj@about.me', '5048377829625974', 'mastercard', '2024-04');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('ksimonettg@hubpages.com', '5048379666259479', 'mastercard', '2023-06');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('sheaneyl@prnewswire.com', '5108755454306118', 'mastercard', '2023-12');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('dlongmeadm@live.com', '5108751725471351', 'mastercard', '2023-07');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('mmoscropo@aol.com', '5108756888555841', 'mastercard', '2022-05');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('sheaneyl@prnewswire.com', '5048377312842011', 'mastercard', '2022-11');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('vcappelh@adobe.com', '5108750130451974', 'mastercard', '2024-10');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('mofieldk@oakley.com', '5108756940355214', 'mastercard', '2022-12');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('mmoscropo@aol.com', '5048373196354512', 'mastercard', '2025-12');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('ksimonettg@hubpages.com', '5048370592151559', 'mastercard', '2024-06');
INSERT INTO Renters (AccountEmail, CreditCardNumber, CreditCardInfo, ExpiryDate)
VALUES ('sheaneyl@prnewswire.com', '5048377279034974', 'mastercard', '2024-05');

-- Blocks
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('mmoscropo@aol.com', 'jtowsj@about.me');
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('dlatani@usgs.gov', 'sheaneyl@prnewswire.com');
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('dlatani@usgs.gov', 'ksimonettg@hubpages.com');
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('dlatani@usgs.gov', 'bizaksn@cisco.com');
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('dlongmeadm@live.com', 'sheaneyl@prnewswire.com');
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('mofieldk@oakley.com', 'mmoscropo@aol.com');
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('vcappelh@adobe.com', 'mofieldk@oakley.com');
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('vcappelh@adobe.com', 'bizaksn@cisco.com');
INSERT INTO Blocks (AccountEmail, BlockedEmail)
VALUES ('vcappelh@adobe.com', 'jtowsj@about.me');

-- Renter Watching Units
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (1, 'bizaksn@cisco.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (4, 'bizaksn@cisco.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (4, 'dlongmeadm@live.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (4, 'jtowsj@about.me');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (6, 'sheaneyl@prnewswire.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (6, 'dlongmeadm@live.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (7, 'bizaksn@cisco.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (8, 'jtowsj@about.me');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (8, 'vcappelh@adobe.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (12, 'bizaksn@cisco.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (12, 'dlongmeadm@live.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (12, 'vcappelh@adobe.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (14, 'mofieldk@oakley.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (15, 'bizaksn@cisco.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (15, 'sheaneyl@prnewswire.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (15, 'ksimonettg@hubpages.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (15, 'jtowsj@about.me');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (15, 'mofieldk@oakley.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (21, 'bizaksn@cisco.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (21, 'sheaneyl@prnewswire.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (21, 'dlongmeadm@live.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (23, 'sheaneyl@prnewswire.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (23, 'bizaksn@cisco.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (23, 'dlongmeadm@live.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (23, 'vcappelh@adobe.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (27, 'sheaneyl@prnewswire.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (27, 'mmoscropo@aol.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (28, 'mofieldk@oakley.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (30, 'sheaneyl@prnewswire.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (30, 'bizaksn@cisco.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (31, 'vcappelh@adobe.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (34, 'ksimonettg@hubpages.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (33, 'dlongmeadm@live.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (34, 'dlongmeadm@live.com');
INSERT INTO RenterWatchingUnits (UnitID, AccountEmail)
VALUES (35, 'dlongmeadm@live.com');

-- Terms
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-07', '2024-01', 93759.25);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-02', '2024-02', 27169.82);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-10', '2023-10', 26638.16);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-06', '2024-03', 71564.03);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-02', '2024-04', 15286.11);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-05', '2023-10', 78308.93);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-06', '2023-08', 79002.18);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-03', '2023-11', 25240.56);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-01', '2023-10', 13216.33);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-07', '2024-02', 29271.06);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-07', '2024-01', 44050.47);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-02', '2023-12', 33059.83);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-05', '2023-09', 8760.04);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-08', '2023-12', 51220.38);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-06', '2024-02', 71159.25);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-02', '2023-10', 4954.55);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-09', '2023-09', 79821.23);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-01', '2023-11', 3793.02);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-05', '2024-08', 61696.46);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-01', '2023-10', 69041.48);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-04', '2024-05', 85963.32);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-03', '2024-05', 75371.32);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-08', '2023-12', 12927.32);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-04', '2023-09', 77162.51);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-02', '2023-12', 20981.26);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-12', '2023-10', 61594.39);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2022-05', '2024-01', 73554.38);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-05', '2024-04', 14134.70);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-03', '2023-10', 15800.83);
INSERT INTO Terms (StartDate, EndDate, Price)
VALUES ('2023-03', '2023-07', 71664.54);

-- Leases
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (11, 'dlongmeadm@live.com', 1);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (20, 'ksimonettg@hubpages.com', 2);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (3, 'ksimonettg@hubpages.com', 3);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (6, 'vcappelh@adobe.com', 4);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (18, 'sheaneyl@prnewswire.com', 5);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (4, 'vcappelh@adobe.com', 6);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (8, 'mmoscropo@aol.com', 7);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (7, 'sheaneyl@prnewswire.com', 8);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (10, 'jtowsj@about.me', 9);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (9, 'dlongmeadm@live.com', 10);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (1, 'vcappelh@adobe.com', 11);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (5, 'bizaksn@cisco.com', 12);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (15, 'bizaksn@cisco.com', 13);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (2, 'mmoscropo@aol.com', 14);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (12, 'mofieldk@oakley.com', 15);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (19, 'bizaksn@cisco.com', 16);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (14, 'sheaneyl@prnewswire.com', 17);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (13, 'jtowsj@about.me', 18);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (16, 'dlongmeadm@live.com', 19);
INSERT INTO Leases (UnitID, AccountEmail, TermsID)
VALUES (17, 'mofieldk@oakley.com', 20);