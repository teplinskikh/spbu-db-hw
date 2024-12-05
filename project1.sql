CREATE TABLE IF NOT EXISTS customer(
	customer_id SERIAL PRIMARY KEY NOT NULL,
	surname TEXT NOT NULL,
	name TEXT NOT NULL,
	patronymic TEXT,
	phone TEXT NOT NULL UNIQUE CHECK (char_length(phone) = 12)
);

INSERT INTO customer (surname, name, patronymic, phone) 
VALUES
	('Теплинских', 'Софья', 'Сергеевна', '+79071117733'),
	('Таратонов', 'Павел', 'Михайлович', '+79102221456'),
	('Козлитин', 'Артем', 'Павлович', '+79003330553'),
	('Назарьева', 'Елизавета', 'Владимировна', '+79045152887'),
	('Шабанов', 'Антон', 'Валерьевич', '+79003304030'),
	('Тимофеенко', 'Сергей', 'Витальевич', '+79053214169'),
	('Макаров', 'Никита', 'Олегович', '+79287569231'),
	('Буркова', 'Арина', 'Павловна', '+79341782015'),
	('Варфоломеев', 'Александр', 'Олегович', '+79001234567'),
	('Будиловский', 'Андрей', 'Анатольевич', '+79571264577'),
	('Агафонов', 'Олег', 'Игоревич', '+79088085146'),
	('Коток', 'Игорь', 'Дмитриевич', '+79521456320'),
	('Клишин', 'Никита', 'Александрович', '+79571264517'),
	('Поволяев', 'Андрей', 'Михайлович', '+79571264120'),
	('Антониади', 'Никита', 'Антонович', '+79571231401'),
	('Катышева', 'Ксения', 'Валерьевна', '+79571011101'),
	('Левченко', 'Софья', 'Антоновна', '+79571010101'),
	('Мурашкина', 'Мария', 'Александровна', '+79531015055'),
	('Рудяков', 'Роман', 'Васильевич', '+79545421331'),
	('Хромых', 'Ангелина', 'Андреевна', '+79405102364'),
	('Каргашина', 'Дина', 'Дмитриевна', '+79588889889'),
	('Михайлов', 'Дмитрий', 'Андреевич', '+79571266666');

CREATE TABLE IF NOT EXISTS employee(
	employee_id SERIAL PRIMARY KEY NOT NULL,
	salary NUMERIC(10,2) NOT NULL DEFAULT 0,
	date_entry DATE NOT NULL,
	date_dismissal DATE,
	surname TEXT NOT NULL,
	name TEXT NOT NULL,
	patronymic TEXT,
	passport TEXT NOT NULL UNIQUE,
	phone TEXT NOT NULL UNIQUE CHECK (char_length(phone) = 12),
	experience INT NOT NULL CHECK (experience >= 0),
	is_admin BOOL DEFAULT FALSE
);

INSERT INTO employee (surname, name, patronymic, salary, date_entry, passport, phone, experience, is_admin) 
VALUES
	('Медведев', 'Сергей', 'Николаевич', 70000, '2021-01-10', '1234567890', '+79004005060', 5, TRUE),
	('Болотова', 'Светлана', 'Юрьевна', 50000, '2023-03-01', '0987654321', '+79005556677', 2, FALSE),
	('Канзеба', 'Александра', 'Олеговна', 30000, '2024-02-21', '1237777890', '+79004003015', 1, FALSE),
	('Шашкин', 'Александр', 'Иванович', 75000, '2015-02-02', '1238997890', '+79004011474', 9, TRUE),
	('Медведева', 'Ольга', 'Александровна', 40000, '2022-12-03', '1234567132', '+79004077757', 4, FALSE),
	('Трофименко', 'Елена', 'Владимировна', 30000, '2019-07-12', '1014567890', '+79004082354', 7, FALSE),
	('Чернышов', 'Максим', 'Корнельевич', 50000, '2020-05-10', '5054567890', '+79004096569', 5, FALSE);

