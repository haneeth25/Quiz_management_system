select * from tabs;
drop table quiz_table;
desc instructor_group;

CREATE TABLE quiz_table(
        quiz_id VARCHAR2(50),
        question_id VARCHAR2(50),
        PRIMARY KEY (quiz_id, question_id),
        FOREIGN KEY (question_id) REFERENCES QUESTIONS_TABLE(question_id),
        FOREIGN KEY (quiz_id) REFERENCES SCHEDULE_TABLE(quiz_id)
);
drop table quiz_table cascade constraints;

CREATE TABLE topic_question_table (
    topic_id VARCHAR2(50),
    question_id VARCHAR2(50),
    PRIMARY KEY(topic_id, question_id),
    FOREIGN KEY (question_id) REFERENCES  QUESTIONS_TABLE(question_id),
    FOREIGN KEY (topic_id) REFERENCES TOPICS_TABLE(topic_id)
);
drop table topic_question_table cascade constraints;

CREATE TABLE results_table(
    score_id VARCHAR2(50),
    user_id VARCHAR2(50) NOT NULL,
    quiz_id VARCHAR2(50) NOT NULL,
    score NUMBER  NOT NULL,
    quiz_result VARCHAR2(4) NOT NULL,
    submit_time timestamp NOT NULL,
    PRIMARY KEY(score_id),
    FOREIGN KEY(user_id) REFERENCES users_table(user_id),
    FOREIGN KEY(quiz_id) REFERENCES schedule_table(quiz_id)
);
DROP TABLE RESULTS_TABLE cascade constraints;

select * from questions_table;
select * from topic_question_table order by topic_id;

BEGIN
    INSERT INTO topic_question_table VAlUES ('t2','q1');
    INSERT INTO topic_question_table VAlUES ('t1','q2');
    INSERT INTO topic_question_table VAlUES ('t3','q3');
    INSERT INTO topic_question_table VAlUES ('t2','q4');
    INSERT INTO topic_question_table VAlUES ('t3','q5');
    INSERT INTO topic_question_table VAlUES ('t4','q6');
    INSERT INTO topic_question_table VAlUES ('t2','q7');
    INSERT INTO topic_question_table VAlUES ('t3','q8');
    INSERT INTO topic_question_table VAlUES ('t4','q9');
    INSERT INTO topic_question_table VAlUES ('t2','q10');
    INSERT INTO topic_question_table VAlUES ('t3','q11');
    INSERT INTO topic_question_table VAlUES ('t4','q12');
    INSERT INTO topic_question_table VAlUES ('t2','q13');
    INSERT INTO topic_question_table VALUES ('t3', 'q14');
END;

BEGIN
    INSERT INTO topic_question_table VALUES('t1','q15');
    INSERT INTO topic_question_table VALUES('t1','q16');
    INSERT INTO topic_question_table VALUES('t1','q17');
    INSERT INTO topic_question_table VALUES('t1','q18');
    INSERT INTO topic_question_table VALUES('t1','q19');
    INSERT INTO topic_question_table VALUES('t5','q21');
    INSERT INTO topic_question_table VALUES('t5','q22');
    INSERT INTO topic_question_table VALUES('t5','q23');
    INSERT INTO topic_question_table VALUES('t5','q24');
    INSERT INTO topic_question_table VALUES('t5','q25');
END;

BEGIN
    INSERT INTO topic_question_table VALUES('t4','q3');
    INSERT INTO topic_question_table VALUES('t3','q9');
    INSERT INTO topic_question_table VALUES('t3','q13');
END;

select * from tabs;
