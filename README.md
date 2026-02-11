# Learning Management System (LMS) 
## Overview
- This project implements a Learning Management System (LMS) database using Microsoft SQL Server (T-SQL).
It focuses on relational database design, data integrity enforcement, transaction handling, and analytical SQL queries commonly used in real-world applications.
- The project is designed as a practice-oriented SQL assignment to strengthen understanding of:
- Relational data modeling
- Query optimization
- Constraints and triggers
- Transactions and concurrency
- Scalability and performance trade-offs
- Database Schema Overview
### The LMS schema consists of the following core entities:
- Users: learners and instructors
- Courses: created by instructors, contain lessons and assessments
- Lessons: learning units within a course
- Enrollments: users enrolled in courses
- UserActivity: tracks user interactions with lessons
- Assessments: evaluations linked to courses
- AssessmentSubmissions: user submissions with scores
## Key Relationships
- Users can enroll in multiple courses
- Courses contain multiple lessons and assessments
- Users perform activities on lessons
- Users submit assessments and receive scores
- Understanding these relationships is essential before writing queries.
## Technologies Used
- Database: Microsoft SQL Server (T-SQL)
- Schema Design: Normalized relational schema
## SQL Features:
- Constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK)
- Triggers (AFTER INSERT, AFTER UPDATE)
- Transactions (BEGIN TRANSACTION, COMMIT, ROLLBACK)
- Window Functions and CTEs
- Indexing and performance tuning
# Section 1: Intermediate SQL Queries
- Users enrolled in more than three courses
- Courses with no enrollments
- Total number of enrolled users per course
- Users enrolled but never accessed any lesson
- Lessons never accessed by any user
- Last activity timestamp per user
- Users scoring less than 50% in assessments
- Assessments with no submissions
- Highest score per assessment
- Users with inactive enrollments
- Each query includes:
- Reason for join choices
- Assumptions made
- Expected behavior on large datasets
# Section 2: Advanced SQL & Analytics
- Course-level aggregates (enrollments, lessons)
- Top three most active users
- Course completion percentage per user
- Users scoring above course average
- Courses with lesson activity but no assessment attempts
- Ranking users within each course by total score
- First lesson accessed by each user per course
- Users active for at least five consecutive days
- Enrolled users with no assessment submissions
- Courses where all enrolled users submitted assessments
- Advanced SQL concepts used:
- Common Table Expressions (CTEs)
- Window functions (RANK, AVG OVER)
- Aggregations and filtering
- Time-based analysis
# Section 3: Performance & Optimization
- Indexing strategies for:
- Course dashboards
- User activity analytics
- Identification of performance bottlenecks
- Query optimization for large UserActivity tables
- Use cases for materialized views
- Partitioning strategies for high-volume activity data
# Section 4: Data Integrity & Constraints
- Prevent duplicate assessment submissions
- Validate assessment scores against maximum marks
- Prevent enrollment into courses without lessons
- Restrict course creation to instructors only
- Safe course deletion using soft deletes and archiving
- All rules are enforced at the database level to ensure data integrity.
# Section 5: Transactions & Concurrency
- Transaction flow for course enrollment
- Safe handling of concurrent assessment submissions
- Managing partial failures with rollback strategies
- Recommended isolation levels for different operations
- Preventing phantom reads in analytics queries
# Section 6: Database Design & Architecture
- Schema extensions for course completion certificates
- Efficient video progress tracking at scale
- Normalization vs denormalization trade-offs
- Reporting-friendly schema design
- Strategy for scaling the system to millions of users