CREATE TABLE IF NOT EXISTS drug(
	drug_id SERIAL PRIMARY KEY NOT NULL,
	trade_name TEXT NOT NULL,
	chemical_name TEXT,
	release_form TEXT,
	registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
	country TEXT
);

INSERT INTO drug (trade_name, chemical_name, release_form, registration_date, country) 
VALUES
    ('Анальгин', 'Метамизол натрия', 'Таблетки', '2023-01-01', 'Россия'),
    ('Нурофен', 'Ибупрофен', 'Сироп', '2023-01-02', 'Россия'),
    ('Парацетамол', 'Парацетамол', 'Капсулы', '2023-01-03', 'Россия'),
    ('Аспирин', 'Ацетилсалициловая кислота', 'Таблетки', '2023-01-04', 'Германия'),
    ('Цитрамон', 'Кофеин + парацетамол + аспирин', 'Таблетки', '2023-01-05', 'Россия'),
    ('Кетанов', 'Кеторолак', 'Таблетки', '2023-01-06', 'Индия'),
    ('Мезим', 'Панкреатин', 'Таблетки', '2023-01-07', 'Германия'),
    ('Эспумизан', 'Симетикон', 'Капсулы', '2023-01-08', 'Германия'),
    ('Фестал', 'Панкреатин + желчные кислоты', 'Таблетки', '2023-01-09', 'Франция'),
    ('Дротаверин', 'Дротаверин', 'Таблетки', '2023-01-10', 'Россия'),
    ('Но-шпа', 'Дротаверин', 'Таблетки', '2023-01-11', 'Венгрия'),
    ('Ибупрофен', 'Ибупрофен', 'Капсулы', '2023-01-12', 'США'),
    ('Омез', 'Омепразол', 'Капсулы', '2023-01-13', 'Индия'),
    ('Ренни', 'Кальция карбонат + магния карбонат', 'Таблетки', '2023-01-14', 'Великобритания'),
    ('Алмагель', 'Алгелдрат + магния гидроксид', 'Суспензия', '2023-01-15', 'Болгария'),
    ('Лоперамид', 'Лоперамид', 'Капсулы', '2023-01-16', 'Россия'),
    ('Имодиум', 'Лоперамид', 'Капсулы', '2023-01-17', 'Бельгия'),
    ('Дюфалак', 'Лактулоза', 'Сироп', '2023-01-18', 'Нидерланды'),
    ('Лактофильтрум', 'Лигнин + лактулоза', 'Таблетки', '2023-01-19', 'Россия'),
    ('Энтерол', 'Сахаромицеты буларди', 'Капсулы', '2023-01-20', 'Франция'),
    ('Смекта', 'Диоктаэдрический смектит', 'Порошок', '2023-01-21', 'Франция'),
    ('Активированный уголь', 'Активированный уголь', 'Таблетки', '2023-01-22', 'Россия'),
    ('Карсил', 'Силимарин', 'Таблетки', '2023-01-23', 'Болгария'),
    ('Эссенциале Форте', 'Фосфолипиды', 'Капсулы', '2023-01-24', 'Германия'),
    ('Гептрал', 'Адеметионин', 'Таблетки', '2023-01-25', 'Италия'),
    ('Креон', 'Панкреатин', 'Капсулы', '2023-01-26', 'Германия'),
    ('Панкреатин', 'Панкреатин', 'Таблетки', '2023-01-27', 'Россия'),
    ('Никошпан', 'Никотиновая кислота + дротаверин', 'Таблетки', '2023-01-28', 'Венгрия'),
    ('Эреспал', 'Фенспирид', 'Сироп', '2023-01-29', 'Франция'),
    ('Амброксол', 'Амброксол', 'Сироп', '2023-01-30', 'Россия'),
    ('Лазолван', 'Амброксол', 'Сироп', '2023-01-31', 'Германия'),
    ('Беродуал', 'Ипратропия бромид + фенотерол', 'Спрей', '2023-02-01', 'Германия'),
    ('Сальбутамол', 'Сальбутамол', 'Спрей', '2023-02-02', 'Индия'),
    ('Пульмикорт', 'Будесонид', 'Суспензия', '2023-02-03', 'Швеция'),
    ('Називин', 'Оксиметазолин', 'Капли', '2023-02-04', 'Германия'),
    ('Ринонорм', 'Ксилометазолин', 'Спрей', '2023-02-05', 'Россия'),
    ('Санорин', 'Нафазолин', 'Капли', '2023-02-06', 'Чехия'),
    ('Тизин', 'Тетрагидрозолин', 'Спрей', '2023-02-07', 'Франция'),
    ('Виброцил', 'Фенилэфрин + диметинден', 'Капли', '2023-02-08', 'Швейцария'),
    ('Аквамарис', 'Морская вода', 'Спрей', '2023-02-09', 'Хорватия'),
    ('Фурацилин', 'Нитрофурал', 'Таблетки', '2023-02-10', 'Россия'),
    ('Мирамистин', 'Мирамистин', 'Раствор', '2023-02-11', 'Россия'),
    ('Хлоргексидин', 'Хлоргексидин', 'Раствор', '2023-02-12', 'Россия'),
    ('Зеленка', 'Бриллиантовый зеленый', 'Раствор', '2023-02-13', 'Россия'),
    ('Йод', 'Йод', 'Раствор', '2023-02-14', 'Россия'),
    ('Перекись водорода', 'Перекись водорода', 'Раствор', '2023-02-15', 'Россия'),
    ('Бепантен', 'Декспантенол', 'Мазь', '2023-02-16', 'Германия'),
    ('Пантенол', 'Декспантенол', 'Спрей', '2023-02-17', 'Россия'),
    ('Цинковая мазь', 'Цинка оксид', 'Мазь', '2023-02-18', 'Россия'),
    ('Фенистил', 'Диметинден', 'Гель', '2023-02-19', 'Швейцария'),
    ('Левомеколь', 'Хлорамфеникол + метилурацил', 'Мазь', '2023-02-20', 'Россия'),
    ('Актовегин', 'Депротеинизированный гемодериват', 'Гель', '2023-02-21', 'Германия'),
    ('Солкосерил', 'Гемодериват телячьей крови', 'Мазь', '2023-02-22', 'Швейцария'),
    ('Метилурациловая мазь', 'Метилурацил', 'Мазь', '2023-02-23', 'Россия'),
	('Эутирокс', 'Тироксин', 'Таблетки', '2023-02-28', 'Россия');

