-- ---------Instructor table

CREATE TABLE instructor_table (
    instructor_id VARCHAR2(10) PRIMARY KEY NOT NULL,
    instructor_name VARCHAR2(20) NOT NULL,
    instructor_number VARCHAR2(13) NOT NULL,
    instructor_email VARCHAR2(50) NOT NULL CHECK (REGEXP_LIKE(instructor_email, '^[a-zA-Z0-9]+@[a-z]+\.[a-z]{2,}$'))
);

DROP TABLE instructor_table;
CREATE SEQUENCE instructor_sequence;

BEGIN
    INSERT INTO instructor_table VALUES ('i' || TO_CHAR(instructor_sequence.NEXTVAL), 'poojitha', '9876543210', 'poojabatchu15@gmail.com');
    INSERT INTO instructor_table VALUES ('i' || TO_CHAR(instructor_sequence.NEXTVAL), 'vivek', '9876543210', 'vivekshonti3@gmail.com');
    INSERT INTO instructor_table VALUES ('i' || TO_CHAR(instructor_sequence.NEXTVAL), 'haneeth', '9876543210', 'haneeth00@gmail.com');
    INSERT INTO instructor_table VALUES ('i' || TO_CHAR(instructor_sequence.NEXTVAL), 'satya', '9876543210', 'satyabrattemp@gmail.com');
END;

SELECT * FROM instructor_table;

-------------------- USERS TABLE

CREATE TABLE users_table (
    user_id VARCHAR2(10) PRIMARY KEY NOT NULL,
    user_name VARCHAR2(20) NOT NULL,
    user_dob DATE NOT NULL,
    user_number VARCHAR2(13) NOT NULL,
    user_email VARCHAR2(50) NOT NULL CHECK (REGEXP_LIKE(user_email, '^[a-zA-Z0-9]+@[a-z]+\.[a-z]{2,}$'))
);

DROP TABLE users_table;
CREATE SEQUENCE user_sequence START WITH 1;
DROP SEQUENCE user_sequence;

BEGIN
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'John Doe', TO_DATE('1990-05-15', 'YYYY-MM-DD'), '1234567890', 'johndoe@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Jane Smith', TO_DATE('1985-08-20', 'YYYY-MM-DD'), '0987654321', 'janesmith@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Alice Johnson', TO_DATE('1995-12-10', 'YYYY-MM-DD'), '5678901234', 'alicejohnson@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Michael Johnson', TO_DATE('1980-07-25', 'YYYY-MM-DD'), '444555666', 'michaeljohnson@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Emily Davis', TO_DATE('1992-03-18', 'YYYY-MM-DD'), '777888999', 'emilydavis@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'David Brown', TO_DATE('1978-11-30', 'YYYY-MM-DD'), '111222333', 'davidbrown@example.com'); 
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Sarah Wilson', TO_DATE('1987-09-05', 'YYYY-MM-DD'), '666333111', 'sarahwilson@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Matthew Taylor', TO_DATE('1993-06-22', 'YYYY-MM-DD'), '555444333', 'matthewtaylor@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Emma Martinez', TO_DATE('1989-04-14', 'YYYY-MM-DD'), '987654321', 'emmamartinez@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'James Anderson', TO_DATE('1983-01-08', 'YYYY-MM-DD'), '321654987', 'jamesanderson@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Olivia Thomas', TO_DATE('1996-10-02', 'YYYY-MM-DD'), '456123789', 'oliviathomas@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Daniel Jackson', TO_DATE('1981-08-12', 'YYYY-MM-DD'), '963258741', 'danieljackson@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Ava White', TO_DATE('1994-05-30', 'YYYY-MM-DD'), '159357852', 'avawhite@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Liam Garcia', TO_DATE('1986-02-20', 'YYYY-MM-DD'), '258369147', 'liamgarcia@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Charlotte Lee', TO_DATE('1990-11-15', 'YYYY-MM-DD'), '753951456', 'charlottelee@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Noah Hernandez', TO_DATE('1984-07-10', 'YYYY-MM-DD'), '369258147', 'noahhernandez@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Sophia Nguyen', TO_DATE('1997-03-25', 'YYYY-MM-DD'), '852147963', 'sophianguyen@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Logan Kim', TO_DATE('1982-09-03', 'YYYY-MM-DD'), '951753258', 'logankim@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Amelia Patel', TO_DATE('1991-06-12', 'YYYY-MM-DD'), '147852369', 'ameliapatel@example.com');
    INSERT INTO USERS_TABLE VALUES ('u' || TO_CHAR(user_sequence.NEXTVAL), 'Benjamin Smith', TO_DATE('1988-04-05', 'YYYY-MM-DD'), '321987654', 'benjaminsmith@example.com');
END;

TRUNCATE TABLE users_table

SELECT * FROM users_table;

------------------------- TOPICS TABLE

CREATE TABLE topics_table (
    topic_id VARCHAR2(10) PRIMARY KEY,
    topic_name VARCHAR2(20) NOT NULL
);

DROP TABLE topics_table;
CREATE SEQUENCE topic_sequence START WITH 1;

BEGIN
    INSERT INTO TOPICS_TABLE VALUES ('t' || TO_CHAR(topic_sequence.NEXTVAL), 'Mathematics');
    INSERT INTO TOPICS_TABLE VALUES ('t' || TO_CHAR(topic_sequence.NEXTVAL), 'Science');
    INSERT INTO TOPICS_TABLE VALUES ('t' || TO_CHAR(topic_sequence.NEXTVAL), 'History');
    INSERT INTO TOPICS_TABLE VALUES ('t' || TO_CHAR(topic_sequence.NEXTVAL), 'Literature');
    INSERT INTO TOPICS_TABLE VALUES ('t' || TO_CHAR(topic_sequence.NEXTVAL), 'Programming');
END;
SELECT * FROM TOPICS_TABLE;

----------- checking current user procedure

create or replace function user_id return varchar2 is
    l_username VARCHAR2(100);
BEGIN
    l_username := APEX_APPLICATION.g_user;
    return l_username;
END;
 
create or replace procedure checking is
    b varchar2(100);
begin
    b := user_id;
    dbms_output.put_line(b);
end;
 
begin   
    checking;
end;
