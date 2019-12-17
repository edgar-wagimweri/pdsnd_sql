1. WHAT ARE THE 10 WORST PERFORMING CITIES IN TERMS OF RENTAL AMOUNTS?

WITH city_Rentals AS (
    	SELECT cS.customer_id,
        cs.address_id, cT.city AS city_name,
        COUNT(*) AS movies_Rented
			FROM rental rT
			JOIN customer cS
				ON rT.customer_id = cS.customer_id
				JOIN address
				ON address.address_id = cS.address_id
				JOIN city cT
				ON cT.city_id = address.city_id
			GROUP BY 1, 2, 3
			ORDER BY 4 ASC
		)

SELECT city_name, movies_Rented,
	CASE	WHEN movies_rented < 20 THEN 'underperforming'
			WHEN movies_rented BETWEEN 20 AND 30 THEN 'Above Average'
			ELSE 'Excellent' END AS performance_by_city
FROM city_Rentals
GROUP BY 1,2
ORDER BY 2 ASC
LIMIT 10;


2. WHAT IS THE DISTRIBUTION OF THE NUMBER OF MOVIE ACTORS BY FILM CATEGORIES?

SELECT
  movie_Category,
  Genre,
  COUNT(per_category)
FROM (SELECT
  fA.actor_id,
  fC.category_id AS movie_Category,
  cN.name AS Genre,
  COUNT(fC.category_id) AS per_Category
FROM film_actor fA
JOIN film_category fC
  ON fC.film_id = fA.film_id
JOIN category cN
  ON cN.category_id = fC.category_id
GROUP BY 1,
         2,
         3
ORDER BY 1 ASC) sub2
GROUP BY 1,
         2
ORDER BY 1
;


3. WHAT ARE THE MOST POPULAR MOVIE GENRES  FOR MATURE AUDIENCES?

SELECT
  category_name,
  SUM(rental_count)
FROM (SELECT DISTINCT
  (f.title) film_title,
  ct.name category_name,
  COUNT(r.rental_date) OVER (PARTITION BY f.title ORDER BY f.title) AS rental_count
FROM film f
JOIN film_category fc
  ON f.film_id = fc.film_id
JOIN category ct
  ON fc.category_id = ct.category_id
JOIN inventory i
  ON f.film_id = i.film_id
JOIN rental r
  ON i.inventory_id = r.inventory_id
WHERE ct.name = 'Action'
OR ct.name = 'Horror'
OR ct.name = 'Classics'
OR ct.name = 'Sci-Fi'
ORDER BY ct.name, f.title) subQ
GROUP BY 1;

4.WHAT IS THE DISTRIBUTION OF MOVIES ACCORDING TO PG RATING?

//*CTE to return rented movies and their ratings */
WITH movie_rating
AS (SELECT
    r.rental_id AS rents,
    f.rating AS rating_guide
    FROM rental r
    INNER JOIN inventory i
    ON i.film_id = r.inventory_id
    INNER JOIN film f
    ON f.film_id = i.film_id)

/*Query that returns the total number of films per rating grade */
SELECT
  rating_guide AS Rating,
  COUNT(rents) AS total_number_of_movies
FROM movie_rating
GROUP BY 1
ORDER BY 2 DESC;
