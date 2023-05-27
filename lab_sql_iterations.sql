USE sakila;

# Write a query to find what is the total business done by each store.

SELECT s.store_id, SUM(p.amount)
FROM payment p 
JOIN rental r ON p.rental_id = r.rental_id
JOIN staff s ON r.staff_id = s.staff_id
GROUP BY s.store_id;

# Convert the previous query into a stored procedure.

DELIMITER //
CREATE PROCEDURE total_sales()
BEGIN
	SELECT s.store_id, SUM(p.amount)
	FROM payment p 
	JOIN rental r ON p.rental_id = r.rental_id
	JOIN staff s ON r.staff_id = s.staff_id
	GROUP BY s.store_id;
END //
DELIMITER ;

CALL total_sales();

# Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //
CREATE PROCEDURE total_sales_store(IN param INT)
BEGIN
	SELECT s.store_id, SUM(p.amount)
	FROM payment p 
	JOIN rental r ON p.rental_id = r.rental_id
	JOIN staff s ON r.staff_id = s.staff_id
	WHERE s.store_id = param
	GROUP BY s.store_id;
END //
DELIMITER ;

CALL total_sales_store(1);

# Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

DROP PROCEDURE IF EXISTS total_sales_store;

DELIMITER //
CREATE PROCEDURE total_sales_store(IN param INT, OUT total_sales_value FLOAT)
BEGIN
    SELECT SUM(p.amount) INTO total_sales_value
    FROM payment p 
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN staff s ON r.staff_id = s.staff_id
    WHERE s.store_id = param;
END //
DELIMITER ;

CALL total_sales_store(1, @total_sales_value);

SELECT @total_sales_value;

# In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
# Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DROP PROCEDURE IF EXISTS total_sales_store;

DELIMITER //
CREATE PROCEDURE total_sales_store(IN param INT, OUT total_sales_value FLOAT, OUT flag VARCHAR(10))
BEGIN
    SELECT SUM(p.amount), 
           CASE WHEN SUM(p.amount) > 30000 THEN 'green_flag' ELSE 'red_flag' END
    INTO total_sales_value, flag
    FROM payment p 
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN staff s ON r.staff_id = s.staff_id
    WHERE s.store_id = param;
END //
DELIMITER ;

CALL total_sales_store(1, @total_sales_value, @flag);

SELECT @total_sales_value, @flag;


