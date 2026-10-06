-- 1
SELECT UPPER(airline_name) AS airline_name_upper
FROM airline;

-- 2
SELECT airline_name,
       REPLACE(airline_name, 'Air', 'Aero') AS new_airline_name
FROM airline;

-- 3
SELECT flight_id FROM flights WHERE airline_id = 1
INTERSECT
SELECT flight_id FROM flights WHERE airline_id = 2;

SELECT f.flight_id, f.departing_airport_id, f.arriving_airport_id, f.airline_id
FROM flights f
WHERE f.airline_id IN (1, 2)
  AND (f.departing_airport_id, f.arriving_airport_id) IN (
        SELECT departing_airport_id, arriving_airport_id
        FROM flights
        WHERE airline_id IN (1, 2)
        GROUP BY departing_airport_id, arriving_airport_id
        HAVING COUNT(DISTINCT airline_id) = 2
  );

-- 4
SELECT *
FROM airport
WHERE airport_name ILIKE '%Regional%'
  AND airport_name ILIKE '%Air%';

-- 5
SELECT first_name,
       last_name,
       TO_CHAR(date_of_birth, 'FMMonth DD, YYYY') AS date_of_birth_formatted
FROM passengers;

-- 6
SELECT DISTINCT flight_id
FROM flights
WHERE act_arrival_time > sch_arrival_time;

-- 7
SELECT flight_id,
       sch_arrival_time,
       act_arrival_time,
       act_arrival_time - sch_arrival_time AS delay
FROM flights
WHERE act_arrival_time > sch_arrival_time;

-- 8
SELECT *
FROM airline
WHERE UPPER(airline_country) IN ('FRANCE', 'PORTUGAL', 'POLAND')
  AND created_at BETWEEN '2023-11-01' AND '2024-03-31';

-- 9
SELECT *
FROM baggage
WHERE weight_in_kg > 25
ORDER BY weight_in_kg DESC
LIMIT 3;

-- 10
SELECT first_name || ' ' || last_name AS full_name
FROM passengers
WHERE date_of_birth = (SELECT MAX(date_of_birth) FROM passengers);

-- 11
SELECT booking_platform,
       MIN(ticket_price) AS cheapest_price
FROM booking
GROUP BY booking_platform;

-- 12
SELECT *
FROM airline
WHERE airline_code ~ '[0-9]';

-- 13
SELECT *
FROM airline
ORDER BY created_at DESC
LIMIT 5;

-- 14
SELECT *
FROM baggage_check
WHERE booking_id BETWEEN 200 AND 300
  AND check_result <> 'Checked';

-- 15
SELECT *
FROM baggage_check
WHERE DATE_TRUNC('month', updated_at) = DATE_TRUNC('month', created_at)
  AND updated_at < created_at;
