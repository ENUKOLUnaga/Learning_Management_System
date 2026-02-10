use LMS

--26)Propose constraints to ensure a user cannot submit the same assessment more than once.
--This unique constraint prevents duplicate submissions by ensuring each user-assessment 
--pair appears only once in the table.
ALTER TABLE LMS.Assessment_Submissions
ADD CONSTRAINT UQ_User_Assessment UNIQUE (user_id, assessment_id);

--27)Ensure that assessment scores do not exceed the defined maximum score.
--A trigger is required because SQL Server cannot use a CHECK constraint 
--to compare columns across two different tables.
CREATE TRIGGER trg_ValidateAssessmentScore
ON LMS.Assessment_Submissions
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN LMS.Assessments a 
            ON i.assessment_id = a.assessment_id
        WHERE i.score > a.max_score
    )
    BEGIN
        RAISERROR ('Score cannot exceed range.', 16, 1)
    END
END

--28)Prevent users from enrolling in courses that have no lessons.
--This trigger blocks enrollments into any course that does not 
--contain at least one lesson.
CREATE TRIGGER trg_PreventEnrollmentWithoutLessons
ON LMS.Enrollments
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN LMS.Lessons l ON i.course_id = l.course_id
        GROUP BY i.course_id
        HAVING COUNT(l.lesson_id) = 0
    )
    BEGIN
        RAISERROR ('Cannot enroll in a course that has no lessons.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

--29)Ensure that only instructors can create courses.
--Trigger prevents course creation by rejecting 
--inserts where the user’s role is not instructor.
CREATE TRIGGER trg_OnlyInstructorsCreateCourses
ON LMS.Courses
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN LMS.Users u 
            ON i.created_at = u.user_id
        WHERE u.role <> 'instructor'
    )
    BEGIN
        RAISERROR ('Only instructors are allowed to create courses.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

--30)Describe a safe strategy for deleting courses while preserving historical data.
--Archive, don’t delete.
--Preserve all related data (students, grades, assignments).
--Restrict editing but allow read-only access.
--Keep exports and snapshots for long-term safety.
--Only purge after formal retention requirements are met.
