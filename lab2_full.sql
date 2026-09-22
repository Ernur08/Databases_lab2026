/*
LABORATORY WORK #2 — DATABASE NORMALIZATION AND DDL
DBMS: PostgreSQL

GitHub file: lab2.sql

PART 1 — NORMALIZATION THEORY (Booking_receipt)

Original relation:
Booking_receipt(booking_id, passenger_full_name, passenger_passport_number,
flight_number, departure_airport_name, departure_city,
arrival_airport_name, arrival_city, airline_name, seat_numbers, ticket_price)

1NF violation:
- seat_numbers stores multiple values in one cell (e.g. '12A, 12B').
- 1NF requires atomic values.

2NF:
- After 1NF, passenger/booking/flight details should not be repeated in a
  relation with a composite key.
- Passenger details depend on passenger_id; flight details depend on
  flight_number; booking price/flight depend on booking_id.

3NF:
- Airport name/city depend on airport_id.
- Airline name depends on airline_id.
- Store these facts in separate Airport and Airline relations.

Functional dependencies used:
booking_id -> flight_number, ticket_price
passenger_id -> passenger_full_name, passenger_passport_number
flight_number -> departure_airport_id, arrival_airport_id, airline_id
airport_id -> airport_name, city
airline_id -> airline_name
(booking_id, passenger_id) -> seat_number

3NF design:
Airline_receipt(airline_id PK, airline_name)
Airport_receipt(airport_id PK, airport_name, city)
Flight_receipt(flight_number PK, departure_airport_id FK,
               arrival_airport_id FK, airline_id FK)
Passenger_receipt(passenger_id PK, passenger_full_name,
                  passenger_passport_number UNIQUE)
Booking_receipt(booking_id PK, flight_number FK, ticket_price)
Booking_passenger(booking_id PK/FK, passenger_id PK/FK, seat_number)

PART A — IMPLEMENT NORMALIZED 3NF TABLES
*/

DROP TABLE IF EXISTS booking_passenger CASCADE;
DROP TABLE IF EXISTS booking_receipt CASCADE;
DROP TABLE IF EXISTS passenger_receipt CASCADE;
DROP TABLE IF EXISTS flight_receipt CASCADE;
DROP TABLE IF EXISTS airport_receipt CASCADE;
DROP TABLE IF EXISTS airline_receipt CASCADE;

CREATE TABLE airline_receipt (
    airline_id   INT PRIMARY KEY,
    airline_name VARCHAR(50) NOT NULL
);

CREATE TABLE airport_receipt (
    airport_id   INT PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city         VARCHAR(50) NOT NULL
);

CREATE TABLE flight_receipt (
    flight_number         VARCHAR(20) PRIMARY KEY,
    departure_airport_id  INT NOT NULL REFERENCES airport_receipt(airport_id),
    arrival_airport_id    INT NOT NULL REFERENCES airport_receipt(airport_id),
    airline_id            INT NOT NULL REFERENCES airline_receipt(airline_id)
);

