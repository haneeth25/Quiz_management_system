---------- creating questions procedure --------

CREATE OR REPLACE PROCEDURE creating_questions(
    c_question IN questions_table.question%TYPE, 
    c_answer IN questions_table.answer%TYPE, 
    c_explanation IN questions_table.explanation%TYPE, 
    c_difficulty_name IN difficulty_table.difficulty_name%TYPE, 
    c_topic_name IN topics_table.topic_name%TYPE,  
    c_format_name IN question_format_table.format_name%TYPE,
    c_options IN questions_table.options%TYPE
    ) IS
    question_id questions_table.question_id%TYPE;
    temp_topic_id VARCHAR2(10);
    temp_difficulty_id varchar2(10);
    temp_format_id VARCHAR2(10);
    creating_question_exception EXCEPTION;
    exception_column VARCHAR2(20);
    short_answer_exception EXCEPTION;
    multiple_choice_exception EXCEPTION;
    true_false_exception EXCEPTION;
    answer_table NestedTableType;
BEGIN
    IF c_answer IS NULL THEN
        exception_column := 'answer';
        RAISE creating_question_exception;
    ELSIF c_explanation IS NULL THEN
        exception_column := 'explanation';
        RAISE creating_question_exception;
    ELSIF c_difficulty_name IS NULL THEN 
        exception_column := 'difficulty_name';
        RAISE creating_question_exception;
    ELSIF c_topic_name IS NULL THEN
        exception_column := 'topic_name';
        RAISE creating_question_exception;
    ELSIF c_format_name IS NULL THEN
        exception_column := 'format_name';
        RAISE creating_question_exception;
    ELSIF c_options IS NULL THEN
        exception_column := 'options';
        RAISE creating_question_exception;
    END IF;

    answer_table := string_slicing(c_options);
    question_id := 'q' || generate_id;

    SELECT format_id INTO temp_format_id FROM question_format_table WHERE format_name = c_format_name;

    IF temp_format_id = 'f1' AND answer_table.COUNT != 1 THEN
        RAISE short_answer_exception;
    ELSIF temp_format_id = 'f2' AND answer_table.COUNT != 4 THEN
        RAISE multiple_choice_exception;
    ELSIF temp_format_id = 'f3' AND answer_table.COUNT != 2 THEN 
        RAISE true_false_exception;
    END IF;

    SELECT difficulty_id INTO temp_difficulty_id FROM difficulty_table WHERE difficulty_name = c_difficulty_name;
    SELECT topic_id INTO temp_topic_id FROM TOPICS_TABLE WHERE topic_name = c_topic_name;

    DBMS_OUTPUT.PUT_LINE('temp_difficulty_id: ' || temp_difficulty_id || ', temp_topic_id: '|| temp_topic_id || ', temp_format_id: ' || temp_format_id);
    DBMS_OUTPUT.PUT_LINE('question id: ' || question_id);

    INSERT INTO questions_table VALUES (question_id, c_question, c_answer, c_explanation, temp_difficulty_id, temp_format_id, c_options);
    INSERT INTO topic_question_table VALUES (temp_topic_id, question_id);
    DBMS_OUTPUT.PUT_LINE('successsfully inserted the questions in QUESTIONS_TABLE..!!');

EXCEPTION
    WHEN creating_question_exception THEN
        DBMS_OUTPUT.PUT_LINE(exception_column || ' cannot be NULL**');
    WHEN short_answer_exception THEN
        DBMS_OUTPUT.PUT_LINE('Please mention option as ''-'' for SHORT ANSWER format');
    WHEN multiple_choice_exception THEN 
        DBMS_OUTPUT.PUT_LINE('Please give 4 options for MULTIPLE CHOICE format');
    WHEN true_false_exception THEN
        DBMS_OUTPUT.PUT_LINE('please give 2 options as 1. TRUE and 2. FALSE for TRUE/FALSE format');
END;

BEGIN
    -- question, correct answer, explanation, difficulty level, topic name, format name, options 
    creating_questions('What is the full form of SQL?', 'Structured Query Language', 'SQL stands for Structured Query Language', 'Easy', 'Programming', 'Short Answer', 'KSF,JEOIWJ');
END;

BEGIN
    -- creating_questions('What is the extension to save a java file?', NULL, 'Extension for java file is .java', 'Medium', 'Programming', 'Multiple Choice', '(a).jv ,(b).ja ,(c).java ,(d).jav');
    creating_questions('What is the extension to save a java file?', '.java', 'Extension for java file is .java', 'Medium', 'Programming', 'Multiple Choice', '(a).jv ,(b).ja ,(c).java');
END;

BEGIN
    creating_questions('The speed of light in a vacuum is constant and does not change regardless of the observers frame of reference.', 'true', 'According to Einsteins theory of relativity, the speed of light in a vacuum remains the same for all observers, regardless of their motion relative to the light source.', 'Hard', 'Science', 'True/False', '1.True,2.False, euh');
END;

SELECT * FROM questions_table;
SELECT * FROM topic_question_table;
