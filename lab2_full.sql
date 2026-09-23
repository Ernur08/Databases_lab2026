-- =====================================================
-- LABORATORY WORK #2
-- NORMALIZATION AND DDL
-- PostgreSQL
-- =====================================================


-- =====================================================
-- PART 1. NORMALIZATION
-- =====================================================



-- -----------------------------------------------------
-- 1. Create Airline_receipt table
-- -----------------------------------------------------

CREATE TABLE Airline_receipt (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(50) NOT NULL
);


-- -----------------------------------------------------
-- 2. Create Airport_receipt table
-- -----------------------------------------------------

CREATE TABLE Airport_receipt (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);


-- -----------------------------------------------------
-- 3. Create Flight_receipt table
-- -----------------------------------------------------

CREATE TABLE Flight_receipt (
    flight_number VARCHAR(20) PRIMARY KEY,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    airline_id INT NOT NULL,

    FOREIGN KEY (departure_airport_id)
        REFERENCES Airport_receipt(airport_id),

    FOREIGN KEY (arrival_airport_id)
        REFERENCES Airport_receipt(airport_id),

    FOREIGN KEY (airline_id)
        REFERENCES Airline_receipt(airline_id)
);


-- -----------------------------------------------------
-- 4. Create Passenger_receipt table
-- -----------------------------------------------------

CREATE TABLE Passenger_receipt (
    passenger_id INT PRIMARY KEY,
    passenger_full_name VARCHAR(100) NOT NULL,
    passenger_passport_number VARCHAR(20) NOT NULL UNIQUE
);


-- -----------------------------------------------------
-- 5. Create Booking_receipt table
-- -----------------------------------------------------

CREATE TABLE Booking_receipt (
    booking_id INT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL,
    ticket_price DECIMAL(7,2) NOT NULL,

    FOREIGN KEY (flight_number)
        REFERENCES Flight_receipt(flight_number)
);


-- -----------------------------------------------------
-- 6. Create Booking_passenger table
-- -----------------------------------------------------

CREATE TABLE Booking_passenger (
    booking_id INT NOT NULL,
    passenger_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,

    PRIMARY KEY (booking_id, passenger_id),

    FOREIGN KEY (booking_id)
        REFERENCES Booking_receipt(booking_id),

    FOREIGN KEY (passenger_id)
        REFERENCES Passenger_receipt(passenger_id)
);


-- =====================================================
-- INSERT SAMPLE DATA INTO NORMALIZATION TABLES
-- =====================================================


INSERT INTO Airline_receipt VALUES
(1, 'Air Astana'),
(2, 'SCAT Airlines');


INSERT INTO Airport_receipt VALUES
(1, 'Almaty Airport', 'Almaty'),
(2, 'Astana Airport', 'Astana'),
(3, 'Shymkent Airport', 'Shymkent');


INSERT INTO Flight_receipt VALUES
('KC101', 1, 2, 1),
('KC202', 2, 1, 1),
('DV303', 1, 3, 2);


INSERT INTO Passenger_receipt VALUES
(1, 'Aruzhan Sadyk', 'KZ100001'),
(2, 'Dias Omar', 'KZ100002'),
(3, 'Amina Bek', 'KZ100003'),
(4, 'Alikhan Nur', 'KZ100004'),
(5, 'Dana Serik', 'KZ100005');


INSERT INTO Booking_receipt VALUES
(101, 'KC101', 25000.00),
(102, 'KC101', 25000.00),
(103, 'KC202', 27000.00),
(104, 'DV303', 18000.00),
(105, 'KC202', 27000.00);


INSERT INTO Booking_passenger VALUES
(101, 1, '12A'),
(102, 2, '12B'),
(103, 3, '14C'),
(104, 4, '8A'),
(105, 5, '15D');




-- =====================================================
-- PART 2. DDL
-- CREATE AIRPORT DATABASE TABLES
-- =====================================================


-- -----------------------------------------------------
-- 1. Create Airline_info table
-- -----------------------------------------------------