CREATE TABLE IF NOT EXISTS supplier(
	supplier_id SERIAL PRIMARY KEY NOT NULL,
	name TEXT NOT NULL,
	contact TEXT NOT NULL CHECK (char_length(contact) = 12),
	address TEXT NOT NULL
);

INSERT INTO supplier (name, contact, address) 
VALUES
	('PharmaCorp', '+79001113334', 'Moscow, Tverskaya 10'),
	('MediSupply', '+79002221314', 'Saint Petersburg, Nevsky 50'),
	('HealthLine', '+79003354455', 'Novosibirsk, Krasny Prospekt 45'),
    ('MedTech', '+79004445566', 'Ekaterinburg, Lenin Street 10'),
    ('BioPharm', '+79001185521', 'Kazan, Bauman Street 15'),
    ('GlobalMed', '+79031514289', 'Sochi, Kurortny Avenue 20'),
    ('EcoPharma', '+79007778899', 'Rostov-on-Don, Voroshilovsky Avenue 25'),
    ('VitalPlus', '+79008889900', 'Vladivostok, Svetlanskaya Street 5'),
    ('SafeMeds', '+79009990011', 'Krasnodar, Red Street 30'),
    ('ProHealth', '+79001111077', 'Samara, Kuybyshev Street 40');

CREATE TABLE IF NOT EXISTS supply(
	supply_id SERIAL PRIMARY KEY NOT NULL,
	supply_date DATE NOT NULL DEFAULT CURRENT_DATE,
	supplier_id INT NOT NULL,
	employee_id INT NOT NULL,
	CONSTRAINT supply_supplier_fk FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id) ON DELETE CASCADE,
	CONSTRAINT supply_employee_fk FOREIGN KEY (employee_id) REFERENCES employee (employee_id) ON DELETE SET NULL
);

