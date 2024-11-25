CREATE OR REPLACE FUNCTION before_insert_employee()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.salary > 100000 THEN
		RAISE EXCEPTION 'Зарплата сотрудника % превышает допустимый лимит!', NEW.name;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_before_insert_employee
BEFORE INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION before_insert_employee();


CREATE OR REPLACE FUNCTION after_update_sales()
RETURNS TRIGGER AS $$
BEGIN
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_after_update_sales
AFTER UPDATE ON sales
FOR EACH ROW
EXECUTE FUNCTION after_update_sales();


CREATE VIEW high_salary_employees AS
SELECT * FROM employees WHERE salary > 75000;

CREATE OR REPLACE FUNCTION instead_of_insert_high_salary()
RETURNS TRIGGER AS $$
BEGIN
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_instead_of_high_salary
INSTEAD OF INSERT ON high_salary_employees
FOR EACH ROW
EXECUTE FUNCTION instead_of_insert_high_salary();


CREATE OR REPLACE FUNCTION after_delete_employee()
RETURNS TRIGGER AS $$
BEGIN
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_after_delete_employee
AFTER DELETE ON employees
FOR EACH ROW
EXECUTE FUNCTION after_delete_employee();


CREATE OR REPLACE FUNCTION log_high_sales()
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.quantity > 20 THEN
		RAISE NOTICE 'Продано более 20 единиц товара: sale_id = %, quantity = %', NEW.sale_id, NEW.quantity;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_high_sales
AFTER INSERT ON sales
FOR EACH ROW
EXECUTE FUNCTION log_high_sales();


CREATE OR REPLACE FUNCTION log_price_update()
RETURNS TRIGGER AS $$
BEGIN
	RAISE NOTICE 'Цена товара обновлена: product_id = %, старая цена = %, новая цена = %',
	NEW.product_id, OLD.price, NEW.price;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_price_update
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_price_update();


BEGIN;
INSERT INTO sales (employee_id, product_id, quantity, sale_date)
VALUES (2, 1, 10, '2024-11-01');
UPDATE sales SET quantity = 15 WHERE sale_id = 1;
COMMIT;


BEGIN;
INSERT INTO employees (name, position, department, salary, manager_id)
VALUES ('John Doe', 'Developer', 'IT', 120000, NULL);
ROLLBACK;
-- Транзакция падает из-за исключения, сгенерированного триггером before_insert_employee