CREATE TABLE Airline_info (
    airline_id INT PRIMARY KEY,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    info VARCHAR(50) NOT NULL
);


-- Rename Airline_info to Airline

ALTER TABLE Airline_info
RENAME TO Airline;


-- Drop info column

ALTER TABLE Airline
DROP COLUMN info;


-- -----------------------------------------------------
-- 2. Create Airport table
-- -----------------------------------------------------

CREATE TABLE Airport (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);


-- -----------------------------------------------------
-- 3. Create Passengers table
-- -----------------------------------------------------

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50) NOT NULL,
    country_of_citizenship VARCHAR(50) NOT NULL,
    country_of_residence VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);


-- -----------------------------------------------------
-- 4. Create Flights table
-- -----------------------------------------------------

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    sch_departure_time TIMESTAMP NOT NULL,
    sch_arrival_time TIMESTAMP NOT NULL,
    departing_airport_id INT NOT NULL,
    arriving_airport_id INT NOT NULL,
    departing_gate TEXT NOT NULL,
    arriving_gate VARCHAR(50) NOT NULL,
    airline_id INT NOT NULL,
    act_departure_time TIMESTAMP NOT NULL,
    act_arrival_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,

    FOREIGN KEY (departing_airport_id)
        REFERENCES Airport(airport_id),

    FOREIGN KEY (arriving_airport_id)
        REFERENCES Airport(airport_id),

    FOREIGN KEY (airline_id)
        REFERENCES Airline(airline_id)
);


-- -----------------------------------------------------
-- 5. Create Booking table
-- -----------------------------------------------------

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    booking_platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    ticket_price DECIMAL(7,2) NOT NULL,

    FOREIGN KEY (flight_id)
        REFERENCES Flights(flight_id),

    FOREIGN KEY (passenger_id)
        REFERENCES Passengers(passenger_id)
);


-- -----------------------------------------------------
-- 6. Create Booking_flight table
-- -----------------------------------------------------

CREATE TABLE Booking_flight (
    booking_flight_id INT PRIMARY KEY,
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,

    FOREIGN KEY (booking_id)
        REFERENCES Booking(booking_id),

    FOREIGN KEY (flight_id)
        REFERENCES Flights(flight_id)
);


-- -----------------------------------------------------
-- 7. Create Baggage table
-- -----------------------------------------------------

CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY,
    weight_in_kg DECIMAL(4,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL,

    FOREIGN KEY (booking_id)
        REFERENCES Booking(booking_id)
);


-- -----------------------------------------------------
-- 8. Create Boarding_pass table
-- -----------------------------------------------------

CREATE TABLE Boarding_pass (
    boarding_pass_id INT PRIMARY KEY,
    booking_id INT NOT NULL,
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,

    FOREIGN KEY (booking_id)
        REFERENCES Booking(booking_id)
);


-- -----------------------------------------------------
-- 9. Create Baggage_check table
-- -----------------------------------------------------

CREATE TABLE Baggage_check (
    baggage_check_id INT PRIMARY KEY,
    check_result VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL,
    passenger_id INT NOT NULL,

    FOREIGN KEY (booking_id)
        REFERENCES Booking(booking_id),

    FOREIGN KEY (passenger_id)
        REFERENCES Passengers(passenger_id)
);


-- -----------------------------------------------------
-- 10. Create Security_check table
-- -----------------------------------------------------

CREATE TABLE Security_check (
    security_check_id INT PRIMARY KEY,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    passenger_id INT NOT NULL,

    FOREIGN KEY (passenger_id)
        REFERENCES Passengers(passenger_id)
);


-- =====================================================
-- PART 3. INSERT SAMPLE DATA
-- =====================================================


-- -----------------------------------------------------
-- Airline data
-- -----------------------------------------------------

INSERT INTO Airline VALUES
(1, 'KC', 'Air Astana', 'Kazakhstan', NOW(), NOW()),
(2, 'DV', 'SCAT Airlines', 'Kazakhstan', NOW(), NOW());


-- -----------------------------------------------------
-- Airport data
-- -----------------------------------------------------

