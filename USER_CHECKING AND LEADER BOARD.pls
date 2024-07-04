BEGIN
    INSERT INTO RESULTS_TABLE VALUES ('s'||generate_id, 'u20240610034852689', 'qz20240610085145576', 87, 'PASS', SYSTIMESTAMP);
    INSERT INTO RESULTS_TABLE VALUES ('s'||generate_id, 'u20240610034852692', 'qz20240610085145576', 45, 'PASS', SYSTIMESTAMP);
    INSERT INTO RESULTS_TABLE VALUES ('s'||generate_id, 'u20240610034852694', 'qz20240610085145576', 25, 'FAIL', SYSTIMESTAMP);
    INSERT INTO RESULTS_TABLE VALUES ('s'||generate_id, 'u20240610034852696', 'qz20240610085145576', 10, 'FAIL', SYSTIMESTAMP);
    INSERT INTO RESULTS_TABLE VALUES ('s'||generate_id, 'u20240610034852698', 'qz20240610085145576', 90, 'PASS', SYSTIMESTAMP);
    INSERT INTO RESULTS_TABLE VALUES ('s'||generate_id, 'u20240610034852700', 'qz20240610085145576', 65, 'PASS', SYSTIMESTAMP);
END;

SELECT * FROM SCHEDULE_TABLE;
SELECT * FROM RESULTS_TABLE WHERE quiz_id = 'qz20240621053109423' AND USER_ID = 'u20240610034852694';

-- Procedure to check quiz status of a particular student

CREATE OR REPLACE PROCEDURE student_quiz_status (
    c_user_id IN users_table.user_id%type,
    c_quiz_id IN quiz_table.quiz_id%type
    ) IS 
    user_found BOOLEAN := FALSE;
BEGIN
    FOR i IN (SELECT * FROM RESULTS_TABLE WHERE quiz_id = c_quiz_id)
    LOOP
        -- DBMS_OUTPUT.PUT_LINE(i.user_id);
        IF c_user_id = i.user_id THEN
            user_found := TRUE;
            DBMS_OUTPUT.PUT_LINE('User: ' || c_user_id || ' **has attempted** the quiz: ' || c_quiz_id);
            EXIT;
        END IF;
    END LOOP;

    IF NOT user_found THEN
        DBMS_OUTPUT.PUT_LINE('User: ' || c_user_id || ' **has not attempted** the quiz: ' || c_quiz_id);
    END IF;
END student_quiz_status;

BEGIN
    student_quiz_status('u20240610034852694', 'qz20240621053109423');
END;

BEGIN
    student_quiz_status('u20240610034852689', 'qz20240610085145576');
END;

DROP PROCEDURE quiz_wise_leaderboard;
DROP PROCEDURE quiz_all_leaderboard;

-- QUIZ LEADERBOARD FOR SPECIFIC QUIZ_ID
CREATE OR REPLACE PROCEDURE quiz_wise_leaderboard(
    c_quiz_id IN RESULTS_TABLE.quiz_id%type
    ) IS
     counter NUMBER := 0;
    quiz_cur EXCEPTION;
BEGIN
    FOR q IN (SELECT DISTINCT quiz_id FROM RESULTS_TABLE)
    LOOP
        --  DBMS_OUTPUT.PUT_LINE('Quiz ID: ' || q.quiz_id);
        IF q.quiz_id = c_quiz_id THEN
            counter := counter + 1;
            DBMS_OUTPUT.PUT_LINE('Quiz ID: ' || q.quiz_id);
            DBMS_OUTPUT.PUT_LINE('-----------------------------------');

            FOR user_score IN (
                SELECT r.user_id, r.score
                FROM RESULTS_TABLE r
                WHERE r.quiz_id = c_quiz_id
                ORDER BY r.score DESC
                FETCH FIRST 10 ROWS ONLY
            ) LOOP
                DBMS_OUTPUT.PUT_LINE('User: ' || user_score.user_id || ', Score: ' || user_score.score);
            END LOOP;
        END IF;
     END LOOP;

     IF counter <1 THEN
        RAISE quiz_cur;
     END IF;
EXCEPTION
    WHEN quiz_cur THEN
        DBMS_OUTPUT.PUT_LINE('Quiz ID: ' || c_quiz_id ||' is not found');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('OTHER EXCPETIONS found. SQLERR: ' || SQLERRM ||', SQLCODE: '|| SQLCODE);
END;

BEGIN
    quiz_wise_leaderboard('qz20240621053109423');
END;

-- QUIZ LEADERBOARD FOR ALL QUIZZES
CREATE OR REPLACE PROCEDURE quiz_all_leaderboard IS
BEGIN
    FOR quiz IN (SELECT DISTINCT quiz_id FROM RESULTS_TABLE) LOOP
        DBMS_OUTPUT.PUT_LINE('Quiz ID: ' || quiz.quiz_id);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');

        FOR user_score IN (
            SELECT r.user_id, r.score
            FROM RESULTS_TABLE r
            WHERE r.quiz_id = quiz.quiz_id
            ORDER BY r.score DESC
            FETCH FIRST 10 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('User: ' || user_score.user_id || ' Score: ' || user_score.score);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;

BEGIN
    quiz_all_leaderboard;
END;

-- OVERALL LEADERBOARD--------------
CREATE OR REPLACE PROCEDURE overall_leaderboard IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('STUDENTS LEADERBOARD');
    DBMS_OUTPUT.PUT_LINE('--------------------------');

    FOR i IN (
        SELECT user_id, SUM(score) AS total_score
        FROM RESULTS_TABLE
        GROUP BY user_id
        ORDER BY total_score DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('User Id: '|| i.user_id || ', Total Score: ' || i.total_score);
    END LOOP;
END;

BEGIN
   overall_leaderboard;
END;



SELECT * FROM TOPICS_TABLE;


