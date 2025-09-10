DROP TABLE IF EXISTS StudentEnrollments;

CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_id VARCHAR(10),
    enrollment_date DATE
);

-- Part A: Deadlock Simulation
TRUNCATE TABLE StudentEnrollments;

INSERT INTO StudentEnrollments VALUES
(1, 'Ashish', 'CSE101', '2024-06-01'),
(2, 'Smaran', 'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');

START TRANSACTION;
UPDATE StudentEnrollments SET course_id = 'CSE201' WHERE student_id = 1;

-- In another session run:
-- START TRANSACTION;
-- UPDATE StudentEnrollments SET course_id = 'CSE202' WHERE student_id = 2;

-- Back in session 1:
-- UPDATE StudentEnrollments SET course_id = 'CSE301' WHERE student_id = 2;

-- In session 2:
-- UPDATE StudentEnrollments SET course_id = 'CSE302' WHERE student_id = 1;
COMMIT;

-- Part B: MVCC Snapshot Read
TRUNCATE TABLE StudentEnrollments;

INSERT INTO StudentEnrollments VALUES
(1, 'Ashish', 'CSE101', '2024-06-01');

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM StudentEnrollments WHERE student_id = 1;

-- In another session run:
-- START TRANSACTION;
-- UPDATE StudentEnrollments SET enrollment_date = '2024-07-10' WHERE student_id = 1;
-- COMMIT;

-- Back in session 1:
SELECT * FROM StudentEnrollments WHERE student_id = 1;
COMMIT;

-- Part C1: With Locking (SELECT FOR UPDATE)
TRUNCATE TABLE StudentEnrollments;

INSERT INTO StudentEnrollments VALUES
(1, 'Ashish', 'CSE101', '2024-06-01');

START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1 FOR UPDATE;

-- In another session run:
-- START TRANSACTION;
-- SELECT * FROM StudentEnrollments WHERE student_id = 1;
-- COMMIT;

COMMIT;

-- Part C2: With MVCC (Normal SELECT)
TRUNCATE TABLE StudentEnrollments;

INSERT INTO StudentEnrollments VALUES
(1, 'Ashish', 'CSE101', '2024-06-01');

START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM StudentEnrollments WHERE student_id = 1;

-- In another session run:
-- START TRANSACTION;
-- UPDATE StudentEnrollments SET enrollment_date = '2024-08-15' WHERE student_id = 1;
-- COMMIT;

-- Back in session 1:
SELECT * FROM StudentEnrollments WHERE student_id = 1;
COMMIT;
