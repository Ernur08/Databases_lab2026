-- Laboratory work 2
-- Database: airport_db
-- PostgreSQL

-- =========================
-- PART 1. NORMALIZATION
-- =========================

-- 1NF:
-- seat_numbers has more than one value in one cell.
-- In 1NF, each seat is stored in a separate row.

-- 2NF:
-- Passenger information is stored separately from booking information.

-- 3NF:
-- Airport and airline information are stored in separate tables.

-- Functional dependencies:
-- booking_id -> flight_number, ticket_price
-- passenger_id -> passenger_full_name, passenger_passport_number
-- flight_number -> departure_airport_id, arrival_airport_id, airline_id
-- airport_id -> airport_name, city
-- airline_id -> airline_name
-- (booking_id, passenger_id) -> seat_number

CREATE TABLE Airline_receipt (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(50) NOT NULL
);

CREATE TABLE Airport_receipt (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE Flight_receipt (
    flight_number VARCHAR(20) PRIMARY KEY,
    departure_airport_id INT REFERENCES Airport_receipt(airport_id),
    arrival_airport_id INT REFERENCES Airport_receipt(airport_id),
    airline_id INT REFERENCES Airline_receipt(airline_id)
);

CREATE TABLE Passenger_receipt (
    passenger_id INT PRIMARY KEY,
    passenger_full_name VARCHAR(100) NOT NULL,
    passenger_passport_number VARCHAR(20) NOT NULL
);

CREATE TABLE Booking_receipt (
    booking_id INT PRIMARY KEY,
    flight_number VARCHAR(20) REFERENCES Flight_receipt(flight_number),
    ticket_price DECIMAL(7,2) NOT NULL
);

CREATE TABLE Booking_passenger (
    booking_id INT REFERENCES Booking_receipt(booking_id),
    passenger_id INT REFERENCES Passenger_receipt(passenger_id),
    seat_number VARCHAR(10) NOT NULL,
    PRIMARY KEY (booking_id, passenger_id)
);

-- Insert sample data for normalization tables

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
(101, 'KC101', 25000),
(102, 'KC101', 25000),
(103, 'KC202', 27000),
(104, 'DV303', 18000),
(105, 'KC202', 27000);

INSERT INTO Booking_passenger VALUES
(101, 1, '12A'),
(102, 2, '12B'),
(103, 3, '14C'),
(104, 4, '8A'),
(105, 5, '15D');

-- =========================
-- PART 2. DDL
-- =========================

CREATE TABLE Airline (
    airline_id INT PRIMARY KEY,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Airport (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

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
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    flight_id INT NOT NULL REFERENCES Flights(flight_id),
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id),
    booking_platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    ticket_price DECIMAL(7,2) NOT NULL
);

CREATE TABLE Booking_flight (
    booking_flight_id INT PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    flight_id INT NOT NULL REFERENCES Flights(flight_id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY,
    weight_in_kg DECIMAL(4,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL REFERENCES Booking(booking_id)
);

CREATE TABLE Boarding_pass (
    boarding_pass_id INT PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Baggage_check (
    baggage_check_id INT PRIMARY KEY,
    check_result VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id)
);

CREATE TABLE Security_check (
    security_check_id INT PRIMARY KEY,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id)
);

-- =========================
-- PART 3. SAMPLE DATA
-- =========================

INSERT INTO Airline VALUES
(1, 'KC', 'Air Astana', 'Kazakhstan', NOW(), NOW()),
(2, 'DV', 'SCAT Airlines', 'Kazakhstan', NOW(), NOW());

INSERT INTO Airport VALUES
(1, 'Almaty Airport', 'Kazakhstan', 'Almaty', 'Almaty', NOW(), NOW()),
(2, 'Astana Airport', 'Kazakhstan', 'Astana', 'Astana', NOW(), NOW());

INSERT INTO Passengers VALUES
(1, 'Aruzhan', 'Sadyk', '2005-02-10', 'Female', 'Kazakhstan', 'Kazakhstan', 'KZ200001', NOW(), NOW()),
(2, 'Dias', 'Omar', '2004-07-21', 'Male', 'Kazakhstan', 'Kazakhstan', 'KZ200002', NOW(), NOW()),
(3, 'Amina', 'Bek', '2006-11-03', 'Female', 'Kazakhstan', 'Kazakhstan', 'KZ200003', NOW(), NOW()),
(4, 'Alikhan', 'Nur', '2005-05-14', 'Male', 'Kazakhstan', 'Kazakhstan', 'KZ200004', NOW(), NOW()),
(5, 'Dana', 'Serik', '2004-09-30', 'Female', 'Kazakhstan', 'Kazakhstan', 'KZ200005', NOW(), NOW());

INSERT INTO Flights VALUES
(1, '2026-10-01 08:00', '2026-10-01 10:00', 1, 2, 'A1', 'B1', 1, '2026-10-01 08:05', '2026-10-01 10:02', NOW(), NOW()),
(2, '2026-10-02 12:00', '2026-10-02 14:00', 2, 1, 'B2', 'A2', 1, '2026-10-02 12:03', '2026-10-02 14:05', NOW(), NOW());

INSERT INTO Booking VALUES
(101, 1, 1, 'Website', NOW(), NOW(), 'Confirmed', 25000),
(102, 1, 2, 'Mobile app', NOW(), NOW(), 'Confirmed', 25000),
(103, 2, 3, 'Website', NOW(), NOW(), 'Confirmed', 27000),
(104, 2, 4, 'Agency', NOW(), NOW(), 'Pending', 27000),
(105, 1, 5, 'Mobile app', NOW(), NOW(), 'Confirmed', 25000);

INSERT INTO Booking_flight VALUES
(1, 101, 1, NOW(), NOW()),
(2, 102, 1, NOW(), NOW()),
(3, 103, 2, NOW(), NOW()),
(4, 104, 2, NOW(), NOW()),
(5, 105, 1, NOW(), NOW());

INSERT INTO Baggage VALUES
(1, 12.50, NOW(), NOW(), 101),
(2, 15.00, NOW(), NOW(), 102),
(3, 10.25, NOW(), NOW(), 103),
(4, 18.00, NOW(), NOW(), 104),
(5, 9.75, NOW(), NOW(), 105);

INSERT INTO Boarding_pass VALUES
(1, 101, '12A', '2026-10-01 07:15', NOW(), NOW()),
(2, 102, '12B', '2026-10-01 07:15', NOW(), NOW()),
(3, 103, '14C', '2026-10-02 11:15', NOW(), NOW()),
(4, 104, '14D', '2026-10-02 11:15', NOW(), NOW()),
(5, 105, '15A', '2026-10-01 07:15', NOW(), NOW());

INSERT INTO Baggage_check VALUES
(1, 'Passed', NOW(), NOW(), 101, 1),
(2, 'Passed', NOW(), NOW(), 102, 2),
(3, 'Passed', NOW(), NOW(), 103, 3),
(4, 'Passed', NOW(), NOW(), 104, 4),
(5, 'Passed', NOW(), NOW(), 105, 5);

INSERT INTO Security_check VALUES
(1, 'Passed', NOW(), NOW(), 1),
(2, 'Passed', NOW(), NOW(), 2),
(3, 'Passed', NOW(), NOW(), 3),
(4, 'Passed', NOW(), NOW(), 4),
(5, 'Passed', NOW(), NOW(), 5);

-- =========================
-- PART 4. SHOW TABLE DATA
-- =========================

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