INSERT INTO Airport VALUES
(1, 'Almaty Airport', 'Kazakhstan', 'Almaty',
 'Almaty', NOW(), NOW()),

(2, 'Astana Airport', 'Kazakhstan', 'Astana',
 'Astana', NOW(), NOW()),

(3, 'Shymkent Airport', 'Kazakhstan', 'Shymkent',
 'Shymkent', NOW(), NOW());


-- -----------------------------------------------------
-- Passengers data
-- -----------------------------------------------------

INSERT INTO Passengers VALUES
(1, 'Aruzhan', 'Sadyk', '2005-02-10', 'Female',
 'Kazakhstan', 'Kazakhstan', 'KZ200001', NOW(), NOW()),

(2, 'Dias', 'Omar', '2004-07-21', 'Male',
 'Kazakhstan', 'Kazakhstan', 'KZ200002', NOW(), NOW()),

(3, 'Amina', 'Bek', '2006-11-03', 'Female',
 'Kazakhstan', 'Kazakhstan', 'KZ200003', NOW(), NOW()),

(4, 'Alikhan', 'Nur', '2005-05-14', 'Male',
 'Kazakhstan', 'Kazakhstan', 'KZ200004', NOW(), NOW()),

(5, 'Dana', 'Serik', '2004-09-30', 'Female',
 'Kazakhstan', 'Kazakhstan', 'KZ200005', NOW(), NOW());


-- -----------------------------------------------------
-- Flights data
-- -----------------------------------------------------

INSERT INTO Flights VALUES

(1, '2026-10-01 08:00:00',
 '2026-10-01 10:00:00',
 1, 2, 'A1', 'B1', 1,
 '2026-10-01 08:05:00',
 '2026-10-01 10:02:00', NOW(), NOW()),

(2, '2026-10-02 12:00:00',
 '2026-10-02 14:00:00',
 2, 1, 'B2', 'A2', 1,
 '2026-10-02 12:03:00',
 '2026-10-02 14:05:00', NOW(), NOW()),

(3, '2026-10-03 09:00:00',
 '2026-10-03 11:00:00',
 1, 3, 'C1', 'C2', 2,
 '2026-10-03 09:05:00',
 '2026-10-03 11:10:00', NOW(), NOW());


-- -----------------------------------------------------
-- Booking data
-- -----------------------------------------------------

INSERT INTO Booking VALUES
(101, 1, 1, 'Website', NOW(), NOW(),
 'Confirmed', 25000.00),

(102, 1, 2, 'Mobile app', NOW(), NOW(),
 'Confirmed', 25000.00),

(103, 2, 3, 'Website', NOW(), NOW(),
 'Confirmed', 27000.00),

(104, 2, 4, 'Agency', NOW(), NOW(),
 'Pending', 27000.00),

(105, 3, 5, 'Mobile app', NOW(), NOW(),
 'Confirmed', 18000.00);


-- -----------------------------------------------------
-- Booking_flight data
-- -----------------------------------------------------

INSERT INTO Booking_flight VALUES
(1, 101, 1, NOW(), NOW()),
(2, 102, 1, NOW(), NOW()),
(3, 103, 2, NOW(), NOW()),
(4, 104, 2, NOW(), NOW()),
(5, 105, 3, NOW(), NOW());


-- -----------------------------------------------------
-- Baggage data
-- -----------------------------------------------------

INSERT INTO Baggage VALUES
(1, 12.50, NOW(), NOW(), 101),
(2, 15.00, NOW(), NOW(), 102),
(3, 10.25, NOW(), NOW(), 103),
(4, 18.00, NOW(), NOW(), 104),
(5, 9.75, NOW(), NOW(), 105);


-- -----------------------------------------------------
-- Boarding_pass data
-- -----------------------------------------------------

INSERT INTO Boarding_pass VALUES
(1, 101, '12A', '2026-10-01 07:15:00', NOW(), NOW()),
(2, 102, '12B', '2026-10-01 07:15:00', NOW(), NOW()),
(3, 103, '14C', '2026-10-02 11:15:00', NOW(), NOW()),
(4, 104, '14D', '2026-10-02 11:15:00', NOW(), NOW()),
(5, 105, '15A', '2026-10-03 08:15:00', NOW(), NOW());


