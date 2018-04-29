USE sakila;

-- 1A 
SELECT first_name, last_name 
FROM actor;
-- 1B
SELECT CONCAT(first_name, ' ' ,last_name) AS Actor_Name FROM actor;
-- 2A
SELECT actor_id,first_name, last_name 
FROM actor 
WHERE first_name = 'Joe';
-- 2B
SELECT * 
FROM actor 
WHERE last_name LIKE '%GEN%';
-- 2C
SELECT * 
FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2D
SELECT country_id, country 
FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh','China');

-- 3A
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(40) AFTER first_name;
SELECT * FROM actor;

-- 3B
ALTER TABLE actor
MODIFY middle_name Blob;

-- 3C
ALTER TABLE actor
DROP COLUMN middle_name;
SELECT * FROM actor;
-- 4A
SELECT last_name, count(last_name) AS 'Count_Last_Name' 
FROM actor 
GROUP BY last_name;
-- 4B
SELECT last_name, count(last_name) AS 'Count_Last_Name' 
FROM actor 
GROUP BY last_name 
HAVING Count_Last_Name >=2;
-- 4C
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name= 'GROUCHO' AND last_name='WILLIAMS';
SELECT first_name FROM actor WHERE first_name= 'HARPO';

-- 4D
UPDATE actor
SET first_name =
CASE
	WHEN first_name= 'HARPO'
		THEN 'GROUCHO' 
	ELSE 'MUCHO GROUCHO'
END
WHERE actor_id=172;


-- 5A
SHOW CREATE TABLE address;

-- 6A
SELECT staff.first_name, staff.last_name, address.address 
FROM staff
INNER JOIN address
ON staff.address_id=address.address_id; 
-- 6B
SELECT s.first_name, s.last_name, a.address 
FROM staff AS s
INNER JOIN address AS a
ON s.address_id=a.address_id; 

-- 6B
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff s
INNER JOIN payment p
ON s.staff_id=p.staff_id
WHERE MONTH(p.payment_date) = 08 AND YEAR(p.payment_date)=2005
GROUP BY s.staff_id;

-- 6c
SELECT film.title, COUNT(actor_id) AS 'Number of ACTORS'
FROM film_actor
INNER JOIN film USING (film_id)
GROUP BY film.title;
-- 6D

SELECT film.title, COUNT(inventory.inventory_id) AS 'Number of Copies'
FROM film
INNER JOIN inventory USING (film_id)
WHERE film.title="Hunchback Impossible"
GROUP BY film.title; 
-- 6E
SELECT customer_id, sum(amount), first_name, last_name
FROM customer
INNER JOIN payment USING (customer_id)
GROUP BY customer_id
ORDER BY last_name;


-- 7A
SELECT * FROM film;
SELECT * FROM language;

SELECT language_id FROM language 
WHERE name = 'English';

SELECT title FROM film
WHERE title like 'K%' 
OR  title like 'Q%'
AND language_id IN 
(    
    SELECT language_id FROM language 
    WHERE name = 'English'
);

-- 7B

SELECT actor_id FROM film_actor
WHERE film_id = 
(
    SELECT film_id FROM film
    WHERE title = 'ALONE TRIP'


);



SELECT first_name, last_name FROM actor
WHERE actor_id IN 
(
    SELECT actor_id FROM film_actor
    WHERE film_id = 
    (
        SELECT film_id FROM film
        WHERE title = 'ALONE TRIP'


    )
);

-- 7C
SELECT first_name, last_name,email FROM customer
INNER JOIN address ON address.address_id=customer.address_id
INNER JOIN city ON city.city_id=address.city_id
INNER JOIN country ON country.country_id=city.country_id
WHERE country.country='Canada';

-- 7D
SELECT title FROM film
INNER JOIN film_category ON film_category.film_id=film.film_id
INNER JOIN category ON category.category_id=film_category.category_id
WHERE category.name = "family";

-- 7E
SELECT COUNT(rental_id) AS 'rentals', title FROM rental
INNER JOIN inventory ON inventory.inventory_id=rental.inventory_id
INNER JOIN film ON film.film_id=inventory.film_id
GROUP BY title
ORDER BY rentals DESC;

-- 7F

SELECT SUM(amount), store_id FROM payment
INNER JOIN staff ON staff.staff_id=payment.staff_id
GROUP BY store_id;

-- 7G

SELECT store.store_id, country.country, city.city FROM store
INNER JOIN address ON address.address_id=store.address_id
INNER JOIN city ON city.city_id=address.city_id
INNER JOIN country ON country.country_id=city.country_id;

-- 7H
SELECT category.name, SUM(payment.amount) FROM category
INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN inventory ON inventory.film_id=film_category.film_id
INNER JOIN rental ON rental.inventory_id=inventory.inventory_id
INNER JOIN payment ON payment.rental_id=rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC LIMIT 5;

-- 8A
CREATE VIEW TopGenres AS 
SELECT category.name, SUM(payment.amount) FROM category
INNER JOIN film_category ON category.category_id=film_category.category_id
INNER JOIN inventory ON inventory.film_id=film_category.film_id
INNER JOIN rental ON rental.inventory_id=inventory.inventory_id
INNER JOIN payment ON payment.rental_id=rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC LIMIT 5;

-- 8B
SELECT * FROM topgenres;

-- 8c

DROP VIEW IF EXISTS topgenres;




