CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    manager_id INT REFERENCES employees(employee_id)
);


INSERT INTO employees (name, position, department, salary, manager_id)
VALUES
    ('Alice Johnson', 'Manager', 'Sales', 85000, NULL),
    ('Bob Smith', 'Sales Associate', 'Sales', 50000, 1),
    ('Carol Lee', 'Sales Associate', 'Sales', 48000, 1),
    ('David Brown', 'Sales Intern', 'Sales', 30000, 2),
    ('Eve Davis', 'Developer', 'IT', 75000, NULL),
    ('Frank Miller', 'Intern', 'IT', 35000, 5);


CREATE TABLE IF NOT EXISTS sales(
    sale_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    sale_date DATE NOT NULL
);

INSERT INTO sales (employee_id, product_id, quantity, sale_date)
VALUES
    (2, 1, 20, '2024-10-15'),
    (2, 2, 15, '2024-10-16'),
    (3, 1, 10, '2024-10-17'),
    (3, 3, 5, '2024-11-06'),
    (4, 2, 13, '2024-11-07'),
    (2, 4, 11, '2024-11-11'),
	(2, 7, 22, '2024-11-11'),
	(2, 10, 7, '2024-11-12'),
	(2, 8, 17, '2024-11-13');


CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

INSERT INTO products (name, price)
VALUES
    ('Product A', 150.00),
    ('Product B', 200.00),
    ('Product C', 100.00),
	('Product D', 250.00),
	('Product E', 230.00),
	('Product F', 310.00),
	('Product G', 500.00),
	('Product H', 780.00),
	('Product I', 390.00),
	('Product J', 440.00);
	

CREATE TEMP TABLE high_sales_products AS
SELECT product_id, SUM(quantity) AS total_quantity
FROM sales
WHERE sale_date >= CURRENT_DATE - 7
GROUP BY product_id
HAVING SUM(quantity) > 10;

SELECT * FROM high_sales_products LIMIT 5;

DROP TABLE high_sales_products;


WITH employee_sales_stats AS (
	SELECT employee_id, COUNT(*) AS total_sales, ROUND(AVG(quantity), 2) AS avg_sales
	FROM sales
	WHERE date_part('month', sale_date) = date_part('month', CURRENT_DATE)
	GROUP BY employee_id
),
company_avg AS (
SELECT ROUND(AVG(total_sales), 2) AS company_avg_sales
FROM employee_sales_stats
)
SELECT e.employee_id, e.avg_sales 
FROM employee_sales_stats e
JOIN company_avg c ON e.total_sales > c.company_avg_sales LIMIT 5;


WITH employee_hierarchy AS (
	SELECT COALESCE(m.name, 'Нет менеджера') AS manager, e.name
	FROM employees e
	LEFT JOIN employees m ON e.manager_id = m.employee_id
)
SELECT *
FROM employee_hierarchy LIMIT 10;


WITH monthly_sales AS (
	SELECT product_id, SUM(quantity) AS total_sales, TO_CHAR(DATE_TRUNC('month', sale_date), 'FMMonth') AS month
	FROM sales
	WHERE sale_date >= DATE_TRUNC('month', CURRENT_DATE - '1 month'::INTERVAL)
	AND sale_date < DATE_TRUNC('month', CURRENT_DATE) + '1 month'::INTERVAL
	GROUP BY product_id, DATE_TRUNC('month', sale_date)
)
SELECT ms.product_id, ms.total_sales, ms.month
FROM monthly_sales ms
WHERE ms.total_sales IN (
	SELECT DISTINCT total_sales
	FROM monthly_sales
	WHERE month = ms.month
	ORDER BY total_sales DESC
	LIMIT 3
	)
ORDER BY ms.month, total_sales DESC;


CREATE INDEX idx_employee_sale_date ON sales(employee_id, sale_date);

EXPLAIN ANALYZE
SELECT * FROM sales WHERE employee_id = 2 AND sale_date BETWEEN '2024-11-01' AND '2024-11-30' LIMIT 5;

EXPLAIN ANALYZE
SELECT product_id, SUM(quantity) AS total_sales
FROM sales
GROUP BY product_id LIMIT 10;

