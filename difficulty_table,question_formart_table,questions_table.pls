-- Table to store difficulty_levels.
create table difficulty_table(
    difficulty_id varchar2(50),
    difficulty_name varchar2(20) not null,
    primary key (difficulty_id)
);
drop table difficulty_table cascade constraints;


-- Table to store question_formats.
create table question_format_table(
    format_id varchar2(50),
    format_name varchar2(20) not null,
    primary key (format_id)
);
drop table question_format_table cascade constraints;


-- Table to store questions.
create table questions_table(
    question_id varchar2(50),
    question clob not null,
    answer varchar2(50) not null,
    explanation clob not null,
    difficulty_id varchar2(20) not null,
    format_id varchar2(20) not null,
    options varchar2(100) not null,
    primary key(question_id),
    FOREIGN KEY (difficulty_id) REFERENCES difficulty_table(difficulty_id),
    FOREIGN KEY (format_id) REFERENCES question_format_table(format_id)
);


drop table questions_table cascade constraints;

select * from tab;
desc users_table;

-- Inserting difficulty types;
begin
    insert into difficulty_table values('d1','Easy');
    insert into difficulty_table values('d2','Medium');
    insert into difficulty_table values('d3','Hard');
end;
select * from difficulty_table;
delete from  difficulty_table;



create table user_response_details (
    user_response_id varchar2(10),
    user_id varchar2(10) not null,
    quiz_id varchar2(10) not null,
    primary key(user_response_id),
    FOREIGN KEY (user_id) REFERENCES users_table(user_id),
    FOREIGN KEY (quiz_id) REFERENCES schedule_table(quiz_id)
);


create table user_response_table (
    user_response_id varchar2(10),
    question_id varchar2(10),
    user_answer varchar2(50) not null,
    primary key(user_response_id,question_id),
    FOREIGN KEY (question_id) REFERENCES questions_table(question_id),
    FOREIGN KEY (user_response_id) REFERENCES user_response_details(user_response_id)
);

-- Inserting question_format_types
begin
    insert into question_format_table values('f1','Short Answer');
    insert into question_format_table values('f2','Multiple Choice');
    insert into question_format_table values('f3','True/False');
end;
select * from question_format_table;
delete from question_format_table;

-- Inserting into questions
create sequence question_number;
drop sequence question_number;
begin
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the chemical symbol for oxygen?', 'O', 'The chemical symbol for oxygen is O.', 'd1', 'f1', '_');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the square root of 64?', '8', 'The square root of 64 is 8.', 'd1', 'f1', '_');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Who is the current president of the United States?', 'Joe Biden', 'Joe Biden is the current president of the United States.', 'd3', 'f1', '_');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the chemical symbol for gold?', 'Au', 'The chemical symbol for gold is Au.', 'd2', 'f1', '_');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the capital of Japan?', 'Tokyo', 'The capital of Japan is Tokyo.', 'd2', 'f1', '_');
 
-- F2 Questions (MCQs)
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Who wrote "The Great Gatsby"?', 'F. Scott Fitzgerald', 'F. Scott Fitzgerald wrote "The Great Gatsby".', 'd2', 'f2', '1.F. Scott Fitzgerald,2.Ernest Hemingway,3.J.K. Rowling,4.Jane Austen');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the chemical symbol for carbon?', 'C', 'The chemical symbol for carbon is C.', 'd1', 'f2', '1.H,2.C,3.O,4.F');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the largest planet in our solar system?', 'Jupiter', 'Jupiter is the largest planet in our solar system.', 'd1', 'f2', '1.Earth,2.Venus,3.Mars,4.Jupiter');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Who composed the "Moonlight Sonata"?', 'Ludwig van Beethoven', 'Ludwig van Beethoven composed the "Moonlight Sonata".', 'd3', 'f2', '1.Ludwig van Beethoven,2.Wolfgang Amadeus Mozart,3.Johann Sebastian Bach,4.Frederic Chopin');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the chemical symbol for gold?', 'Au', 'The chemical symbol for gold is Au.', 'd2', 'f2', '1.Ag,2.Au,3.Al,4.Ar');
 
-- F3 Format
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Paris is the capital of France.', 'True', 'Paris is indeed the capital of France.', 'd1', 'f3', '1.True,2.False');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'The sun rises in the west.', 'False', 'The sun rises in the east, not the west.', 'd3', 'f3', '1.True,2.False');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Water boils at 100 degrees Celsius.', 'True', 'Water boils at 100 degrees Celsius at sea level.', 'd1', 'f3', '1.True,2.False');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Mount Everest is the tallest mountain in the world.', 'True', 'Mount Everest is indeed the tallest mountain above sea level.', 'd2', 'f3', '1.True,2.False');
end;

begin
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the value of pi (π) to two decimal places?', '3.14', 'Pi (π) is approximately equal to 3.14.', 'd1', 'f1', '_');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the formula to find the area of a rectangle?', 'Length x Width', 'The area of a rectangle is calculated by multiplying its length by its width.', 'd1', 'f2', '1.Length x Width,2.Pi x Radius,3.Base x Height,4.Side x Side');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Which of the following is a prime number?', '7', 'A prime number is a natural number greater than 1 that has no positive divisors other than 1 and itself.', 'd3', 'f2', '1.4,2.6,3.7,4.9');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'The square root of 64 is 8.', 'True', 'The square root of 64 is indeed 8.', 'd2', 'f3', '1.True,2.False');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'A right triangle has three equal sides.', 'False', 'A right triangle has one right angle, but its sides can be of different lengths.', 'd1', 'f3', '1.True,2.False');
end;

begin
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What is the output of 5 + 3 * 2 in most programming languages?', '11', 'In most programming languages, multiplication has higher precedence than addition, so 3 * 2 is evaluated first, resulting in 6. Then 5 + 6 equals 11.', 'd1', 'f1', '_');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Which of the following is NOT a programming language?', 'HTML', 'HTML (Hypertext Markup Language) is a markup language used for creating web pages, not a programming language.', 'd2', 'f2', '1.Java,2.Python,3.C++,4.HTML');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'What does CSS stand for?', 'Cascading Style Sheets', 'CSS (Cascading Style Sheets) is a style sheet language used for describing the presentation of a document written in HTML.', 'd3', 'f2', '1.Centralized Style Sheets,2.Cascading Style Sheets,3.Computer Style Sheets,4.Content Style Sheets');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Python is a statically typed language.', 'False', 'Python is dynamically typed, meaning you do not need to declare the type of a variable when you create one.', 'd2', 'f3', '1.True,2.False');
INSERT INTO QUESTIONS_TABLE (QUESTION_ID, QUESTION, ANSWER, EXPLANATION, DIFFICULTY_ID, FORMAT_ID, OPTIONS) VALUES 
    ('q'||to_char(question_number.NEXTVAL), 'Java is an interpreted language.', 'False', 'Java is a compiled language. It is first compiled into bytecode, which can then be executed by the Java Virtual Machine (JVM).', 'd3', 'f3', '1.True,2.False');
end;

select * from questions_table q1 left join topic_question_table t1 on q1.question_id = t1.question_id ;
delete from questions_table;
-- delete from questions_table where question_id in ('q20','q21','q22','q23','q24') ;
-- delete from questions_table;
select * from tab;
select * from TOPICS_TABLE;
desc questions_table;
select t.topic_name,q1.question from TOPIC_QUESTION_TABLE t1 join topics_table t on t.topic_id = t1.topic_id join questions_table q1 on t1.question_id = q1.question_id;
