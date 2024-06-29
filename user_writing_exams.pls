select * from schedule_table;
select * from groups_table where groups_id = 'g2';

/*
    Exception cases?
        - When user enters quiz_id for which he is not allowed to attend.
        - Whne user answering question_id which is not present in that quiz.
        - When user answering for multiple choice, choosing option which is not present
*/


CREATE TABLE user_quiz_temp_data(user_id VARCHAR2(50), quiz_id VARCHAR2(50), time_stamp TIMESTAMP);
select * from user_quiz_temp_data;
delete from user_quiz_temp_data;


-- If user already taken test stop him from taking test again
CREATE OR REPLACE FUNCTION user_views_quiz(f_user_id users_table.user_id%TYPE, f_quiz_id quiz_table.quiz_id%TYPE) RETURN VARCHAR2 IS
    f_question_id questions_table.question_id%TYPE;
    f_question questions_table.question%TYPE;
    f_options questions_table.options%TYPE;
    f_format question_format_table.format_name%TYPE;
    f_time TIMESTAMP;
    f_completion_time schedule_table.completion_time%TYPE;
    f_pass_marks schedule_table.pass_marks%TYPE;
    -- Variable to if the user already taken the quiz
    f_is_user_took_quiz NUMBER;

    cursor f_quiz_view_cursor IS 
        SELECT qz.question_id, q.question, f.format_name, q.options
        FROM quiz_table qz
        JOIN questions_table q ON qz.question_id = q.question_id
        JOIN question_format_table f ON q.format_id = f.format_id
        WHERE qz.quiz_id = f_quiz_id;

    --Check Variables
    f_quiz_id_valid  BOOLEAN := FALSE;
    f_groups_id instructor_group_table.groups_id%TYPE;
    f_user_id_valid users_table.user_id%TYPE;

    --custom exceptions
    f_quiz_not_found_schedule EXCEPTION;
    f_user_not_found_group EXCEPTION;

BEGIN

    SELECT COUNT(*) INTO f_is_user_took_quiz FROM user_response_details WHERE USER_ID = f_user_id AND QUIZ_ID = f_quiz_id;

    IF f_is_user_took_quiz != 0 THEN
        RETURN 'Not allowed to take quiz'||CHR(10)||'You already took this quiz';
    END IF;

    BEGIN
        -- if a users has to view question he must be a part of group, and that group should be in a schedule table in that if he had any quiz
        SELECT GROUPS_ID, COMPLETION_TIME, PASS_MARKS INTO f_groups_id, f_completion_time, f_pass_marks FROM schedule_table WHERE QUIZ_ID = f_quiz_id;
        f_quiz_id_valid := TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            RAISE f_quiz_not_found_schedule;
    END;

    BEGIN
        SELECT USER_ID INTO f_user_id_valid FROM groups_table WHERE GROUPS_ID = f_groups_id AND USER_ID = f_user_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE f_user_not_found_group;
    END;

    f_time := SYSTIMESTAMP + INTERVAL '1' MINUTE * f_completion_time;
    dbms_output.put_line('Exam time: 3OMinutes'||CHR(10)||'Please submit answers by '|| f_time);
    FOR i IN f_quiz_view_cursor LOOP
        dbms_output.put_line(i.question_id||'.'||i.question||CHR(10)||
                             'This question is of '||i.format_name||CHR(10)||'Choose your answer '||
                             i.options||CHR(10)||CHR(10));
    END LOOP;

    INSERT INTO user_quiz_temp_data VALUES(f_user_id, f_quiz_id, f_time, f_pass_marks);

    RETURN 'Success';

EXCEPTION
    WHEN f_quiz_not_found_schedule THEN
        RETURN 'This quiz is not available';
    WHEN f_user_not_found_group THEN
        RETURN 'You are not allowed to take this quiz';
END;

declare
    varr varchar2(100);
begin
    varr := user_views_quiz('u20240610034852694','qz20240610085212650');
    dbms_output.put_line(varr);