CREATE TABLE passenger_receipt (
    passenger_id INT PRIMARY KEY,
    passenger_full_name VARCHAR(100) NOT NULL,
    passenger_passport_number VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE booking_receipt (
    booking_id INT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL REFERENCES flight_receipt(flight_number),
    ticket_price DECIMAL(7,2) NOT NULL CHECK (ticket_price >= 0)
);

CREATE TABLE booking_passenger (
    booking_id INT NOT NULL REFERENCES booking_receipt(booking_id),
    passenger_id INT NOT NULL REFERENCES passenger_receipt(passenger_id),
    seat_number VARCHAR(10) NOT NULL,
    PRIMARY KEY (booking_id, passenger_id),
    UNIQUE (booking_id, seat_number)
);

/* Sample rows for normalized receipt dataset */
INSERT INTO airline_receipt (airline_id, airline_name) VALUES
(1, 'Air Astana'),
(2, 'SCAT Airlines');

INSERT INTO airport_receipt (airport_id, airport_name, city) VALUES
(1, 'Almaty International Airport', 'Almaty'),
(2, 'Nursultan Nazarbayev International Airport', 'Astana'),
(3, 'Shymkent International Airport', 'Shymkent');

INSERT INTO flight_receipt
(flight_number, departure_airport_id, arrival_airport_id, airline_id) VALUES
('KC101', 1, 2, 1),
('KC202', 2, 1, 1),
('DV303', 1, 3, 2);

INSERT INTO passenger_receipt
(passenger_id, passenger_full_name, passenger_passport_number) VALUES
(1, 'Aruzhan Sadyk', 'N1234567'),
(2, 'Dias Omar', 'N2345678'),
(3, 'Amina Bek', 'N3456789'),
(4, 'Alikhan Nur', 'N4567890'),
(5, 'Dana Serik', 'N5678901');

INSERT INTO booking_receipt (booking_id, flight_number, ticket_price) VALUES
(1001, 'KC101', 25000.00),
(1002, 'KC101', 25000.00),
(1003, 'KC202', 27000.00),
(1004, 'DV303', 18000.00),
(1005, 'KC202', 27000.00);

INSERT INTO booking_passenger (booking_id, passenger_id, seat_number) VALUES
(1001, 1, '12A'),
(1002, 2, '12B'),
(1003, 3, '14C'),
(1004, 4, '8A'),
(1005, 5, '15D');

/*
PART B — AIRPORT DATABASE DDL
Requirements from the assignment:
- Create Airline_info, Airport, Baggage_check, Baggage, Boarding_pass,
  Booking_flight, Booking, Flights, Passengers, Security_check.
- Define primary keys and NOT NULL constraints.
- Rename Airline_info to Airline.
- Rename Booking.price to ticket_price.
- Change Flights.departing_gate to TEXT.
- Drop Airline.info.
- Add requested foreign-key relationships.

This script creates the final schema directly (equivalent final state).
*/

DROP TABLE IF EXISTS Security_check CASCADE;
DROP TABLE IF EXISTS Boarding_pass CASCADE;
DROP TABLE IF EXISTS Baggage_check CASCADE;
DROP TABLE IF EXISTS Baggage CASCADE;
DROP TABLE IF EXISTS Booking_flight CASCADE;
DROP TABLE IF EXISTS Booking CASCADE;
DROP TABLE IF EXISTS Flights CASCADE;
DROP TABLE IF EXISTS Passengers CASCADE;
DROP TABLE IF EXISTS Airport CASCADE;
DROP TABLE IF EXISTS Airline CASCADE;

CREATE TABLE Airline (
    airline_id INT PRIMARY KEY,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Airport (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50) NOT NULL,
    country_of_citizenship VARCHAR(50) NOT NULL,
    country_of_residence VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    sch_departure_time TIMESTAMP NOT NULL,
    sch_arrival_time TIMESTAMP NOT NULL,
    departing_airport_id INT NOT NULL REFERENCES Airport(airport_id),
    arriving_airport_id INT NOT NULL REFERENCES Airport(airport_id),
    departing_gate TEXT NOT NULL,
    arriving_gate VARCHAR(50) NOT NULL,
    airline_id INT NOT NULL REFERENCES Airline(airline_id),
    act_departure_time TIMESTAMP NOT NULL,
    act_arrival_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    flight_id INT NOT NULL REFERENCES Flights(flight_id),
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id),
    booking_platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,
    ticket_price DECIMAL(7,2) NOT NULL CHECK (ticket_price >= 0)
);

CREATE TABLE Booking_flight (
    booking_flight_id INT PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    flight_id INT NOT NULL REFERENCES Flights(flight_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (booking_id, flight_id)
);

CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY,
    weight_in_kg DECIMAL(4,2) NOT NULL CHECK (weight_in_kg >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    booking_id INT NOT NULL REFERENCES Booking(booking_id)
);

CREATE TABLE Baggage_check (
    baggage_check_id INT PRIMARY KEY,
    check_result VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id)
);

CREATE TABLE Boarding_pass (
    boarding_pass_id INT PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Security_check (
    security_check_id INT PRIMARY KEY,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id)
);

/*
PART C — SAMPLE DATA FOR AIRPORT DATABASE
Insert parent tables first, then dependent tables.
*/

INSERT INTO Airline (airline_id, airline_code, airline_name, airline_country) VALUES
(1, 'KC', 'Air Astana', 'Kazakhstan'),
(2, 'DV', 'SCAT Airlines', 'Kazakhstan');

INSERT INTO Airport (airport_id, airport_name, country, state, city) VALUES
(1, 'Almaty International Airport', 'Kazakhstan', 'Almaty', 'Almaty'),
(2, 'Nursultan Nazarbayev International Airport', 'Kazakhstan', 'Astana', 'Astana'),
(3, 'Shymkent International Airport', 'Kazakhstan', 'Turkistan Region', 'Shymkent');

INSERT INTO Passengers
(passenger_id, first_name, last_name, date_of_birth, gender,
 country_of_citizenship, country_of_residence, passport_number) VALUES
