----------procedure to view particular student score in given quiz_id

CREATE OR REPLACE PROCEDURE instructor_user_score(
    c_instructor_id INSTRUCTOR_TABLE.instructor_id%type,
    c_user_id USERS_TABLE.user_id%type
    ) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('User Id: ' || c_user_id);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    FOR inst IN (SELECT * FROM SCHEDULE_TABLE WHERE instructor_id = c_instructor_id) 
    LOOP
        FOR res IN (SELECT * FROM RESULTS_TABLE WHERE quiz_id = inst.quiz_id)
        LOOP
            IF (res.user_id = c_user_id) THEN
                DBMS_OUTPUT.PUT_LINE ('Quiz Id: ' || res.quiz_id ||', Score: ' || res.score || ', Quiz result: ' || res.QUIZ_RESULT);
            END IF;
        END LOOP;
    END LOOP;
END;

BEGIN
    instructor_user_score('i20240610034809365', 'u20240610034852694');
END;
