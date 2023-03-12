-- Get a list of all customers, as well as their email address
SELECT
	first_name AS "First Name",
    last_name AS "Last Name",
    email AS "Email"
FROM
	customer
ORDER BY
	last_name ASC;
    
-- Get a list of all the different film rental durations types
SELECT DISTINCT
	rental_duration AS "Rental Duration Days"
FROM
	film
ORDER BY
	rental_duration ASC;

-- Get payment records from long term customers (first 100)
SELECT
	*
FROM
	payment
WHERE
	customer_id <= 100
ORDER BY
	payment_id ASC;
    
-- Get payment records from long term customers (first 100) after 1 January 2006 which were more than $5
SELECT
	*
FROM
	payment
WHERE
	customer_id <= 100
AND
	payment_date >= '2006-01-01'
AND
	amount > 5.00
ORDER BY
	payment_id ASC;
    
-- Get payment records from customers 42,53,60,75 which were more than $5
SELECT
	*
FROM
	payment
WHERE
	customer_id IN (42,53,60,75)
AND
	amount > 5
ORDER BY
	payment_id ASC;
    
-- Get a list of all films containing behind the scenes features
SELECT
	film_id AS "Film ID",
    title AS "Film Title",
    special_features AS "Special Features"
FROM
	film
WHERE
	special_features LIKE '%Behind the Scenes%'
ORDER BY
	film_id ASC;
    
-- Show amount of movies each rental duration category has    
SELECT
	rental_duration AS "Rental Duration Days",
    COUNT(film_id) AS "Amount of Films"
FROM
	film
GROUP BY
	rental_duration
ORDER BY
	rental_duration ASC;
    
-- See if rental charge is higher if replacement value is higher
SELECT
	replacement_cost AS "Replacement Cost",
    COUNT(film_id) AS "Amount of Films",
    MIN(rental_rate) AS "Least Expensive",
    AVG(rental_rate) AS "Average Cost",
    MAX(rental_rate) AS "Most Expensive"
FROM
	film
GROUP BY
	replacement_cost
ORDER BY
	replacement_cost ASC;

-- Get a list of customer ID's who have less than 15 total rentals
SELECT
	customer_id AS "Customer ID",
    COUNT(rental_id) AS "Amount of Rentals"
FROM
	rental
GROUP BY
	customer_id
HAVING
	COUNT(rental_id) < 15
ORDER BY
	customer_id ASC;

-- See if the longer a film, the more expensive it is to rent
SELECT
	title AS "Movie Title",
    length AS "Duration",
    rental_rate AS "Rental Rate"
FROM
	film
ORDER BY
	length DESC, title ASC;

-- Show all customers and the stores they visit, and whether they are active or not
SELECT
	first_name AS "First Name",
    last_name AS "Last Name",
    CASE
		WHEN store_id = 1 AND active = 0 THEN "Store 1 / Inactive"
        WHEN store_id = 1 AND active = 1 THEN "Store 1 / Active"
		WHEN store_id = 2 AND active = 0 THEN "Store 2 / Inactive"
		WHEN store_id = 2 AND active = 1 THEN "Store 2 / Active"
        ELSE "N/A"
	END AS "Store / Status"
FROM
	customer
ORDER BY
	last_name ASC;

-- Show how many copies of a film each store has
SELECT
	film_id AS "Film ID",
    COUNT(CASE WHEN store_id = 1 THEN inventory_id END) AS "Store 1 Amount",
    COUNT(CASE WHEN store_id = 2 then inventory_id END) AS "Store 2 Amount",
    COUNT(inventory_id) AS "Total Amount of Copies"
FROM
	inventory
GROUP BY
	film_id
ORDER BY
	film_id ASC;

-- Show how many active and inactive customers each store has
SELECT
	store_id AS "Store ID",
    COUNT(CASE WHEN active = 1 THEN customer_id END) AS "Active",
    COUNT(CASE WHEN active = 0 THEN customer_id END) AS "Inactive"
FROM
	customer
GROUP BY
	store_id
ORDER BY
	store_id ASC;

-- List all the films in inventory
SELECT
	I.inventory_id AS "Inventory ID",
    I.store_id AS "Store ID",
    F.title AS "Title",
    F.description AS "Description"
FROM
	inventory AS I
INNER JOIN
	film AS F ON I.film_id = F.film_id
ORDER BY
	I.inventory_id ASC;

-- Show in how many films each actor played
SELECT
	A.first_name,
    A.last_name,
    COUNT(FA.film_id) AS "Number of Films"
FROM
	actor AS A
LEFT JOIN
	film_actor AS FA ON A.actor_id = FA.actor_id
GROUP BY
    A.first_name,
    A.last_name
ORDER BY
	A.last_name ASC;
    
-- How many actors are listed for each film title
SELECT
	F.title,
    COUNT(FA.actor_id) AS "Number of Actors"
FROM
	film AS F
LEFT JOIN
	film_actor AS FA ON F.film_id = FA.film_id
GROUP BY
	F.title
ORDER BY
    F.title ASC;
    
-- Show which category each movie belongs to
SELECT
	F.film_id AS "Film ID",
    F.title AS "Title",
	C.name AS "Category"
FROM
	film AS F
INNER JOIN
	film_category AS FC ON F.film_id = FC.film_id
INNER JOIN
	category AS C ON FC.category_id = C.category_id
ORDER BY
	F.film_id ASC;

-- Show all the films each actor appears in
SELECT
	A.first_name AS "Actor First Name",
    A.last_name AS "Actor Last Name",
    F.title AS "Film Title"
FROM
	actor AS A
INNER JOIN
	film_actor AS FA ON A.actor_id = FA.actor_id
INNER JOIN
	film AS F ON FA.film_id = F.film_id
ORDER BY
	A.last_name ASC, A.first_name ASC, F.title ASC;

-- Get the list(title/description) of movies at store 2
SELECT DISTINCT
	F.title AS "Title",
    F.description AS "Description",
    I.store_id AS "Store ID"
FROM
	film AS F
INNER JOIN
	inventory AS I ON F.film_id = I.film_id
AND
	I.store_id = 2
ORDER BY
	F.title ASC;

-- Get a list of all staff and advisors
SELECT
	"Staff" AS "Type",
    first_name AS "First Name",
    last_name AS "Last Name"
FROM
staff
UNION SELECT
	"Advisor" AS "Type",
    first_name AS "First Name",
    last_name AS "Last Name"
FROM
	advisor;