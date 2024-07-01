-- Create the instructor_group table
CREATE TABLE instructor_group_table (
    groups_id VARCHAR2(50) primary key,
    instructor_id VARCHAR2(50),
    FOREIGN KEY (instructor_id) REFERENCES instructor_table(instructor_id)
);

-- Create the groups_table table
CREATE TABLE groups_table (
    groups_id VARCHAR2(50),
    user_id VARCHAR2(50),
    PRIMARY KEY(groups_id, user_id),
    FOREIGN KEY (groups_id) REFERENCES instructor_group_table(groups_id),
    FOREIGN KEY (user_id) REFERENCES users_table(user_id)
);


-- Create the schedule_table
create table schedule_table(
    instructor_id varchar2(50),
    quiz_id varchar2(50) primary key,
    groups_id varchar2(50),
    pass_marks number,
    completion_time number,
    foreign key(instructor_id) references instructor_table(instructor_id),
    foreign key(groups_id) references instructor_group_table(groups_id)
);

drop table instructor_group_table cascade constraints;
drop table schedule_table cascade constraints;
drop table groups_table cascade constraints;

select*from tab;
select*from schedule_table;
select*from groups_table;
select*from instructor_group_table;
