-- FUNCTIONS FOR TABLE UPDATES
CREATE OR REPLACE FUNCTION update_rental_info()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
 -- Truncate the rental_info table to remove existing data
 TRUNCATE TABLE rental_info;
 -- Insert data into the rental_info table
 INSERT INTO rental_info (rental_id, film_id, title, rental_rate)
 SELECT
 rental.rental_id,
 inventory.film_id,
 film.title,
 film.rental_rate
 FROM
 rental
 INNER JOIN
 inventory ON rental.inventory_id = inventory.inventory_id
 INNER JOIN
 film ON film.film_id = inventory.film_id
 GROUP BY
 rental.rental_id, film.title, film.rental_rate, inventory.film_id
 ORDER BY
 rental.rental_id ASC;
 RETURN NEW;
END;
$$;
-- Drop the function if needed
-- DROP FUNCTION update_rental_info();
,
-- Function to update detailed_table
CREATE OR REPLACE FUNCTION update_detailed()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
 -- Truncate the detailed_table to remove existing data
 TRUNCATE TABLE detailed_table;
 -- Insert data into the detailed_table
 INSERT INTO detailed_table (film_id, title, rental_rate, 
rented_times, earnings)
 SELECT
 film_id,
 title,
 rental_rate::money,
 COUNT(film_id) AS rented_times,
 (COUNT(film_id) * rental_rate)::money AS earnings
 FROM rental_info
 GROUP BY film_id, title, rental_rate
 ORDER BY earnings DESC, title
 LIMIT 10;
 RETURN NEW;
END;
$$;
-- Drop the function if needed
-- DROP FUNCTION update_detailed();;
                                                                                                                                                                                                       -- Function to update summary_table
CREATE OR REPLACE FUNCTION update_summary()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
 -- Truncate the summary_table to remove existing 
data
 TRUNCATE TABLE summary_table;
 -- Insert data into the summary_table
 INSERT INTO summary_table (title, earnings)
 SELECT
 title,
 earnings
 FROM detailed_table
 ORDER BY earnings DESC, title
 LIMIT 10;
 RETURN NEW;
END;
$$;
                                                                                                                                                                                                      -- DETAILED TABLE
CREATE TABLE detailed_table AS
WITH detailed_data AS (
 SELECT
 rental_info.film_id,
 rental_info.title,
 rental_info.rental_rate::money,
 COUNT(rental_info.film_id) AS times_rented,
 (COUNT(rental_info.film_id) * 
rental_info.rental_rate)::money AS revenue
 FROM
 rental_info
 GROUP BY
 rental_info.film_id, rental_info.title, 
rental_info.rental_rate
 ORDER BY
 revenue DESC, title
 LIMIT 10
)
SELECT * FROM detailed_data;
-- Display the detailed table
SELECT * FROM detailed_table;
-- Drop the detailed table (if needed)
-- DROP TABLE detailed_table;
-- SUMMARY TABLE
CREATE TABLE summary_table AS
SELECT
 detailed_table.title,
 detailed_table.revenue
FROM
 detailed_table
ORDER BY
 detailed_table.revenue DESC, detailed_table.title
LIMIT 10;
-- Display the summary table
SELECT * FROM summary_table;
-- Drop the summary table (if needed)
-- DROP TABLE summary_table;
                                                                                                                                                                                                         -- Create rental_info table
CREATE TABLE rental_info AS
SELECT
 rental.rental_id,
 inventory.film_id,
 film.title,
 film.rental_rate
FROM
 rental
INNER JOIN
 inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN
 film ON film.film_id = inventory.film_id
GROUP BY
 rental.rental_id, film.title, film.rental_rate, inventory.film_id
ORDER BY
 rental.rental_id ASC;
-- Display the rental_info table
SELECT * FROM rental_info;
-- Drop the rental_info table (if needed)
-- DROP TABLE rental_info;
                                                                                                                                                                                                       -- Trigger for updating the summary table when data is added 
to the detailed table
CREATE OR REPLACE FUNCTION update_summary_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
 -- Truncate the summary_table to remove existing data
 TRUNCATE TABLE summary_table;
 -- Insert data from detailed_table into summary_table
 INSERT INTO summary_table (title, earnings)
 SELECT
 title,
 earnings
 FROM detailed_table
 ORDER BY earnings DESC, title
 LIMIT 10;
 RETURN NEW;
END;
$$;
-- Create the trigger
CREATE TRIGGER update_summary_trigger
AFTER INSERT ON detailed_table
FOR EACH STATEMENT
EXECUTE FUNCTION update_summary_trigger();
                                                                                                                                                                                                       CREATE OR REPLACE PROCEDURE refresh_tables()
LANGUAGE plpgsql
AS $$
BEGIN
 -- Clear contents of rental_info table
 DELETE FROM rental_info;
 -- Extract raw data for rental_info section
 INSERT INTO rental_info
 SELECT
 rental.rental_id,
 inventory.film_id,
 film.title,
 film.rental_rate
 FROM
 rental
 INNER JOIN
 inventory ON rental.inventory_id = 
inventory.inventory_id
 INNER JOIN
 film ON film.film_id = inventory.film_id
 GROUP BY
 rental.rental_id, film.title, film.rental_rate, 
inventory.film_id
 ORDER BY
 rental.rental_id ASC;
 
 -- Clear contents of detailed table
 DELETE FROM detailed_table;
 -- Extract raw data for detailed section from rental_info
 INSERT INTO detailed_table
 SELECT
 film_id,
 title,
 rental_rate::money,
 COUNT(film_id) AS rented_times,
 (COUNT(film_id) * rental_rate)::money AS earnings
 FROM
 rental_info
 GROUP BY
 film_id, title, rental_rate
 ORDER BY
 earnings DESC, title
 LIMIT 10;
 -- Clear contents of summary table
 DELETE FROM summary_table;
 -- Extract raw data for summary section from detailed_ta 
as test ble
 INSERT INTO summary_table
 SELECT
 title,
 earnings
 FROM
 detailed_table
 ORDER BY
 earnings DESC, title
 LIMIT 10;
END;
$$;
