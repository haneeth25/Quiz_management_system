--------------------------- GET ANSWER FUNCTION ------------------- 
CREATE OR REPLACE FUNCTION get_answer(
    c_question_id QUESTIONS_TABLE.question_id%type
    ) 
    RETURN QUESTIONS_TABLE.answer%type AS
    c_answer  QUESTIONS_TABLE.answer%type;
BEGIN
    SELECT answer INTO c_answer FROM QUESTIONS_TABLE WHERE question_id = c_question_id;
    RETURN c_answer;
END;

-------------------- GET OPTIONS FUCNTION ---------------
CREATE OR REPLACE FUNCTION get_options (
    c_question_id QUESTIONS_TABLE.question_id%type
    ) 
    RETURN QUESTIONS_TABLE.options%type AS
    c_options QUESTIONS_TABLE.options%type;
BEGIN
    SELECT options INTO c_options FROM QUESTIONS_TABLE WHERE question_id = c_question_id;
    RETURN c_options;
END;

--------------------- GET exam result ------------------
CREATE OR REPLACE FUNCTION get_result (
    score IN NUMBER
    ) RETURN VARCHAR2 AS
    res VARCHAR2(4) := 'PASS';
BEGIN
    IF score <= 3 THEN
        res := 'FAIL';
    END IF;
    RETURN res;
END;

-------------------- F1. SHORT ANSWER --------------
CREATE OR REPLACE FUNCTION f1_format_answer(
    question_id QUESTIONS_TABLE.question_id%type
    ) RETURN VARCHAR2 AS
    user_answer VARCHAR2(30);
    ques_answer QUESTIONS_TABLE.answer%type;
    random_value NUMBER;
    return_ans VARCHAR2(30);
BEGIN
    ques_answer := get_answer(question_id);
    user_answer := generate_words(10);

    random_value := TRUNC(DBMS_RANDOM.VALUE(1, 3));
    return_ans := CASE random_value
                    WHEN 1 THEN ques_answer
                    WHEN 2 THEN user_answer
                   END;
    RETURN return_ans;
END;

-------------------- F2. MCQS ----------------------
CREATE OR REPLACE FUNCTION f2_format_answer(
    question_id QUESTIONS_TABLE.question_id%type
    ) RETURN VARCHAR2 AS
    user_option VARCHAR2(30);
    ques_options QUESTIONS_TABLE.OPTIONS%type;
    random_value NUMBER;
    return_option VARCHAR2(30);
    options_table NestedTableType := NestedTableType();
BEGIN
    ques_options := get_options(question_id);
    options_table := string_slicing(ques_options);

    random_value := TRUNC(DBMS_RANDOM.VALUE(1, 5));
    return_option := CASE random_value
                            WHEN 1 THEN options_table(1)
                            WHEN 2 THEN options_table(2)
                            WHEN 3 THEN options_table(3)
                            WHEN 4 THEN options_table(4)
                     END;
    RETURN SUBSTR(return_option, 3);
END;

--------------------- F3. TRUE / FALSE
CREATE OR REPLACE FUNCTION f3_format_answer (
    question_id QUESTIONS_TABLE.question_id%type
    ) RETURN VARCHAR2 AS
    user_option VARCHAR2(30);
    ques_options QUESTIONS_TABLE.answer%type;
    random_value NUMBER;
    return_option VARCHAR2(30);
    options_table NestedTableType := NestedTableType();
BEGIN
    ques_options := get_options(question_id);
    options_table := string_slicing(ques_options);

    random_value := TRUNC(DBMS_RANDOM.VALUE(1, 3));
    return_option := CASE random_value
                            WHEN 1 THEN options_table(1)
                            WHEN 2 THEN options_table(2)
                     END;
    RETURN SUBSTR(return_option, 3);
END;

--------------------------- UPLOAD ANSWERS PROCEDURE ---------------------

CREATE OR REPLACE PROCEDURE upload_answers(
    c_quiz_id IN QUIZ_TABLE_TEMP.quiz_id%type
    ) AS
    c_group_id SCHEDULE_TABLE_TEMP.GROUPS_ID%type;
    know_format VARCHAR2(30);
    user_answer VARCHAR2(30);
    question_answer QUESTIONS_TABLE.question_id%type;
    ques_format_id QUESTIONS_TABLE.format_id%type;
    score_counter NUMBER;
    response_id VARCHAR2(30);
    quiz_result VARCHAR2(4);
BEGIN
    SELECT GROUPS_ID INTO c_group_id FROM SCHEDULE_TABLE WHERE QUIZ_ID = c_quiz_id;

    FOR usr IN (SELECT * FROM GROUPS_TABLE WHERE GROUPS_ID = c_group_id) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('USER ID: ' || usr.user_id);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');

        score_counter := 0;
        response_id := 'r'||generate_id;
        -- DBMS_OUTPUT.PUT_LINE(response_id||', ' || usr.user_id ||', ' || c_quiz_id);
        INSERT INTO USER_RESPONSE_DETAILS VALUES (response_id, usr.user_id, c_quiz_id);

        FOR ques IN (SELECT * FROM QUIZ_TABLE WHERE QUIZ_ID = c_quiz_id)
        LOOP
            SELECT format_id INTO ques_format_id FROM QUESTIONS_TABLE WHERE question_id = ques.QUESTION_ID;
            -- DBMS_OUTPUT.PUT_LINE(ques_format_id);
            question_answer := get_answer(ques.question_id);
            
            IF ques_format_id = 'f1' THEN
                user_answer := f1_format_answer(ques.question_id);
            ELSIF ques_format_id = 'f2' THEN
                user_answer := f2_format_answer(ques.question_id);
            ELSIF ques_format_id = 'f3' THEN
                user_answer := f3_format_answer(ques.question_id);
            END IF;

            -- DBMS_OUTPUT.PUT_LINE('question_answer: ' || question_answer ||', user_answer: ' || user_answer);
            -- DBMS_OUTPUT.PUT_LINE(response_id ||', ' || ques.question_id ||', ' || user_answer);

            INSERT INTO USER_RESPONSE_TABLE VALUES (response_id, ques.question_id, user_answer);
            
            IF question_answer = user_answer THEN
                score_counter := score_counter +1;
            END IF;

        END LOOP;
            quiz_result := get_result(score_counter);
            DBMS_OUTPUT.PUT_LINE('score: ' || score_counter || ', score result: ' || quiz_result);
            DBMS_OUTPUT.PUT_LINE('');

            INSERT INTO RESULTS_TABLE VALUES ('s'||generate_id, usr.user_id, c_quiz_id, score_counter, quiz_result, SYSTIMESTAMP);
    END LOOP;
END;

BEGIN
    upload_answers('qz20240610085218997');
    -- DBMS_OUTPUT.PUT_LINE();
    -- DBMS_OUTPUT.PUT_LINE(get_result(2));
END;