INSERT INTO supply (supply_date, supplier_id, employee_id) 
VALUES
	('2023-12-17', 1, 5),
	('2023-12-23', 2, 3),
	('2023-12-30', 4, 7),
	('2024-01-07', 7, 4),
	('2024-01-15', 3, 5),
	('2024-02-06', 5, 6),
	('2024-02-27', 6, 1),
	('2024-03-08', 8, 2),
	('2024-03-19', 10, 2),
	('2024-04-10', 1, 7),
	('2024-04-20', 3, 4),
	('2024-05-15', 10, 5),
	('2024-05-29', 5, 1),
	('2024-06-18', 9, 3),
	('2024-07-12', 8, 2),
	('2024-08-16', 6, 4),
	('2024-08-31', 4, 3),
	('2024-09-25', 7, 1),
	('2024-10-12', 9, 7),
	('2024-11-05', 2, 6);

CREATE TABLE drug_in_stock(
	drug_in_stock_id SERIAL PRIMARY KEY NOT NULL,
	count INT NOT NULL DEFAULT 0 CHECK (count >= 0),
	price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
	drug_id INT NOT NULL,
	CONSTRAINT drug_stock_drug_fk FOREIGN KEY (drug_id) REFERENCES drug (drug_id) ON DELETE CASCADE
);

INSERT INTO drug_in_stock (drug_id, count, price) 
VALUES
	(1, 100, 150.00),
	(2, 50, 200.00),
	(3, 200, 250.00),
	(4, 75, 180.00),
	(5, 120, 175.00),
	(6, 90, 160.00),
	(7, 60, 210.00),
	(8, 85, 190.00),
	(9, 110, 155.00),
	(10, 130, 170.00),
	(11, 140, 220.00),
	(12, 95, 205.00),
	(13, 100, 195.00),
	(14, 80, 165.00),
	(15, 70, 230.00),
	(16, 150, 240.00),
	(17, 50, 250.00),
	(18, 200, 175.00),
	(19, 320, 180.00),
	(20, 400, 160.00),
	(21, 50, 140.00),
	(22, 60, 145.00),
	(23, 0, 150.00),
	(24, 90, 155.00),
	(25, 102, 160.00),
	(26, 110, 165.00),
	(27, 156, 170.00),
	(28, 130, 175.00),
	(29, 140, 180.00),
	(30, 0, 185.00),
	(31, 160, 190.00),
	(32, 148, 195.00),
	(33, 18, 200.00),
	(34, 190, 205.00),
	(35, 209, 210.00),
	(36, 116, 215.00),
	(37, 220, 220.00),
	(38, 241, 225.00),
	(39, 16, 230.00),
	(40, 250, 235.00),
	(41, 260, 240.00),
	(42, 270, 245.00),
	(43, 28, 250.00),
	(44, 290, 255.00),
	(45, 300, 260.00),
	(46, 350, 265.00),
	(47, 324, 270.00),
	(48, 330, 275.00),
	(49, 24, 280.00),
	(50, 138, 285.00),
	(51, 360, 290.00),
	(52, 370, 295.00),
	(53, 201, 300.00),
	(54, 390, 305.00),
	(55, 101, 310.00);

CREATE TABLE supply_details(
	supply_details_id SERIAL PRIMARY KEY NOT NULL,
	supply_id INT NOT NULL,
	drug_id INT NOT NULL,
	count INT NOT NULL CHECK (count > 0),
	price NUMERIC(10, 2) NOT NULL CHECK (price > 0),
	CONSTRAINT supply_details_supply_fk FOREIGN KEY (supply_id) REFERENCES supply (supply_id) ON DELETE CASCADE,
	CONSTRAINT supply_details_drug_fk FOREIGN KEY (drug_id) REFERENCES drug (drug_id) ON DELETE CASCADE
);

