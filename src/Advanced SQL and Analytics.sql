use LMS
--for each course, calculate:1) Total number of enrolled users
--2) Total number of lessons
--I joined courses with enrollments and lessons to calculate user counts, lesson counts, and duration averages per course.
SELECT 
    c.course_id,
    c.title,
    COUNT(DISTINCT e.user_id) AS total_enrolled_users,
    COUNT(DISTINCT l.lesson_id) AS total_lessons
FROM LMS.Courses c
LEFT JOIN LMS.Enrollments e 
    ON c.course_id = e.course_id
LEFT JOIN LMS.Lessons l
    ON c.course_id = l.course_id
GROUP BY 
    c.course_id, 
    c.title;

--Identify the top three most active users based on total activity count.
--calculated top 3 user by grouping and count() function
select top 3
    user_id,
    count(*) as activity_count
from LMS.User_Activity
group by user_id
order by activity_count desc

--Calculate course completion percentage per user based on lesson activity.
--I compare how many lessons a user accessed against the total lessons in 
--that course to compute their completion percentage.
SELECT 
    ua.user_id,
    l.course_id,
    (COUNT(DISTINCT ua.lesson_id) * 100.0 / tl.total_lessons) 
         completion_percentage
FROM LMS.User_Activity ua
JOIN LMS.Lessons l 
    ON ua.lesson_id = l.lesson_id
JOIN (
    SELECT 
        course_id,
        COUNT(*) AS total_lessons
    FROM LMS.Lessons
    GROUP BY course_id
) tl 
    ON l.course_id = tl.course_id
GROUP BY 
    ua.user_id,
    l.course_id,
    tl.total_lessons;

--Find users whose average assessment score is higher than the course average.
--used CTE to calculate avg score and course average and then compared both by using wher clause
with useravg as(
    select
        s.user_id,
        a.Course_id,
        avg(s.score) as user_avg_score
    from LMS.Assessment_Submissions s
    join LMS.Assessments a
        on s.assessment_id=a.assessment_id
    group by s.user_id,a.course_id
),
courseAvg as(
    select
        a.course_id,
        Avg(s.score) as course_avg_score
    from LMS.Assessment_Submissions s
    join LMS.Assessments a
        on s.assessment_id=a.assessment_id
    group by a.course_id
)
select 
    u.user_id,
    u.course_id,
    u.user_avg_score,
    c.course_avg_score
from useravg u
join courseAvg c
    on u.course_id=c.course_id
where u.user_avg_score>c.course_avg_score

--List courses where lessons are frequently accessed but assessments are never attempted.
--calculated total lessons and total submissions and than filtered by using where assessment submissions are null
with lessonActivity as(
    select
        l.course_id,
        count(*) as total_lessons_activity
    from LMS.User_Activity ua
    join LMS.Lessons l
        on ua.lesson_id=l.lesson_id
    group by l.course_id
),
AssessmentAttempt as(
select 
    a.course_id,
    count(*) total_submissions
from LMS.Assessment_Submissions s
join LMS.Assessments a
    on s.assessment_id=a.assessment_id
group by a.course_id
)
select
    c.course_id,
    c.title,
    la.total_lessons_activity
from lessonActivity la
join LMS.Courses c
    on la.course_id=c.course_id
left join AssessmentAttempt aa
on la.course_id=aa.course_id
where aa.total_submissions is null

--Rank users within each course based on their total assessment score.
--I calculated each user total score per course and then used window ranking
--function to rank them within that course.
WITH UserCourseScores AS (
    SELECT 
        s.user_id,
        a.course_id,
        SUM(s.score) AS total_score
    FROM LMS.Assessment_Submissions s
    JOIN LMS.Assessments a 
        ON s.assessment_id = a.assessment_id
    GROUP BY s.user_id, a.course_id
)
SELECT
    user_id,
    course_id,
    total_score,
    RANK() OVER (PARTITION BY course_id ORDER BY total_score DESC) AS user_rank
FROM UserCourseScores
ORDER BY course_id, user_rank;

--Identify the first lesson accessed by each user for every course.
--I joined activity with lessons and use ROW_NUMBER() to select the
--earliest activity for each user in each course.
WITH ActivityWithCourse AS (
SELECT 
    ua.user_id,
    ua.lesson_id,
    l.course_id,
    ua.activity_time,
    ROW_NUMBER() OVER (PARTITION BY ua.user_id, l.course_id ORDER BY ua.activity_time
    ) AS rn
FROM LMS.User_Activity ua
JOIN LMS.Lessons l
    ON ua.lesson_id = l.lesson_id
)
SELECT 
    user_id,
    course_id,
    lesson_id AS first_lesson_id,
    activity_time AS first_access_time
FROM ActivityWithCourse
WHERE rn = 1
ORDER BY user_id, course_id;

--Find users with activity recorded on at least five consecutive days.
--I assigned row numbers to activity dates and group dates where difference
--from row number is constant, allowing us to count 5-day consecutive streaks.
WITH activity_days AS (
    SELECT 
        user_id,
        CAST(activity_time AS DATE) AS activity_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY CAST(activity_time AS DATE)
        ) AS rn
    FROM LMS.User_Activity
    GROUP BY user_id, CAST(activity_time AS DATE)
),
grouped AS (
    SELECT
        user_id,
        activity_date,
        rn,
        DATEADD(day, -rn, activity_date) AS grp
    FROM activity_days
),
streaks AS (
    SELECT 
        user_id,
        COUNT(*) AS consecutive_days
    FROM grouped
    GROUP BY user_id, grp
)
SELECT user_id, consecutive_days
FROM streaks
WHERE consecutive_days >= 5;

--Retrieve users who enrolled in a course but never submitted any assessment.
--I joined enrollments, assessments, submissions and filtered submissions that
--are NULL to find users who never submitted.
SELECT 
    e.user_id,
    e.course_id,
    e.enrolled_at
FROM LMS.Enrollments e
LEFT JOIN LMS.Assessments a
    ON e.course_id = a.course_id
LEFT JOIN LMS.Assessment_Submissions s
    ON a.assessment_id = s.assessment_id
    AND e.user_id = s.user_id
WHERE s.submission_id IS NULL;

--List courses where every enrolled user has submitted at least one assessment.
--I Compared enrolled users and users who made submissions 
--if counts match, all enrolled users submitted.
SELECT 
    e.course_id
FROM LMS.Enrollments e
LEFT JOIN LMS.Assessments a 
    ON e.course_id = a.course_id
LEFT JOIN LMS.Assessment_Submissions s
    ON a.assessment_id = s.assessment_id
    AND e.user_id = s.user_id
GROUP BY e.course_id
HAVING COUNT(DISTINCT e.user_id) = COUNT(DISTINCT s.user_id);
