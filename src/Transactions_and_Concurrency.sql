use LMS

--31)Design a transaction flow for enrolling a user into a course.
DECLARE @user_id INT = 101;
DECLARE @course_id INT = 5;
DECLARE @enrollment_id INT = 52;
BEGIN TRANSACTION;
-- 1. Check course has lessons
IF NOT EXISTS (
    SELECT 1 
    FROM LMS.Lessons 
    WHERE course_id = @course_id
)
BEGIN
    ROLLBACK;
    THROW 50001, 'Cannot enroll. Course has no lessons.', 1;
END;
-- 2. Prevent duplicate enrollment
IF EXISTS (
    SELECT 1
    FROM LMS.Enrollments
    WHERE user_id = @user_id AND course_id = @course_id
)
BEGIN
    ROLLBACK;
    THROW 50002, 'User already enrolled in this course.', 1;
END;
-- 3. Insert new enrollment
INSERT INTO LMS.Enrollments (enrollment_id,user_id, course_id, enrolled_at)
VALUES (@enrollment_id,@user_id, @course_id, GETDATE());
COMMIT;

--32)Explain how to handle concurrent assessment submissions safely.
--Using a unique constraint plus a transaction with locking 
--(UPDLOCK + HOLDLOCK) to ensure only one submission is 
--inserted and prevent duplicate concurrent assessment submissions.
-- Lock existing submission attempt (if any)

--33)Describe how partial failures should be handled during assessment submission.
--Use a transaction that rolls back all changes on error, logs the failure, and
--returns a clear error message so no partial or inconsistent submission data is saved.

--34)Recommend suitable transaction isolation levels for enrollments and submissions.
--Enrollments:
--Use READ COMMITTED to prevent dirty reads while allowing normal concurrency.
--Assessment Submissions:
--Use SERIALIZABLE to safely prevent duplicate or conflicting submissions.

--35)Explain how phantom reads could affect analytics queries and how to prevent them.
--Phantom reads can cause analytics queries (like counting enrollments or averaging scores) to 
--return inconsistent results because new rows may be inserted during the query; prevent them
--by using the SERIALIZABLE isolation level, which blocks inserts that would appear as new phantom rows.
