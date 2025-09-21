-- CREATE TABLE cs303_database;


DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Photographs;

CREATE TABLE Users(
user_ID INT PRIMARY KEY,
full_name VARCHAR (25),
user_name VARCHAR (25),
address VARCHAR (50),
city VARCHAR (25),
state VARCHAR(2),
zip INT
);

CREATE TABLE Locations(
Item_ID INT,
item_type INT,
description VARCHAR(100),
lat REAL,
lng REAL
);

CREATE TABLE Photographs(
photo_ID INT,
location_ID INT
);

ALTER TABLE users 
MODIFY user_ID INT NOT NULL;

ALTER TABLE users 
MODIFY full_name VARCHAR(25) NOT NULL;

ALTER TABLE users 
MODIFY user_name VARCHAR(25) NOT NULL;

ALTER TABLE locations 
MODIFY item_type INT NOT NULL;

ALTER TABLE locations 
MODIFY description VARCHAR(100) NOT NULL;

ALTER TABLE locations 
MODIFY lng REAL NOT NULL;

ALTER TABLE locations 
MODIFY lat REAL NOT NULL;


ALTER TABLE photographs 
MODIFY photo_ID INT NOT NULL;

ALTER TABLE photographs 
MODIFY location_id INT NOT NULL;

CREATE UNIQUE INDEX ID ON Users (user_ID);
CREATE UNIQUE INDEX photo_loc_id ON photographs (photo_ID);


INSERT INTO Users (user_ID, full_name, user_name, address, city, state, zip) VALUES 
(1, 'Bonnie Buntcake', 'bbunt', '6709 Wonder Street', 'Wonderbread', 'OH', 46105),
(2, 'Charlie Crumb', 'ccrumb', '123 Toast Ave', 'Breadville', 'CA', 90210),
(3, 'Daisy Dough', 'ddough', '456 Muffin Ln', 'Pastrytown', 'NY', 10001),
(4, 'Eddie Eclair', 'eeclair', '789 Cream Blvd', 'Sweetburg', 'TX', 73301),
(5, 'Fiona Frosting', 'ffrost', '321 Sugar St', 'Caketown', 'FL', 33101),
(6, 'Graham Graham', 'ggraham', '654 Cracker Rd', 'Snackville', 'WA', 98101),
(7, 'Holly Honeybun', 'hhoney', '987 Glaze Way', 'Stickyville', 'IL', 60601),
(8, 'Ivy Icing', 'iicing', '159 Sprinkle Dr', 'Dessert City', 'NV', 89101),
(9, 'Jack Jellyroll', 'jjelly', '753 Swirl Ct', 'Rolltown', 'GA', 30301),
(10, 'Kara Kringle', 'kkringle', '852 Noel Ln', 'Festive Falls', 'CO', 80201);

ALTER TABLE photographs
ADD COLUMN user_ID INT
AFTER location_ID;

INSERT INTO Locations (item_ID, item_type, description, lat, lng) VALUES
(1, 1, 'Redwood tree near trailhead', 40.9461, -124.1002),
(2, 2, 'Utility pole with transformer', 40.9458, -124.1015),
(3, 3, 'Scenic overlook with bench', 40.9472, -124.0990),
(4, 1, 'Cluster of Douglas firs', 40.9445, -124.1023),
(5, 2, 'Vegetation encroaching power line', 40.9439, -124.1031),
(6, 3, 'Trail marker with QR code', 40.9467, -124.0984),
(7, 1, 'Old-growth cedar near creek', 40.9452, -124.1040),
(8, 2, 'Inspection site for tree trimming', 40.9448, -124.1009),
(9, 3, 'Wildlife camera installation point', 40.9463, -124.0997);

INSERT INTO photographs (photo_ID, location_ID, user_ID) VALUES (1, 1, 1);
INSERT INTO photographs (photo_ID, location_ID, user_ID) VALUES (2, 2, 2);
INSERT INTO photographs (photo_ID, location_ID, user_ID) VALUES (3, 3, 3);
INSERT INTO photographs (photo_ID, location_ID, user_ID) VALUES (4, 4, 4);

SELECT *
FROM Locations;

SELECT full_name
FROM users, photographs
WHERE users.user_ID = photographs.user_ID;

SELECT DISTINCT full_name
FROM users, photographs
WHERE users.user_ID = photographs.user_ID;

SELECT *
FROM users
INNER JOIN photographs
	ON users.user_ID = photographs.user_ID;

