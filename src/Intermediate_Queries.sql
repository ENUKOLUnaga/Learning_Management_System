use LMS
--List all users who are enrolled in more than three courses.
--used Left join to join two tables grouped data based on name, id ,email
select 
	u.user_id,
	u.full_name,
	u.email,
	count(e.course_id) total_Courses
from LMS.Users U
Left join LMS.Enrollments E
on U.user_id=E.user_id
group by u.user_id,u.full_name,u.email
having count(e.course_id)>3

--Find courses that currently have no enrollments.
--used left join to join courses and enrollments filtered data by using where clause
select
	c.course_id,
	c.title
from LMS.Courses C
left join LMS.Enrollments e
on c.course_id = e.course_id
where e.course_id is null

--Display each course along with the total number of enrolled users.
--used left join which shows all courses grouped data based on course_id and title
select 
c.course_id,
c.title,
count(e.course_id) total_enrolled
from LMS.Courses c
left join LMS.Enrollments e
on c.course_id=e.course_id
group by c.course_id,c.title

--Identify users who enrolled in a course but never accessed any lesson.
--here wants to access the 3 tables so i joined 3 tables by using left join
--and filtered data by using where clause user is not present in user activity
select
	u.user_id,
    u.full_name,
    u.email,
    e.course_id
from LMS.Enrollments e
join LMS.users u
	on e.user_id=u.user_id
Left join LMS.User_Activity ua
on e.user_id=ua.user_id
where ua.user_id is null

--Fetch lessons that have never been accessed by any user.
--for fetching users who never accessed lessons, used user activity and lessons 
--joined both by using left join and filtered data by using where clause
select
	l.lesson_id
from LMS.Lessons l
left join LMS.User_activity ua
on l.lesson_id=ua.lesson_id
where ua.lesson_id is null

--Show the last activity timestamp for each user.
--used user activity table to get last activity, by using group by
--grouped data based on user_id
select
	user_id,
	max(activity_time) as last_activity
from LMS.user_activity
group by user_id

--List users who submitted an assessment but scored less than 50 percent of the maximum score.
--Joins submissions with assessments to retrieve each assessments max_score.
--Filtered records where the users score is less than 50% compared to max_score.
select 
	s.user_id,
	s.score,
	a.max_score
from LMS.Assessment_Submissions s
left join LMS.assessments a
on s.assessment_id=a.assessment_id
where s.score<0.5*a.max_score

--Find assessments that have not received any submissions.
--joined tables such as assessment and assessment_submission & fitered data 
--by using where clause get the assessment id is null

select 
	ab.assessment_id
from LMS.Assessment_Submissions ab
left join LMS.Assessments a
on ab.assessment_id=a.assessment_id
where ab.assessment_id is null

--Display the highest score achieved for each assessment.
--I used GROUP BY with MAX(score) to get the single highest 
--score for each assessment from all its submissions.
select
	assessment_id,
	max(score)  max_score
from LMS.Assessment_Submissions
group by assessment_id

--Identify users who are enrolled in a course but have an inactive enrollment status.
--used where to filter the data who are inactive
SELECT 
    e.user_id, 
	e.course_id, 
	e.status
FROM LMS.Enrollments e
WHERE e.status = 'inactive';


