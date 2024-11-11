CREATE TABLE student_courses (
id SERIAL PRIMARY KEY,
student_id INT,
course_id INT,
UNIQUE (student_id, course_id),
FOREIGN KEY (student_id) REFERENCES students(id),
FOREIGN KEY (course_id) REFERENCES courses(id)
);

INSERT INTO student_courses (student_id, course_id) VALUES
(1, 1), (1, 2), (2, 1), (2, 3), (3, 3), (3, 4), (4, 3), (4, 5), (5, 1), (5, 4), (6, 1), (6, 6), (7, 2), (7, 7), (8, 4), (8, 6), (9, 6), (9, 7), (10, 1), 
(10, 3), (10, 5), (11, 2), (11, 4), (11, 6), (12, 3), (12, 5), (12, 7), (13, 1), (13, 2), (13, 3), (14, 2), (14, 3), (14, 4), (15, 3),(15, 4), (15, 5),(16, 4), (16, 5),(16, 6), (17, 5),(17, 6), (17, 7);

CREATE TABLE ai_social_media_grades (
student_id INT,
grade INT CHECK (grade >= 0 AND grade <= 100),
grade_str VARCHAR(2),
FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO ai_social_media_grades (student_id, grade, grade_str) VALUES
(1, 80, 'A'), (2, 75, 'B'), (5, 60, 'C'), (6, 85, 'A'), (10, 90, 'A'), (13, 70, 'B');

CREATE TABLE english_language_grades (
student_id INT,
grade INT CHECK (grade >= 0 AND grade <= 50),
grade_str VARCHAR(2),
FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO english_language_grades (student_id, grade, grade_str) VALUES
(1, 40, 'B'), (7, 45, 'A'), (9, 35, 'C'), (11, 50, 'A'), (13, 42, 'B'), (14, 27, 'D');

CREATE TABLE computer_vision_grades (
student_id INT,
grade INT CHECK (grade >= 0 AND grade <= 50),
grade_str VARCHAR(2),
FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO computer_vision_grades (student_id, grade, grade_str) VALUES
(3, 44, 'B'), (5, 48, 'A'), (8, 35, 'C'), (11, 50, 'A'), (14, 46, 'B'), (15, 20, 'D');

CREATE TABLE database_management_grades (
student_id INT,
grade INT CHECK (grade >= 0 AND grade <= 100),
grade_str VARCHAR(2),
FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO database_management_grades (student_id, grade, grade_str) VALUES
(4, 85, 'A'), (10, 78, 'B'), (12, 90, 'A'), (15, 88, 'A'), (16, 75, 'B'), (17, 65, 'C');

CREATE TABLE bayesian_networks_grades (
student_id INT,
grade INT CHECK (grade >= 0 AND grade <= 100),
grade_str VARCHAR(2),
FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO bayesian_networks_grades (student_id, grade, grade_str) VALUES
(6, 83, 'A'), (9, 70, 'B'), (11, 95, 'A'), (13, 65, 'B'), (16, 80, 'B'), (17, 58, 'C');

CREATE TABLE psychology_grades (
student_id INT,
grade INT CHECK (grade >= 0 AND grade <= 50),
grade_str VARCHAR(2),
FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO psychology_grades (student_id, grade, grade_str) VALUES
(7, 40, 'B'), (9, 45, 'B'), (12, 38, 'C'), (15, 47, 'B'), (17, 50, 'A');

CREATE TABLE group_courses (
id SERIAL PRIMARY KEY,
group_id INT,
course_id INT,
UNIQUE (group_id, course_id), 
FOREIGN KEY (group_id) REFERENCES groups(id),
FOREIGN KEY (course_id) REFERENCES courses(id)
);

INSERT INTO group_courses (group_id, course_id)
SELECT DISTINCT s.group_id, sc.course_id
FROM students s
JOIN student_courses sc ON s.id = sc.student_id
ON CONFLICT (group_id, course_id) DO NOTHING;

ALTER TABLE students
DROP COLUMN courses_ids;

ALTER TABLE courses
ADD CONSTRAINT unique_course_name UNIQUE (name);

CREATE INDEX idx_students_group_id ON students(group_id);

-- Индексация поля group_id в таблице students ускоряет выполнение запросов при поиске студентов по их группе.
-- Это позволит быстрее находить записи без необходимости полного сканирования таблицы.


SELECT s.id AS student_id, s.first_name, s.last_name, c.name AS course_name
FROM students s
JOIN student_courses sc ON s.id = sc.student_id
JOIN courses c ON sc.course_id = c.id
LIMIT 42;


WITH all_grades AS (
	SELECT student_id, grade FROM ai_social_media_grades
	UNION ALL
	SELECT student_id, grade FROM english_language_grades
	UNION ALL
	SELECT student_id, grade FROM machinelearning_grades
	UNION ALL
	SELECT student_id, grade FROM computer_vision_grades
	UNION ALL
	SELECT student_id, grade FROM database_management_grades
	UNION ALL
	SELECT student_id, grade FROM bayesian_networks_grades
	UNION ALL
	SELECT student_id, grade FROM psychology_grades
),
student_avg_grades AS (
	SELECT student_id, ROUND(AVG(grade), 2) AS avg_grade
	FROM all_grades
	GROUP BY student_id
)
SELECT s.id AS student_id, s.first_name, s.last_name, s.group_id, g.full_name AS group_name, student_avg_grades.avg_grade
FROM students s
JOIN groups g ON s.group_id = g.id
JOIN student_avg_grades ON s.id = student_avg_grades.student_id
WHERE student_avg_grades.avg_grade > (
	SELECT MAX(inner_avg.avg_grade)
	FROM student_avg_grades inner_avg
	JOIN students inner_s ON inner_avg.student_id = inner_s.id
	WHERE inner_s.group_id = s.group_id AND inner_s.id != s.id
)
LIMIT 5;


SELECT c.name AS course_name, COUNT(sc.student_id) AS student_count
FROM courses c
JOIN student_courses sc ON c.id = sc.course_id
GROUP BY c.name
LIMIT 7;


WITH course_avg_grades AS (
	SELECT 'AI in social medias' AS course_name, ROUND(AVG(grade), 2) AS average_grade FROM ai_social_media_grades
	UNION ALL
	SELECT 'English language', ROUND(AVG(grade), 2) FROM english_language_grades
	UNION ALL
	SELECT 'Machine Learning', ROUND(AVG(grade), 2) FROM machinelearning_grades
	UNION ALL
	SELECT 'Computer Vision', ROUND(AVG(grade), 2) FROM computer_vision_grades
	UNION ALL
	SELECT 'Technologies of database management systems', ROUND(AVG(grade), 2) FROM database_management_grades
	UNION ALL
	SELECT 'Bayesian networks', ROUND(AVG(grade), 2) FROM bayesian_networks_grades
	UNION ALL
	SELECT 'Psychology', ROUND(AVG(grade), 2) FROM psychology_grades
)
SELECT course_name, average_grade
FROM course_avg_grades
LIMIT 5;