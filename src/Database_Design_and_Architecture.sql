Use LMS

--Propose schema changes to support course completion certificates.
CREATE TABLE LMS.Course_Certificates (
    certificate_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    issued_at DATETIME NOT NULL DEFAULT GETDATE(),
    certificate_url VARCHAR(500) NULL,  
    UNIQUE (user_id, course_id),        
    FOREIGN KEY (user_id) REFERENCES LMS.Users(user_id),
    FOREIGN KEY (course_id) REFERENCES LMS.Courses(course_id)
)

--37)Describe how you would track video progress efficiently at scale.
--Save only the user’s latest watched position for each video, updating
--it occasionally instead of logging every second.

--38)Discuss normalization versus denormalization trade-offs for user activity data.
--Normalization keeps user activity data clean and consistent, while denormalization 
--makes analytics faster at the cost of extra storage and possible inconsistencies.

