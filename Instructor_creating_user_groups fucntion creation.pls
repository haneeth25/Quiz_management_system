/*
Functon for instructor creating a user group
    1.Check if he is instructor
       -IF TURE then
        1.1. Process user_id(s) for comma seperated string/varchar2 format.
           -IF all the user_id(s) entered present in users_table then
            1.2. create group - assign group_id
                              - insert user_id(s) with this group_id to groups_table
                              - insert instructor_id and group_id to instructor_group_table
           -ELSE
            1.3. Raise exception notifying - entered user_id(s) not present in database.
       -ELSE
        1.4. Raise exception restricting - not to make any creating/modifications onto groups_table and instructor_group_table
                             
*/
CREATE OR REPLACE FUNCTION instructor_creating_user_group(  
    f_user_ids IN VARCHAR2 )
RETURN VARCHAR2 IS

f_instructor_email instructor_table.instructor_email%TYPE;
f_instructor_present BOOLEAN := FALSE;


-- f_user_ids_nested_table = is a nested table stores individual user_id(s) in varchar2 format
-- f_user_id = is used to verify if user_id is in user_table or not [used in select for into]
f_user_ids_nested_table NestedTableType := NestedTableType();
f_user_id users_table.user_id%TYPE;

f_duplicate_check NUMBER;

-- f_groups_id = holds newly creating groups_id from group_sequence
-- f_instructor_id = holds instructor ids from instructor table
f_groups_id groups_table.groups_id%TYPE;
f_instructor_id instructor_table.instructor_id%TYPE;

-- custom exceptions
f_instructor_not_found_exception EXCEPTION;
f_user_not_found_exception EXCEPTION;
f_duplicate_user_ids_found EXCEPTION;

BEGIN

    BEGIN
        -- Checking if instructor is valid or not
        SELECT instructor_email into f_instructor_email FROM instructor_table WHERE instructor_email = LOWER(is_instructor);
        f_instructor_present := TRUE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE f_instructor_not_found_exception;
    END;

    BEGIN
        IF f_instructor_present THEN

            -- Extracting individual user_id(s) into a nested table
            f_user_ids_nested_table := string_slicing(f_user_ids);

            -- Checking if user is valid or not
            FOR i IN 1..f_user_ids_nested_table.COUNT LOOP
                SELECT user_id INTO f_user_id FROM users_table WHERE user_id = f_user_ids_nested_table(i);
            END LOOP;

            -- Extracting instructor_id using instrutor_email from instructor_email
            SELECT instructor_id INTO f_instructor_id FROM instructor_table where instructor_email = LOWER(f_instructor_email);

            -- Using group_sequence generating one/single groups_id
            f_groups_id := 'g'||generate_id;
            BEGIN
                        -- Inserting values groups_id, instructor_id to instructor_group_table
                    INSERT INTO instructor_group_table( groups_id, instructor_id) VALUES
                            (f_groups_id, f_instructor_id);
                    

                    -- Inserting values groups_id and user_id(s) to groups_table
                    FOR i IN 1..f_user_ids_nested_table.COUNT LOOP
                        SELECT COUNT(*) INTO f_duplicate_check FROM groups_table WHERE groups_id = f_groups_id AND user_id = f_user_ids_nested_table(i);
                        IF f_duplicate_check > 0 THEN
                            RAISE f_duplicate_user_ids_found;
                        ELSE
                            INSERT INTO groups_table( groups_id, user_id) VALUES
                                (f_groups_id, f_user_ids_nested_table(i));
                        END IF;
                    END LOOP;
                    COMMIT;
                EXCEPTION
                    WHEN f_duplicate_user_ids_found THEN
                        ROLLBACK;
                        RETURN 'Single user id can not present in multiple times in group';
            END;


            RETURN 'Group creation successful';
        ELSE
            dbms_output.put_line(is_instructor);
            RETURN 'You are not a valid instructor \\n Group creation unsuccessful';
        END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE f_user_not_found_exception;
    END;

    EXCEPTION
        WHEN f_instructor_not_found_exception THEN
            -- instructor_custom_exception - restricting unknown instructor
            RETURN 'Your are not a instructor. Group creation not possible/Group creation unsuccessful';
        WHEN f_user_not_found_exception THEN
            RETURN 'One or more user IDs provided do not exist.';
END;

/*
Creating a sqeuence for generating groups_id
*/
-- CREATE SEQUENCE group_sequence;
-- drop sequence group_sequence;

select * from users_table;

select * from topic_question_table;
declare
    vv varchar2(500);
    aa varchar2(500);
begin
    vv := instructor_creating_user_group('u20240610034852689,u20240610034852694,u20240610034852696,u20240610034852700');
    -- aa := instructor_creating_user_group('u20240610034852689,u20240610034852694,u20240610034852696,u20240610034852700');
    dbms_output.put_line(vv);
    -- dbms_output.put_line(aa);
end;
