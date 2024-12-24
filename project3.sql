CREATE TABLE IF NOT EXISTS audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    operation TEXT NOT NULL,
    details TEXT NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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

CREATE OR REPLACE FUNCTION validate_order_total()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.total < 0 THEN
        RAISE EXCEPTION 'Сумма заказа не может быть отрицательной!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_stock_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, details)
    VALUES (
        'drug_in_stock',
        'UPDATE',
        format('Изменение остатка товара ID=%s, новое количество=%s', NEW.drug_id, NEW.count)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION prevent_supplier_deletion()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Удаление активного поставщика запрещено!';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_supplier_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, details)
    VALUES (
        'supplier',
        TG_OP,
        format('Операция=%s, ID поставщика=%s', TG_OP, OLD.supplier_id)
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION instead_of_delete_order_view()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Удаление данных из представления запрещено!';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validate_stock_count()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.count < 0 THEN
        RAISE EXCEPTION 'Остаток на складе не может быть отрицательным!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_before_insert_order_total
BEFORE INSERT ON order_details
FOR EACH ROW
EXECUTE FUNCTION validate_order_total();

CREATE TRIGGER trigger_after_update_drug_stock
AFTER UPDATE ON drug_in_stock
FOR EACH ROW
EXECUTE FUNCTION log_stock_update();

CREATE TRIGGER trigger_before_delete_supplier
BEFORE DELETE ON supplier
FOR EACH ROW
EXECUTE FUNCTION prevent_supplier_deletion();

CREATE TRIGGER trigger_after_delete_supplier
AFTER DELETE ON supplier
FOR EACH ROW
EXECUTE FUNCTION log_supplier_changes();

CREATE TRIGGER trigger_instead_of_delete_order_view
INSTEAD OF DELETE ON order_customer_details
FOR EACH ROW
EXECUTE FUNCTION instead_of_delete_order_view();

CREATE TRIGGER trigger_before_update_stock_count
BEFORE UPDATE ON drug_in_stock
FOR EACH ROW
EXECUTE FUNCTION validate_stock_count();

CREATE OR REPLACE FUNCTION log_order_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, details)
    VALUES (
        'order_details',
        'INSERT',
        format('Добавлен заказ с номером %s, общей суммой=%s', NEW.receipt_number, NEW.total)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_after_insert_order_log
AFTER INSERT ON order_details
FOR EACH ROW
EXECUTE FUNCTION log_order_insert();

CREATE OR REPLACE FUNCTION log_before_update_supplier()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Началось обновление данных о поставщике на уровне STATEMENT.';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_before_update_supplier_statement
BEFORE UPDATE ON supplier
FOR EACH STATEMENT
EXECUTE FUNCTION log_before_update_supplier();

BEGIN;
INSERT INTO order_details (receipt_number, datetime_purchase, customer_id, employee_id, status, total)
VALUES ('RCPT-55', CURRENT_TIMESTAMP, 2, 3, 'completed', 800.00);
COMMIT;

-- Ошибка из-за отрицательной суммы заказа
BEGIN;
DO $$
BEGIN
    INSERT INTO order_details (receipt_number, datetime_purchase, customer_id, employee_id, status, total)
    VALUES ('RCPT-53', CURRENT_TIMESTAMP, 3, 4, 'completed', -500.00);
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Триггер validate_order_total сработал успешно.';
END;
$$;
ROLLBACK;

BEGIN;
UPDATE drug_in_stock
SET count = 20
WHERE drug_id = 1;
COMMIT;

BEGIN;
DO $$
BEGIN
    DELETE FROM supplier WHERE supplier_id = 1;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Триггер prevent_supplier_deletion сработал успешно.';
END;
$$;
ROLLBACK;

BEGIN;
DELETE FROM supplier WHERE supplier_id = 2;
COMMIT;

BEGIN;
DO $$
BEGIN
    DELETE FROM order_customer_details WHERE order_id = 1;
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Триггер trigger_instead_of_delete_order_view сработал успешно.';
END;
$$;
ROLLBACK;

CREATE INDEX idx_order_total_date ON order_details(total, datetime_purchase);
CREATE INDEX idx_supplier_name ON supplier(name);
CREATE INDEX idx_stock_count ON drug_in_stock(count);

EXPLAIN ANALYZE
SELECT * 
FROM order_details 
WHERE total > 500;

EXPLAIN ANALYZE
SELECT * 
FROM supplier 
WHERE name LIKE '%Pharma%';

EXPLAIN ANALYZE
SELECT * 
FROM drug_in_stock 
WHERE count < 50;