INSERT INTO supply_details (supply_id, drug_id, count, price) 
VALUES
	(1, 1, 100, 150.00),
	(1, 2, 50, 200.00),
	(1, 3, 200, 250.00),
	(2, 4, 75, 180.00),
	(2, 5, 120, 175.00),
	(2, 6, 90, 160.00),
	(3, 7, 60, 210.00),
	(3, 8, 85, 190.00),
	(3, 9, 110, 155.00),
	(4, 10, 130, 170.00),
	(4, 11, 140, 220.00),
	(4, 12, 95, 205.00),
	(5, 13, 100, 195.00),
	(5, 14, 80, 165.00),
	(5, 15, 70, 230.00),
	(6, 16, 150, 240.00),
	(6, 17, 50, 250.00),
	(6, 18, 200, 175.00),
	(7, 19, 320, 180.00),
	(7, 20, 400, 160.00),
	(7, 21, 50, 140.00),
	(8, 22, 60, 145.00),
	(8, 24, 90, 155.00),
	(9, 25, 102, 160.00),
	(9, 26, 110, 165.00),
	(9, 27, 156, 170.00),
	(10, 28, 130, 175.00),
	(10, 29, 140, 180.00),
	(11, 31, 160, 190.00),
	(11, 32, 148, 195.00),
	(11, 33, 18, 200.00),
	(12, 34, 190, 205.00),
	(12, 35, 209, 210.00),
	(12, 36, 116, 215.00),
	(13, 37, 220, 220.00),
	(13, 38, 241, 225.00),
	(13, 39, 16, 230.00),
	(14, 40, 250, 235.00),
	(14, 41, 260, 240.00),
	(14, 42, 270, 245.00),
	(15, 43, 28, 250.00),
	(15, 44, 290, 255.00),
	(15, 45, 300, 260.00),
	(16, 46, 350, 265.00),
	(16, 47, 324, 270.00),
	(16, 48, 330, 275.00),
	(17, 49, 24, 280.00),
	(17, 50, 138, 285.00),
	(17, 51, 360, 290.00),
	(18, 52, 370, 295.00),
	(18, 53, 201, 300.00),
	(18, 54, 390, 305.00),
	(19, 55, 101, 310.00);

CREATE TABLE order_details(
	order_id SERIAL PRIMARY KEY NOT NULL,
	receipt_number TEXT NOT NULL UNIQUE,
	datetime_purchase TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	customer_id INT NOT NULL,
	employee_id INT NOT NULL,
	status TEXT NOT NULL CHECK (status IN ('pending', 'completed', 'cancelled')),
	total NUMERIC(10, 2),
	CONSTRAINT order_customer_fk FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE,
	CONSTRAINT order_employee_fk FOREIGN KEY (employee_id) REFERENCES employee (employee_id) ON DELETE SET NULL
);