-- -----------------------------------------------------
-- Baggage_check data
-- -----------------------------------------------------

INSERT INTO Baggage_check VALUES
(1, 'Passed', NOW(), NOW(), 101, 1),
(2, 'Passed', NOW(), NOW(), 102, 2),
(3, 'Passed', NOW(), NOW(), 103, 3),
(4, 'Passed', NOW(), NOW(), 104, 4),
(5, 'Passed', NOW(), NOW(), 105, 5);


-- -----------------------------------------------------
-- Security_check data
-- -----------------------------------------------------

INSERT INTO Security_check VALUES
(1, 'Passed', NOW(), NOW(), 1),
(2, 'Passed', NOW(), NOW(), 2),
(3, 'Passed', NOW(), NOW(), 3),
(4, 'Passed', NOW(), NOW(), 4),
(5, 'Passed', NOW(), NOW(), 5);


-- =====================================================
-- PART 4. DISPLAY ALL TABLE DATA
-- =====================================================


-- Normalization tables

SELECT * FROM Airline_receipt;
SELECT * FROM Airport_receipt;
SELECT * FROM Flight_receipt;
SELECT * FROM Passenger_receipt;
SELECT * FROM Booking_receipt;
SELECT * FROM Booking_passenger;


-- DDL tables

SELECT * FROM Airline;
SELECT * FROM Airport;
SELECT * FROM Passengers;
SELECT * FROM Flights;
SELECT * FROM Booking;
SELECT * FROM Booking_flight;
SELECT * FROM Baggage;
SELECT * FROM Boarding_pass;
SELECT * FROM Baggage_check;
SELECT * FROM Security_check;


-- =====================================================
-- PART 5. JOIN QUERIES
-- =====================================================


-- Booking with passenger information

SELECT
    Booking.booking_id,
    Passengers.first_name,
    Passengers.last_name,
    Booking.booking_platform,
    Booking.status,
    Booking.ticket_price
FROM Booking
JOIN Passengers
    ON Booking.passenger_id = Passengers.passenger_id;


-- Flight with airline and airport information

SELECT
    Flights.flight_id,
    Airline.airline_name,
    Airport1.airport_name AS departing_airport,
    Airport2.airport_name AS arriving_airport
FROM Flights

JOIN Airline
    ON Flights.airline_id = Airline.airline_id

JOIN Airport AS Airport1
    ON Flights.departing_airport_id = Airport1.airport_id

JOIN Airport AS Airport2
    ON Flights.arriving_airport_id = Airport2.airport_id;


-- Booking with baggage information

SELECT
    Booking.booking_id,
    Passengers.first_name,
    Passengers.last_name,
    Baggage.weight_in_kg
FROM Booking

JOIN Passengers
    ON Booking.passenger_id = Passengers.passenger_id

JOIN Baggage
    ON Booking.booking_id = Baggage.booking_id;


-- =====================================================
-- PART 6. FLIGHTS TABLE 3NF ANALYSIS
-- =====================================================

-- Primary key: flight_id
--
-- Functional dependency:
--
-- flight_id ->
-- sch_departure_time,
-- sch_arrival_time,
-- departing_airport_id,
-- arriving_airport_id,
-- departing_gate,
-- arriving_gate,
-- airline_id,
-- act_departure_time,
-- act_arrival_time,
-- created_at,
-- updated_at
--
-- The Flights table is in 3NF if flight_id is the
-- only determinant of its non-key attributes.
--
-- airline_id is a foreign key referencing Airline.
--
-- departing_airport_id and arriving_airport_id are
-- foreign keys referencing Airport.
--
-- Airline and airport names are stored in separate
-- tables. Therefore, there is no transitive dependency
-- between non-key attributes in Flights under these
-- assumptions.


-- Display Flights table for checking

SELECT * FROM Flights;


-- =====================================================
-- END OF LABORATORY WORK #2
-- =====================================================