-- ----------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Employee_Occupation;
DROP TABLE IF EXISTS Employee_Address;
DROP TABLE IF EXISTS Employee;


 CREATE TABLE Employee(
 Employee_ID INT PRIMARY KEY, 
 Employee_LastName VARCHAR(50) NOT NULL, 
 Employee_FirstName VARCHAR(50) NOT NULL
 );
 
 CREATE TABLE Employee_Address(
 Employee_ID INT AUTO_INCREMENT PRIMARY KEY, 
 Street_Address VARCHAR(50), 
 City VARCHAR(50), 
 State VARCHAR(2), 
 Zip_Code INT,
 FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
	ON DELETE CASCADE
    ON UPDATE CASCADE
 );
 
 CREATE TABLE Employee_Occupation(
 Employee_ID INT PRIMARY KEY, 
 Department VARCHAR (100),
 Manager_ID INT, 
 Position VARCHAR(50) NOT NULL, 
 Salary DECIMAL(10, 2) NOT NULL CHECK (Salary >= 0),
 FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
 FOREIGN KEY (Manager_ID) REFERENCES Employee(Employee_ID)
 );
 
 INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (1000, 'Smith', 'Alex');  
 INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (1015, 'Johnson', 'Mary');
 INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (1021, 'Taylor', 'Chris');
 
INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES(1005, 'Doe', 'Janet');
INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (1010, 'Eyre', 'Jane');
INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (1011, 'Bronte', 'Charlotte');
INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (2060,'Poe', 'Edgar');
INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (2090, 'Dickens', 'Charles');
INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (2100, 'Doyle', 'AC');
INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (3230, 'Uberville', 'Tess');
INSERT INTO employee (Employee_ID, Employee_LastName, Employee_FirstName) VALUES (3330, 'Dumas', 'Alex');

INSERT INTO employee_address (Employee_ID, Street_Address, City, State, Zip_Code) VALUES(1005, '312 Maple Drive', 'Anytown', 'FL', 32829);
INSERT INTO employee_address (Employee_ID, Street_Address, City, State, Zip_Code) VALUES(1010, '1200 First Street', 'Anytown', 'FL', 32829);
INSERT INTO employee_address (Employee_ID, Street_Address, City, State, Zip_Code) VALUES(1011, '4989 Fleur de Lane', 'Sometown', 'FL', 32829);
INSERT INTO employee_address (Employee_ID, Street_Address, City, State, Zip_Code) VALUES(2060, '12 Arcadia Avenue', 'Anytown', 'FL', 32829);
INSERT INTO employee_address (Employee_ID, Street_Address, City, State, Zip_Code) VALUES(2090, '687 Gulf View Street', 'Sometown', 'FL', 32830);
INSERT INTO employee_address (Employee_ID, Street_Address, City, State, Zip_Code) VALUES(2100, '1209 Pine Tree Lane','Sometown', 'FL', 32831);
INSERT INTO employee_address (Employee_ID, Street_Address, City, State, Zip_Code) VALUES(3230, '5435 Main Street', 'Anytown','FL', 32831);
INSERT INTO employee_address (Employee_ID, Street_Address, City, State, Zip_Code) VALUES(3330, '3 Post Drive', 'Sometown', 'FL', 32831);

INSERT INTO employee_occupation (Employee_ID, Department, Manager_ID, Position, Salary) VALUES(1005, 'Board of Directors', 1000, 'President', 100000);
INSERT INTO employee_occupation (Employee_ID, Department, Manager_ID, Position, Salary) VALUES(1010, 'Administration', 1005, 'Vice President', 95000);
INSERT INTO employee_occupation (Employee_ID, Department, Manager_ID, Position, Salary) VALUES(1011, 'Administration', 1005, 'Vice President', 75000);
INSERT INTO employee_occupation (Employee_ID, Department, Manager_ID, Position, Salary) VALUES(2060, 'Information Technology', 1015, 'Programmer II', 70000);
INSERT INTO employee_occupation (Employee_ID, Department, Manager_ID, Position, Salary) VALUES(2090, 'Information Technology', 1015, 'Programmer I', 45000);
INSERT INTO employee_occupation (Employee_ID, Department, Manager_ID, Position, Salary) VALUES(3230, 'Sales', 1021, 'Sales Representative', 50000);
INSERT INTO employee_occupation (Employee_ID, Department, Manager_ID, Position, Salary) VALUES(3330, 'Sales', 1021, 'Sales Representative', 35000);


SELECT *
FROM employee;

SELECT *
FROM employee_address;

SELECT *
FROM employee_occupation;

SELECT *
FROM employee
INNER JOIN employee_address
	ON employee.Employee_ID = employee_address.Employee_ID
INNER JOIN employee_occupation
	ON employee.Employee_ID = employee_occupation.Employee_ID;