INSERT INTO order_details (receipt_number, datetime_purchase, customer_id, employee_id, status, total) 
VALUES 
	('RCPT-001', '2023-12-01 10:00:00', 5, 2, 'completed', 750.00),
	('RCPT-002', '2023-12-01 15:00:00', 12, 5, 'cancelled', 0.00),
	('RCPT-003', '2023-12-04 11:00:00', 8, 1, 'completed', 450.00),
	('RCPT-004', '2023-12-07 14:00:00', 14, 7, 'completed', 600.00),
	('RCPT-005', '2023-01-10 09:30:00', 21, 4, 'cancelled', 0.00),
	('RCPT-006', '2023-01-13 16:20:00', 19, 3, 'completed', 320.00),
	('RCPT-007', '2023-01-16 12:45:00', 3, 6, 'completed', 200.00),
	('RCPT-008', '2023-01-20 10:15:00', 11, 2, 'cancelled', 0.00),
	('RCPT-009', '2023-02-22 14:10:00', 7, 5, 'completed', 950.00),
	('RCPT-010', '2023-02-25 09:00:00', 22, 1, 'cancelled', 0.00),
	('RCPT-011', '2024-03-02 10:30:00', 9, 7, 'completed', 700.00),
	('RCPT-012', '2024-03-05 13:40:00', 6, 4, 'completed', 820.00),
	('RCPT-013', '2024-03-08 15:20:00', 20, 6, 'completed', 600.00),
	('RCPT-014', '2024-04-15 10:15:00', 1, 3, 'completed', 360.00),
	('RCPT-015', '2024-04-18 09:00:00', 18, 2, 'completed', 500.00),
	('RCPT-016', '2024-04-25 11:30:00', 13, 7, 'cancelled', 0.00),
	('RCPT-017', '2024-04-30 14:10:00', 2, 5, 'completed', 720.00),
	('RCPT-018', '2024-05-05 10:45:00', 15, 1, 'completed', 400.00),
	('RCPT-019', '2024-05-10 16:20:00', 10, 4, 'completed', 650.00),
	('RCPT-020', '2024-05-18 13:30:00', 4, 6, 'completed', 880.00),
	('RCPT-021', '2024-05-25 12:00:00', 16, 2, 'completed', 790.00),
	('RCPT-022', '2024-06-03 09:30:00', 17, 7, 'completed', 640.00),
	('RCPT-023', '2024-06-09 14:20:00', 12, 3, 'completed', 520.00),
	('RCPT-024', '2024-06-14 11:00:00', 5, 1, 'cancelled', 0.00),
	('RCPT-025', '2024-07-20 10:15:00', 3, 4, 'completed', 940.00),
	('RCPT-026', '2024-07-25 16:45:00', 22, 6, 'cancelled', 0.00),
	('RCPT-027', '2024-07-31 09:00:00', 11, 2, 'completed', 810.00),
	('RCPT-028', '2024-08-06 14:30:00', 14, 5, 'completed', 870.00),
	('RCPT-029', '2024-08-12 10:40:00', 18, 3, 'completed', 780.00),
	('RCPT-030', '2024-08-18 12:15:00', 9, 7, 'completed', 430.00),
	('RCPT-031', '2024-08-25 14:10:00', 19, 4, 'completed', 560.00),
	('RCPT-032', '2024-09-01 09:20:00', 6, 6, 'completed', 680.00),
	('RCPT-033', '2024-09-06 15:30:00', 10, 1, 'completed', 920.00),
	('RCPT-034', '2024-09-12 13:40:00', 7, 2, 'completed', 710.00),
	('RCPT-035', '2024-10-19 10:15:00', 20, 5, 'completed', 530.00),
	('RCPT-036', '2024-10-25 16:00:00', 2, 3, 'completed', 840.00),
	('RCPT-037', '2024-10-30 11:10:00', 13, 4, 'cancelled', 0.00),
	('RCPT-038', '2024-11-05 10:30:00', 1, 7, 'completed', 390.00),
	('RCPT-039', '2024-11-10 12:45:00', 8, 6, 'completed', 420.00),
	('RCPT-040', '2024-11-16 09:30:00', 21, 5, 'completed', 710.00),
	('RCPT-041', '2024-11-28 09:45:00', 8, 3, 'completed', 360.00),
	('RCPT-042', '2024-11-28 12:30:00', 14, 4, 'cancelled', 0.00),
	('RCPT-043', '2024-11-29 11:10:00', 5, 6, 'pending', 1000.00),
	('RCPT-044', '2024-12-02 12:03:00', 22, 7, 'pending', 990.00),
	('RCPT-045', '2024-12-03 8:45:00', 1, 1, 'cancelled', 0.00),
	('RCPT-046', '2024-12-04 15:20:00', 3, 6, 'pending', 210.00);

CREATE TABLE drug_in_order(
	drug_in_order_id SERIAL PRIMARY KEY NOT NULL,
	count INT NOT NULL CHECK (count >= 0),
	order_id INT NOT NULL,
	drug_in_stock_id INT NOT NULL,
	CONSTRAINT drug_in_order_drug_fk FOREIGN KEY (drug_in_stock_id) REFERENCES drug_in_stock (drug_in_stock_id) ON DELETE CASCADE
);

