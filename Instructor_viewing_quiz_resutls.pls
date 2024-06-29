CREATE OR REPLACE FUNCTION instructor_view_quiz_results (f_instructor_id instructor_table.instructor_id%TYPE, f_quiz_id quiz_table.quiz_id%TYPE) RETURN VARCHAR2 IS

v_instructor_email instructor_table.instructor_email%TYPE;
v_instructor_present BOOLEAN := FALSE;

v_quiz_id quiz_table.quiz_id%TYPE;

CURSOR v_results IS SELECT * FROM results_table;

-- Custom exceptions
v_instructor_not_found_exception EXCEPTION;
v_quiz_not_found_exception EXCEPTION;


BEGIN
    BEGIN
        SELECT INSTRUCTOR_EMAIL INTO v_instructor_email FROM instructor_table WHERE INSTRUCTOR_ID = f_instructor_id;

        IF v_instructor_email = LOWER(is_instructor) THEN
            v_instructor_present := TRUE;
        ELSE
            RETURN 'Instructor details does not match - Please use correct detials ';
        END IF;
 
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                RAISE v_instructor_not_found_exception;
    END;

    IF v_instructor_present THEN
        -- Check if quiz is present in schedule table and that is scheduled by the current instructor(Instructor who is trying to fetch results)
        BEGIN
            SELECT QUIZ_ID INTO v_quiz_id FROM schedule_table WHERE INSTRUCTOR_ID = f_instructor_id AND QUIZ_ID = f_quiz_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE v_quiz_not_found_exception;
        END;

        FOR result_details IN v_results LOOP 
            IF result_details.quiz_id = f_quiz_id THEN
                dbms_output.put_line(result_details.user_id||' || '||result_details.score||' || '||result_details.quiz_result);
            END IF;
        END LOOP;
        
    END IF;

    RETURN 'Success';

    EXCEPTION
        WHEN v_instructor_not_found_exception THEN
            RETURN 'You are not a instructor - Quiz results can not be fetched!';
        WHEN v_quiz_not_found_exception THEN
            RETURN 'Quiz not found/You did not schedule this quiz, Please make sure Quiz ID entered is correct and it belongs to you';
END;

DECLARE
    vv varchar2(100);
BEGIN
    vv := instructor_view_quiz_results('i20240610034809363','qz20240610085145576');
    dbms_output.put_line(vv);
END;