(1, 'Aruzhan', 'Sadyk', '2005-02-10', 'Female', 'Kazakhstan', 'Kazakhstan', 'KZ100001'),
(2, 'Dias', 'Omar', '2004-07-21', 'Male', 'Kazakhstan', 'Kazakhstan', 'KZ100002'),
(3, 'Amina', 'Bek', '2006-11-03', 'Female', 'Kazakhstan', 'Kazakhstan', 'KZ100003'),
(4, 'Alikhan', 'Nur', '2005-05-14', 'Male', 'Kazakhstan', 'Kazakhstan', 'KZ100004'),
(5, 'Dana', 'Serik', '2004-09-30', 'Female', 'Kazakhstan', 'Kazakhstan', 'KZ100005');

INSERT INTO Flights
(flight_id, sch_departure_time, sch_arrival_time, departing_airport_id,
 arriving_airport_id, departing_gate, arriving_gate, airline_id,
 act_departure_time, act_arrival_time) VALUES
(1, '2026-10-01 08:00:00', '2026-10-01 10:00:00', 1, 2, 'A1', 'B1', 1,
 '2026-10-01 08:05:00', '2026-10-01 10:02:00'),
(2, '2026-10-02 12:00:00', '2026-10-02 14:00:00', 2, 1, 'B2', 'A2', 1,
 '2026-10-02 12:03:00', '2026-10-02 14:05:00'),
(3, '2026-10-03 15:00:00', '2026-10-03 16:00:00', 1, 3, 'A3', 'C1', 2,
 '2026-10-03 15:00:00', '2026-10-03 16:10:00');

INSERT INTO Booking
(booking_id, flight_id, passenger_id, booking_platform, status, ticket_price) VALUES
(101, 1, 1, 'Website', 'Confirmed', 25000.00),
(102, 1, 2, 'Mobile app', 'Confirmed', 25000.00),
(103, 2, 3, 'Website', 'Confirmed', 27000.00),
(104, 2, 4, 'Travel agency', 'Pending', 27000.00),
(105, 3, 5, 'Mobile app', 'Confirmed', 18000.00);

INSERT INTO Booking_flight (booking_flight_id, booking_id, flight_id) VALUES
(1, 101, 1),
(2, 102, 1),
(3, 103, 2),
(4, 104, 2),
(5, 105, 3);

INSERT INTO Baggage (baggage_id, weight_in_kg, booking_id) VALUES
(1, 12.50, 101),
(2, 15.00, 102),
(3, 10.25, 103),
(4, 18.00, 104),
(5, 9.75, 105);

INSERT INTO Baggage_check
(baggage_check_id, check_result, booking_id, passenger_id) VALUES
(1, 'Passed', 101, 1),
(2, 'Passed', 102, 2),
(3, 'Passed', 103, 3),
(4, 'Passed', 104, 4),
(5, 'Passed', 105, 5);

INSERT INTO Boarding_pass
(boarding_pass_id, booking_id, seat, boarding_time) VALUES
(1, 101, '12A', '2026-10-01 07:15:00'),
(2, 102, '12B', '2026-10-01 07:15:00'),
(3, 103, '14C', '2026-10-02 11:15:00'),
(4, 104, '14D', '2026-10-02 11:15:00'),
(5, 105, '8A', '2026-10-03 14:15:00');

INSERT INTO Security_check (security_check_id, check_result, passenger_id) VALUES
(1, 'Passed', 1),
(2, 'Passed', 2),
(3, 'Passed', 3),
(4, 'Passed', 4),
(5, 'Passed', 5);

/*
PART D — VERIFICATION QUERIES
Run these SELECT statements to show table contents in screenshots.
*/

SELECT * FROM airline_receipt;
SELECT * FROM airport_receipt;
SELECT * FROM flight_receipt;
SELECT * FROM passenger_receipt;
SELECT * FROM booking_receipt;
SELECT * FROM booking_passenger;

SELECT * FROM Airline;
SELECT * FROM Airport;
SELECT * FROM Passengers;
SELECT * FROM Flights;
SELECT * FROM Booking;
SELECT * FROM Booking_flight;
SELECT * FROM Baggage;
SELECT * FROM Baggage_check;
SELECT * FROM Boarding_pass;
SELECT * FROM Security_check;

/* Example join: booking + passenger + flight */
SELECT
    b.booking_id,
    p.first_name,
    p.last_name,
    f.flight_id,
    b.ticket_price,
    b.status
FROM Booking b
JOIN Passengers p ON p.passenger_id = b.passenger_id
JOIN Flights f ON f.flight_id = b.flight_id
ORDER BY b.booking_id;
