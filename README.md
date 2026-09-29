# Laboratory Work 1 — ERD Diagram

## Course

Databases

## Project Title

International Airport Database

## Objective

The objective of this laboratory work is to design an Entity-Relationship Diagram (ERD) for an International Airport Database.

## Database Entities

The database consists of the following entities:

1. Airport
2. Airline
3. Flight
4. Passenger
5. Booking
6. Booking_Change
7. Boarding_Pass
8. Baggage
9. Baggage_Check
10. Security_Check

## Relationships

The database represents one-to-many and one-to-zero-or-one relationships between entities.

Primary keys (PK) uniquely identify records. Foreign keys (FK) establish relationships between tables.

## Files

* `lab1.pdf` — ER diagram and textual description.
* `llab1` — Editable ER diagram source file.

## Tool

The ER diagram was created using diagrams.net.

# Airport Database — Laboratory work 3 (DML)

Continuation of Lab 1 (ERD) and Lab 2 (DDL, normalization) for the **International Airport** database.

- `lab3.sql` — all 15 DML tasks (INSERT / UPDATE / DELETE / RETURNING), PostgreSQL.
- `screenshots/` — a full-page screenshot of the code and result for each task.

## How to run
1. Create the tables from Lab 2.
2. Run `lab3.sql` from top to bottom (section 0 prepares the tables, task 1 generates 200 rows per table).

## Tasks
1. Generate 200 random rows  2. Add KazAir  3. Update KazAir country  4. Add three airlines
5. Delete 2024 flights  6. +15% ticket price  7. Delete tickets < 10000  8. Default code `UNK`
9. Delete old unchecked baggage checks  10. Delete airports (NULL state, Mlawe/Kepuh)
11. INSERT ... RETURNING  12. Uppercase countries  13. Update airline id 5
14. Set state for Astana/London/Tokyo  15. Mark March 2024 baggage checks as Checked
