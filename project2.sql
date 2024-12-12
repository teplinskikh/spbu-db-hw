CREATE OR REPLACE FUNCTION validate_order_total(total NUMERIC)
RETURNS BOOLEAN AS $$
BEGIN
    IF total < 0 THEN
        RAISE EXCEPTION 'Сумма заказа не может быть отрицательной';
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validate_supplier_performance(total_supplies BIGINT, total_value NUMERIC)
RETURNS BOOLEAN AS $$
BEGIN
    IF total_supplies < 0 THEN
        RAISE EXCEPTION 'Общее количество поставок не может быть отрицательным';
    ELSIF total_value < 0 THEN
        RAISE EXCEPTION 'Общая стоимость поставок не может быть отрицательной';
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE TEMP TABLE recent_orders_summary (
    temp_order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_surname TEXT NOT NULL,
    total_order_value NUMERIC(10, 2) NOT NULL CHECK (total_order_value >= 0)
);

INSERT INTO recent_orders_summary (customer_id, customer_surname, total_order_value)
SELECT 
    c.customer_id, 
    c.surname, 
    CASE 
        WHEN validate_order_total(SUM(dio.count * dis.price)) THEN SUM(dio.count * dis.price) 
        ELSE 0 
    END AS total_order_value
FROM order_details o
JOIN customer c ON o.customer_id = c.customer_id
JOIN drug_in_order dio ON o.order_id = dio.order_id
JOIN drug_in_stock dis ON dio.drug_in_stock_id = dis.drug_in_stock_id
WHERE o.datetime_purchase >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY c.customer_id, c.surname;

SELECT * 
FROM recent_orders_summary
ORDER BY total_order_value DESC 
LIMIT 10;

SELECT AVG(total_order_value) AS average_order_value
FROM recent_orders_summary;

DROP TABLE recent_orders_summary;

CREATE TEMP TABLE supplier_performance AS
SELECT 
    s.supplier_id,
    s.name AS supplier_name,
    COUNT(sd.supply_id) AS total_supplies,
    CASE 
        WHEN validate_supplier_performance(COUNT(sd.supply_id), SUM(sd.price * sd.count)) THEN SUM(sd.price * sd.count)
        ELSE 0 
    END AS total_supply_value
FROM supplier s
JOIN supply_details sd ON s.supplier_id = sd.supply_id
GROUP BY s.supplier_id, s.name
HAVING COUNT(sd.supply_id) > 2;

SELECT * 
FROM supplier_performance 
ORDER BY total_supply_value DESC 
LIMIT 5;

SELECT supplier_name, total_supplies
FROM supplier_performance
WHERE total_supplies = 3
ORDER BY total_supplies DESC
LIMIT 5;

DROP TABLE supplier_performance;

CREATE VIEW order_customer_details AS
SELECT 
    o.order_id,
    o.receipt_number,
    o.datetime_purchase,
    c.surname AS customer_surname,
    c.name AS customer_name,
    o.total
FROM order_details o
JOIN customer c ON o.customer_id = c.customer_id;

CREATE VIEW stock_details AS
SELECT 
    d.trade_name,
    d.release_form,
    s.count AS stock_count,
    s.price AS stock_price
FROM drug_in_stock s
JOIN drug d ON s.drug_id = d.drug_id;

SELECT * 
FROM order_customer_details 
ORDER BY datetime_purchase DESC 
LIMIT 10;

SELECT * 
FROM stock_details 
WHERE stock_count < 50 
ORDER BY stock_price DESC 
LIMIT 10;

WITH high_value_orders AS (
    SELECT 
        o.order_id,
        o.receipt_number,
        o.datetime_purchase,
        SUM(dio.count * dis.price) AS total_order_value
    FROM order_details o
    JOIN drug_in_order dio ON o.order_id = dio.order_id
    JOIN drug_in_stock dis ON dio.drug_in_stock_id = dis.drug_in_stock_id
    GROUP BY o.order_id, o.receipt_number, o.datetime_purchase
    HAVING SUM(dio.count * dis.price) > 700
)
SELECT * 
FROM high_value_orders
ORDER BY total_order_value DESC
LIMIT 10;

WITH popular_drugs AS (
    SELECT 
        d.drug_id,
        d.trade_name,
        SUM(dio.count) AS total_sold
    FROM drug_in_order dio
    JOIN drug_in_stock dis ON dio.drug_in_stock_id = dis.drug_in_stock_id
    JOIN drug d ON dis.drug_id = d.drug_id
    GROUP BY d.drug_id, d.trade_name
    HAVING SUM(dio.count) > 100
)
SELECT * 
FROM popular_drugs
ORDER BY total_sold DESC
LIMIT 10;

WITH average_order_by_status AS (
    SELECT 
        o.status,
        AVG(o.total) AS average_order_value,
        COUNT(o.order_id) AS total_orders
    FROM order_details o
    GROUP BY o.status
)
SELECT * 
FROM average_order_by_status
ORDER BY average_order_value DESC;