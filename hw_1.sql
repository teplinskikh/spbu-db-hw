CREATE TABLE courses (
id INT PRIMARY KEY,
name VARCHAR(100),
is_exam BOOLEAN,
min_grade INT,
max_grade INT
);

INSERT INTO courses (id, name, is_exam, min_grade, max_grade) VALUES
(1, 'AI in social medias', TRUE, 0, 100),
(2, 'English language', FALSE, 0, 50),
(3, 'Machine Learning', TRUE, 0, 100),
(4, 'Computer Vision', FALSE, 0, 50),
(5, 'Technologies of database management systems', TRUE, 0, 100),
(6, 'Bayesian networks', TRUE, 0, 100),
(7, 'Psychology', FALSE, 0, 50);

CREATE TABLE groups (
id INT PRIMARY KEY,
full_name VARCHAR(100),
short_name VARCHAR(10),
students_ids INT[]
);

CREATE TABLE students (
id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
group_id INT,
courses_ids INT[],
FOREIGN KEY (group_id) REFERENCES groups(id)
);

INSERT INTO groups (id, full_name, short_name, students_ids) VALUES
(1, 'Computer Science 2024', 'CS24', ARRAY[2, 9, 12]),
(2, 'Computer Science 2023', 'CS23', ARRAY[1, 7, 15]),
(3, 'Artificial intelligence 2024', 'AI24', ARRAY[8, 13, 14]),
(4, 'rtificial intelligence 2023', 'AI23', ARRAY[6, 10, 11]),
(5, 'Mechanical Engineering 2024', 'ME24', ARRAY[3, 4, 5, 16, 17]);

INSERT INTO students (id, first_name, last_name, group_id, courses_ids) VALUES
(1, 'Крош', 'Смешариков', 2, ARRAY[1, 2]),
(2, 'Нюша', 'Смешарикова', 1, ARRAY[1, 3]),
(3, 'Рик', 'Санчес', 5, ARRAY[3, 4]),
(4, 'Морти', 'Смит', 5, ARRAY[3, 5]),
(5, 'Боб', 'Строитель', 5, ARRAY[1, 4]),
(6, 'Губка', 'Боб', 4, ARRAY[1, 6]),
(7, 'Мэйбл', 'Пайнс', 2, ARRAY[2, 7]),
(8, 'Стелла', 'Винксова', 3, ARRAY[4, 6]),
(9, 'Бараш', 'Смешаркин', 1, ARRAY[6, 7]),
(10, 'Леди', 'Баг', 4, ARRAY[1, 3, 5]),
(11, 'Адриан', 'Суперкот', 4, ARRAY[2, 4, 6]),
(12, 'Кар', 'Карович', 1, ARRAY[3, 5, 7]),
(13, 'Флора', 'Феева', 3, ARRAY[1, 2, 3]),
(14, 'Конь', 'БоДжек', 3, ARRAY[2, 3, 4]),
(15, 'Лиза', 'Симпсон', 2, ARRAY[3, 4, 5]),
(16, 'Пинки', 'Крысов', 5, ARRAY[4, 5, 6]),
(17, 'Брейн', 'Крысов', 5, ARRAY[5, 6, 7]);

CREATE TABLE machinelearning_grades (
student_id INT,
grade INT,
grade_str VARCHAR(2),
FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO machinelearning_grades (student_id, grade, grade_str) VALUES
(2, 95, 'A'),
(3, 85, 'A'),
(4, 75, 'B'),
(10, 65, 'B'),
(12, 55, 'C'),
(13, 45, 'C'),
(14, 35, 'D'),
(15, 25, 'F');


SELECT g.full_name, g.short_name, COUNT(s.id) AS student_count
FROM groups g
JOIN students s ON g.id = s.group_id
GROUP BY g.full_name, g.short_name;

SELECT first_name, last_name, group_id
FROM students
WHERE last_name LIKE 'Смеш%';

SELECT COUNT(id) AS exam_courses_count
FROM courses
WHERE is_exam = TRUE;

SELECT id, first_name, last_name
FROM students
WHERE group_id = 3;

SELECT id, first_name, last_name, ARRAY_LENGTH(courses_ids, 1) AS course_count
FROM students
WHERE ARRAY_LENGTH(courses_ids, 1) < 3;

SELECT grade_str, COUNT(student_id) AS student_count
FROM machinelearning_grades
GROUP BY grade_str
ORDER BY student_count DESC;

SELECT ROUND(AVG(grade),2) AS average_grade
FROM machinelearning_grades;

SELECT s.first_name, s.last_name, mg.grade
FROM students s
JOIN machinelearning_grades mg ON s.id = mg.student_id
WHERE mg.grade >= 75;

SELECT student_id, grade, grade_str
FROM machinelearning_grades
WHERE grade_str = 'F';

SELECT student_id, grade, grade_str
FROM machinelearning_grades
WHERE grade_str IN ('B', 'C');

SELECT COUNT(student_id) AS satisfactory_students
FROM machinelearning_grades
WHERE grade BETWEEN 45 AND 95;

SELECT MIN(grade) AS min_grade, MAX(grade) AS max_grade
FROM machinelearning_grades;


