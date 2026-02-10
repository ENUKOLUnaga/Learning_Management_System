use LMS

--21)Suggest appropriate indexes for improving performance of:
--Course dashboards
--User activity analytics
-- Fast accessing of enrollments by course
CREATE INDEX idx_enrollments_course ON LMS.Enrollments(course_id);
-- Fast join & filtering for lessons
CREATE INDEX idx_lessons_course ON LMS.Lessons(course_id);
-- For assessments shown inside course dashboard
CREATE INDEX idx_assessments_course ON LMS.Assessments(course_id);
-- Used if dashboard shows submissions per course
CREATE INDEX idx_submissions_assessment 
    ON LMS.Assessment_Submissions(assessment_id);
-- If dashboard filters by date  based onrecent enrollments
CREATE INDEX idx_enrollments_date ON LMS.Enrollments(enrolled_at);
--find activity per user fast
CREATE INDEX idx_user_activity_user ON LMS.User_Activity(user_id);
--Sorting 
CREATE INDEX idx_user_activity_time ON LMS.User_Activity(activity_time);

--22)Identify potential performance bottlenecks in queries involving user activity.
--Most performance issues come from full table scans, missing indexes on (user_id, activity_time), 
--and date conversions or window functions.

--23)Explain how you would optimize queries when the user_activity table grows to millions of rows.
--By using proper indexing, partitioning, computed columns, pre-aggregated tables, and archival 
--strategies to keep User_Activity queries fast even when the table grows to millions of rows.

--24)Describe scenarios where materialized views would be useful for this schema.
--Materialized views are most useful, when generating heavy aggregated dashboards, activity 
--analytics, and performance reports that repeatedly query large tables like User_Activity and Assessment_Submissions.

--25)Explain how partitioning could be applied to user_activity.
--Partitioning User_Activity by activity_time (monthly or yearly) 
--dramatically improves performance, simplifies archiving, reduces
--index sizes, and speeds up date-filtered analytics queries.