INSERT INTO drug_in_order (count, order_id, drug_in_stock_id) 
VALUES
    (3, 1, 1),
    (2, 2, 1),
    (0, 3, 2),
    (2, 4, 3),
    (1, 5, 3),
    (3, 6, 4),
    (2, 7, 4),
    (0, 8, 5),
    (3, 9, 6),
    (1, 10, 6),
    (2, 11, 7),
    (0, 12, 8),
    (3, 13, 9),
    (2, 14, 9),
    (0, 15, 10),
    (2, 16, 11),
    (3, 17, 11),
    (3, 18, 12),
    (3, 19, 13),
    (1, 20, 13),
    (2, 21, 14),
    (3, 22, 15),
    (0, 23, 16),
    (3, 24, 17),
    (1, 25, 18),
    (2, 26, 19),
    (3, 27, 20),
    (3, 28, 21),
    (2, 29, 22),
    (3, 30, 23),
    (0, 31, 24),
    (3, 32, 25),
    (0, 33, 26),
    (3, 34, 27),
    (3, 35, 28),
    (2, 36, 29),
    (3, 37, 30),
    (3, 38, 31),
    (3, 39, 32),
    (3, 40, 33),
    (3, 41, 34),
    (2, 42, 35),
    (3, 43, 36),
    (0, 44, 37),
    (1, 45, 38),
    (2, 46, 39),
    (3, 47, 40),
    (2, 48, 41),
    (1, 49, 42),
    (3, 50, 43),
    (3, 51, 44),
    (1, 52, 45),
    (2, 53, 46);
	

SELECT trade_name, registration_date 
FROM drug 
WHERE registration_date >= '2023-01-01' AND registration_date < '2024-01-01' LIMIT 10;

SELECT supply_id, supply_date
FROM supply 
WHERE supply_date = '2023-12-17' LIMIT 10;

SELECT*
FROM customer 
WHERE surname LIKE 'Т%' LIMIT 5;

SELECT DISTINCT country 
FROM drug LIMIT 15;

SELECT drug_in_stock_id, count, price 
FROM drug_in_stock 
WHERE count > 100 LIMIT 10;

SELECT * 
FROM order_details 
WHERE status = 'cancelled' LIMIT 10;

SELECT employee_id, surname, name, patronymic, salary
FROM employee 
WHERE salary IN (50000, 70000) LIMIT 5;

SELECT * 
FROM order_details
WHERE customer_id = 3 LIMIT 5;

SELECT name, contact 
FROM supplier
WHERE contact LIKE '+7900%' LIMIT 5;

SELECT * 
FROM drug 
WHERE country = 'Россия' LIMIT 10;

SELECT order_id, receipt_number, total
FROM order_details 
WHERE total > 200 LIMIT 10;

SELECT * 
FROM order_details 
WHERE datetime_purchase >= '2024-05-01' AND status = 'cancelled' LIMIT 10;

SELECT COUNT(*) AS total_customers 
FROM customer;

SELECT ROUND(AVG(salary), 2) AS avg_salary 
FROM employee;

SELECT release_form, COUNT(*) AS amount 
FROM drug 
GROUP BY release_form
LIMIT 10;

SELECT ROUND(AVG(price), 2) AS avg_price 
FROM drug_in_stock;

SELECT MAX(salary) AS max_salary, MIN(salary) AS min_salary 
FROM employee;

SELECT MAX(price) AS max_price, MIN(price) AS min_price
FROM drug_in_stock;

SELECT status, COUNT(*) AS amount 
FROM order_details 
GROUP BY status 
LIMIT 3;

SELECT COUNT(*) AS experienced_employees 
FROM employee 
WHERE experience >= 5;

SELECT supplier_id, COUNT(*) AS total_supplies 
FROM supply 
GROUP BY supplier_id 
LIMIT 10;

SELECT customer_id, COUNT(*) AS total_orders 
FROM order_details 
GROUP BY customer_id
LIMIT 22;

SELECT status, SUM(total) AS total_sum 
FROM order_details
GROUP BY status 
LIMIT 3;

SELECT order_id, SUM(count) AS total_drugs
FROM drug_in_order 
GROUP BY order_id 
LIMIT 10;