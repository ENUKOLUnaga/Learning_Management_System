--created database LMS
create database LMS
--using Database LMS
use LMS
--deletes table if table exist
DROP TABLE IF EXISTS LMS.Assessment_Submissions;
DROP TABLE IF EXISTS dbo.Assessments;
DROP TABLE IF EXISTS dbo.UserActivity;
DROP TABLE IF EXISTS dbo.Lessons;
DROP TABLE IF EXISTS dbo.Enrollments;
DROP TABLE IF EXISTS dbo.Courses;
DROP TABLE IF EXISTS dbo.Users;
--creating schema for lms
create schema LMS;
go
--creating table users : user_id ,full_name ,email ,role ,created_at
CREATE TABLE LMS.Users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
--importing data into user table 10,000 records
bulk insert LMS.Users
from 'E:\Learning_Management_System(LMS)\users.csv'
with(
    Firstrow = 2,
    Fieldterminator=',',
    Rowterminator='0X0a'
);
--creating table courses - courseid ,title ,description ,created_at
CREATE TABLE LMS.Courses (
    course_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(MAX),
    created_at DATETIME NOT NULL DEFAULT GETDATE()
);
--importing data into courses table (200 courses)
bulk insert LMS.courses
from 'E:\Learning_Management_System(LMS)\courses.csv'
with(
    format = 'CSV',
    firstrow = 2,
    fieldterminator=',',
    rowterminator='0X0A'
);
--creating table lessons - lesson_id ,course_id ,title ,content ,created_at
CREATE TABLE LMS.Lessons (
    lesson_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content VARCHAR(MAX),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (course_id) REFERENCES LMS.Courses(course_id)
);
--importing data into lessons table (2000 lessons)
bulk insert LMS.Lessons
from 'E:\Learning_Management_System(LMS)\lessons.csv'
with(
    format='CSV',
    firstrow=2,
    fieldterminator=',',
    rowterminator='0X0A'
);
--creating table enrollments - enrollment_id ,user_id ,course_id ,enrolled_at
CREATE TABLE LMS.Enrollments (
    enrollment_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES LMS.Users(user_id),
    FOREIGN KEY (course_id) REFERENCES LMS.Courses(course_id)
);

--importing data into enrollments table (3000 enrollments)
bulk insert LMS.Enrollments
from 'E:\Learning_Management_System(LMS)\enrollments.csv'
with(
    format = 'CSV',
    firstrow=2,
    fieldterminator=',',
    rowterminator='0X0A'
)
--creating table assessments - assessment_id ,course_id ,title ,max_score ,created_at
CREATE TABLE LMS.Assessments (
    assessment_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    max_score INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (course_id) REFERENCES LMS.Courses(course_id)
)
--importing data into Assessments table - 500 assessments
bulk insert LMS.Assessments
from 'E:\Learning_Management_System(LMS)\assessments.csv'
with(
    format = 'CSV',
    firstrow=2,
    fieldterminator=',',
    rowterminator='0X0A'
);
--creating table Assessment_submissions - submission_id ,assessment_id ,user-id ,score ,submitted_at
CREATE TABLE LMS.Assessment_Submissions (
    submission_id INT PRIMARY KEY,
    assessment_id INT NOT NULL,
    user_id INT NOT NULL,
    score INT CHECK (score >= 0),
    submitted_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (assessment_id) REFERENCES LMS.Assessments(assessment_id),
    FOREIGN KEY (user_id) REFERENCES LMS.Users(user_id)
);
--importing data into the LMS.Assessment_submissons
bulk insert LMS.Assessment_Submissions
from 'E:\Learning_Management_System(LMS)\assessments.csv'
with(
    format = 'CSV',
    firstrow=2,
    fieldterminator=',',
    rowterminator='0x0A'
);
--importing data into Assessment_Submissions table-20000 submissions
ALTER TABLE LMS.Assessment_Submissions NOCHECK CONSTRAINT ALL;

BULK INSERT LMS.Assessment_Submissions
FROM 'E:\Learning_Management_System(LMS)\Assessment_Submissions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);

ALTER TABLE LMS.Assessment_Submissions CHECK CONSTRAINT ALL;
--creating table User_Activity - activity_id ,user_id ,lesson_id ,activity_type ,activity_time
CREATE TABLE LMS.User_Activity (
    activity_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    activity_time DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES LMS.Users(user_id),
    FOREIGN KEY (lesson_id) REFERENCES LMS.Lessons(lesson_id)
);

--importing data into the LMS.User_Activity - 100000 user activity
BULK INSERT LMS.User_Activity
FROM 'E:\Learning_Management_System(LMS)\user_activity.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A'
);