end;

BEGIN
    dbms_output.put_line(SYSTIMESTAMP);
end;

declare
    varr varchar2(100);
begin
    varr := user_submit_quiz('q20240610083452574,jjuapndew,q20240610083450922, pavikw','u20240610034852694','qz20240610085212650');
    dbms_output.put_line(varr);
end;



CREATE OR REPLACE FUNCTION user_submit_quiz(f_answers VARCHAR2, f_user_id users_table.user_id%TYPE, f_quiz_id quiz_table.quiz_id%TYPE) RETURN VARCHAR2 IS
    v_quiz_question_answer NestedTableType := NestedTableType();
    v_time_stamp TIMESTAMP;
    v_current_time_stamp TIMESTAMP;
    v_response_id VARCHAR2(50);
    v_store_question_id questions_table.question_id%TYPE;
    v_answer VARCHAR2(100);
    v_score NUMBER := 0;
    v_score_id VARCHAR2(50);
    v_pass_marks schedule_table.pass_marks%TYPE;
    v_quiz_result results_table.quiz_result%TYPE := 'FAIL';

    -- Custom exceptions
    v_not_valid_userquiz EXCEPTION;
    v_not_valid_question EXCEPTION;

BEGIN
    v_current_time_stamp := SYSTIMESTAMP;
    v_score_id :=  's'||generate_id;
    -- Check if the user and quiz are valid
    BEGIN
        SELECT TIME_STAMP, PASS_MARKS INTO v_time_stamp, v_pass_marks FROM user_quiz_temp_data WHERE user_id = f_user_id AND quiz_id = f_quiz_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE v_not_valid_userquiz;
    END;

    -- What should we do (regarding result table), should we update table to failed or not?
    IF v_time_stamp < v_current_time_stamp THEN
        RETURN 'You ran out of time'||CHR(10)||'TEST NOT SUBMITED - FAILED';
    END IF;

    -- Extract answers and process responses
    v_response_id := 'r'||generate_id;

    v_quiz_question_answer := string_slicing(f_answers);

    -- Start a transaction
    BEGIN
        INSERT INTO user_response_details VALUES (v_response_id, f_user_id, f_quiz_id);
        FOR i IN 1..v_quiz_question_answer.COUNT LOOP
            IF MOD(i,2) != 0 THEN 
                v_store_question_id := v_quiz_question_answer(i);
            ELSE
                BEGIN
                    -- Retrieve answer for the question
                    SELECT ANSWER INTO v_answer FROM questions_table WHERE QUESTION_ID = v_store_question_id;
                    -- Compare answer with user response
                    IF v_answer = v_quiz_question_answer(i) THEN
                        v_score := v_score + 1;
                    END IF;
                    -- Insert user response
                    INSERT INTO user_response_table VALUES (v_response_id, v_store_question_id, v_quiz_question_answer(i));
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        dbms_output.put_line('ok ok');
                        -- RAISE v_not_valid_question;
                END;
            END IF;
        END LOOP;
        -- Commit the transaction
        COMMIT;
    EXCEPTION
        WHEN v_not_valid_userquiz THEN
            RETURN 'Test not submitted'||CHR(10)||'Invalid user ID or quiz ID';
        WHEN v_not_valid_question THEN
            RETURN 'Test not submitted'||CHR(10)||'Invalid question ID';
        WHEN OTHERS THEN
            -- Rollback transaction if any error occurs
            ROLLBACK;
            RAISE;
    END;

    -- Deleting stored temp user quiz view data
    DELETE FROM user_quiz_temp_data;

    IF v_score >= v_pass_marks THEN
        v_quiz_result := 'PASS';
    END IF;

    INSERT INTO results_table VALUES (v_score_id, f_user_id, f_quiz_id, v_score,v_quiz_result,v_current_time_stamp);
    -- Return success message
    RETURN 'Test submitted successfully. Score: ' || TO_CHAR(v_score)||CHR(10)||'You are '||v_quiz_result;

END;

