/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
SELECT
	ST.store_id AS "Store ID",
	SF.first_name AS "Manager First Name", 
    SF.last_name AS "Manager Last Name",
    A.address AS "Address", 
    A.district AS "District", 
    CT.city AS "City", 
    CY.country AS "Country"
FROM
	store AS ST
LEFT JOIN
	staff AS SF ON ST.manager_staff_id = SF.staff_id
LEFT JOIN
	address A ON ST.address_id = A.address_id
LEFT JOIN
	city CT ON A.city_id = CT.city_id
LEFT JOIN
	country AS CY ON CT.country_id = CY.country_id
ORDER BY
	SF.last_name ASC;

/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
SELECT 
	I.inventory_id AS "Inventory ID", 
    I.store_id AS "Store ID",
    F.title AS "Title", 
    F.rating AS "Rating", 
    F.rental_rate AS "Rental Rate", 
    F.replacement_cost AS "Replacement Cost"
FROM
	inventory AS I
LEFT JOIN
	film AS F ON I.film_id = F.film_id
ORDER BY
	I.inventory_id ASC;

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT 
	I.store_id AS "Store ID", 
    F.rating AS "Rating", 
    COUNT(inventory_id) AS "Total in Stock"
FROM
	inventory AS I
LEFT JOIN
	film AS F ON I.film_id = F.film_id
GROUP BY 
	I.store_id,
    F.rating;

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
SELECT 
	store_id AS "Store ID", 
    C.name AS "Category", 
	COUNT(I.inventory_id) AS "Amount of Films", 
    AVG(F.replacement_cost) AS "Average Replacement Cost", 
    SUM(F.replacement_cost) AS "Total Replacement Cost"
FROM
	inventory AS I
LEFT JOIN
	film AS F ON I.film_id = F.film_id
LEFT JOIN 
	film_category AS FC ON F.film_id = FC.film_id
LEFT JOIN 
	category AS C ON C.category_id = FC.category_id
GROUP BY 
	store_id, 
    C.name
ORDER BY 
	store_id ASC, C.name ASC;

/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
SELECT 
	C.first_name AS "First Name", 
    C.last_name AS "Last name", 
    C.store_id AS "Store ID",
    CASE
		WHEN C.active = 1 THEN "Active"
		WHEN C.active = 0 THEN "Inactive"
        ELSE "No status"
	END AS "Active", 
    A.address AS "Address", 
    CT.city AS "City", 
    CY.country AS "Country"
FROM
	customer AS C
LEFT JOIN
	address AS A ON C.address_id = A.address_id
LEFT JOIN
	city AS CT ON A.city_id = CT.city_id
LEFT JOIN
	country AS CY ON CT.country_id = CY.country_id
ORDER BY
	C.last_name ASC;

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
SELECT 
	C.first_name AS "First Name", 
    C.last_name AS "Last Name", 
    COUNT(R.rental_id) AS "Total Rentals", 
    SUM(P.amount) AS "Total Spend"
FROM
	customer AS C
LEFT JOIN
	rental AS R ON C.customer_id = R.customer_id
LEFT JOIN
	payment AS P ON R.rental_id = P.rental_id
GROUP BY 
	C.first_name,
    C.last_name
ORDER BY 
	SUM(P.amount) DESC;
    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
SELECT
	'Advisor' AS "Type", 
    first_name AS "First Name", 
    last_name AS "Last Name", 
    company_name AS "Company Name"
FROM
	investor
UNION SELECT 
	'Investor' AS "Type", 
    first_name AS "First Name", 
    last_name AS "Last Name", 
    NULL
FROM
	advisor;
