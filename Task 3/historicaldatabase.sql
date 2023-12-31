-- Create Histroical Database-- 
CREATE TABLE historical_lessons (
    historical_lesson_id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
    lesson_id INT,
    lesson_type VARCHAR(20),
    genre VARCHAR(50),
    instrument VARCHAR(50),
    lesson_price INT,
    student_name VARCHAR(200),
    student_email VARCHAR(100)
);



-- Copying Data to Histroical Database--

INSERT INTO historical_lessons (
    lesson_id,
    lesson_type,
    genre,
    instrument,
    lesson_price,
    student_name,
    student_email
)
SELECT
    ml.lesson_id,
    CASE WHEN t.value = 'Individual' THEN 'Individual'
         WHEN t.value = 'Group' THEN 'Group'
         ELSE 'Ensemble' END AS lesson_type,
    ml.genre,
    CASE WHEN t.value = 'Ensemble' THEN '' ELSE li.value END AS instrument,
    CASE 
        WHEN ml.skill_level_id = ps.skill_level_id THEN ps.price
        ELSE NULL  
    END AS lesson_price,
    CONCAT(p.first_name, ' ', p.last_name) AS student_name,
    p.email AS student_email
FROM music_lesson ml
JOIN type_of_lesson t ON ml.type_of_lesson_id = t.type_of_lesson_id
JOIN pricing_scheme ps ON ml.type_of_lesson_id = ps.type_of_lesson_id AND ml.skill_level_id = ps.skill_level_id
JOIN student s ON s.student_id = ml.instructor_id
JOIN person p ON s.student_person_id = p.person_id
LEFT JOIN lesson_instrument li ON ml.instrument_id = li.instrument_id
WHERE ml.lesson_id = 5; -- Replace '5' with the desired lesson_id 
