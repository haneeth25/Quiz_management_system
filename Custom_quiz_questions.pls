                                                    ------- CUSTOM QUESTIONS ----------

/*This procedure prints all the questions present in the questions table ordered by topic name*/
create or replace procedure display_questions as
    --The cursor here is constructed using a join between questions_table,topic_question_table,topics_table,difficulty_table
    -- and question_format_table respectively.
    cursor cs is
        select q.question_id,q.question,q.options,q.answer,d.difficulty_name,f.format_name,t.topic_name
          from topic_question_table tq
          join topics_table t on tq.topic_id = t.topic_id
          join questions_table q on tq.question_id = q.question_id
          join difficulty_table d on q.difficulty_id = d.difficulty_id
          join question_format_table f on q.format_id = f.format_id
          --The statement below is used to organize the questions topic wise
        order by t.topic_name;

    not_valid_instructor exception;

begin
    if not valid_instructor_id then
        raise not_valid_instructor;
    end if;

    dbms_output.put_line('The format in which the questions are printed is : ');
    dbms_output.put_line('**question_id // question // options // answer // difficulty_name // format_name // topic_name**');
    -- The for loop below uses cursor to fetch the values in the above created join table and print them accordingly.
    for i in cs loop
        dbms_output.put_line('** '||
            i.question_id || ' // ' || 
            i.question || ' // ' || 
            i.options || ' // ' || 
            i.answer || ' // ' || 
            i.difficulty_name || ' // ' || 
            i.format_name || ' // ' || 
            i.topic_name||' **'
        );
    end loop;
    --The statement below is used as a prompt to create custom question by the instructor.
    dbms_output.put_line('');
    dbms_output.put_line('');
    dbms_output.put_line('To use custom questions use the |custom_question()| procedure with respective inputs');
exception 
    when not_valid_instructor then
        dbms_output.put_line('You do not have access to this procedure');
    when others then
    dbms_output.put_line('Issue in display_ questions with error code : '||SQLCODE||'  and message : '||SQLERRM);
end display_questions;

begin
display_questions;
end;

/*
select*from groups_table;
begin
custom_question('i20240610034809360','q1,q2,q3','g20240610040908576',1,1);
end;
select*from instructor_table;
*/

create or replace procedure custom_question(
    instructor_id_number instructor_table.instructor_id%TYPE,
    questions_ids varchar2,
    created_group_id groups_table.groups_id%type,
    passing_marks number,
    total_quiz_time number
)as
questions_tab NestedTableType := NestedTableType();
invalid_questions_tab NestedTableType := NestedTableType();
recent_quiz_id schedule_table.quiz_id%type;
valid_group boolean := true;
not_valid_group_id exception;
not_valid_instructor exception;
begin
    --checking for valid instructor
    if not valid_instructor_id then
        raise not_valid_instructor;
    end if;
    
    --checking for valid group id
    for i in (select groups_id from groups_table) loop
        if not i.groups_id=created_group_id then
           valid_group:=false;
           exit;
        end if;
    end loop;
    
    if not valid_group then
        raise not_valid_group_id;
    end if;


 
    questions_tab := string_slicing(questions_ids);
    recent_quiz_id := 'qz'||generate_id;

    --select * from schedule_table;
    -- Inserting new values into the schedule_table.
    insert into schedule_table values(instructor_id_number,recent_quiz_id,created_group_id,passing_marks,total_quiz_time);
  
    --select*from quiz_table;
    -- loop through the question ID's in the questions_tab nested table and insert them simultaneously.
    for i in 1..questions_tab.COUNT loop
        if not valid_question_id(questions_tab(i)) then
            invalid_questions_tab.extend;
            invalid_questions_tab(invalid_questions_tab.last):=questions_tab(i);
            continue;
        else
            insert into quiz_table values(recent_quiz_id,questions_tab(i));
        end if;
    end loop;

    if invalid_questions_tab.count > 0 then
        dbms_output.put_line('These question ID you have mentioned does not exist : ');
        for i in 1..invalid_questions_tab.count loop
            dbms_output.put_line(invalid_questions_tab(i));
        end loop;
    end if;

    -- printing the successful creation of quiz 
        dbms_output.put_line('The quiz has been created with the existing IDs');
        dbms_output.put_line('To add more questions to the quiz use : add_quiz_questions() procedure');
        dbms_output.put_line('To remove questions from quiz use : remove_quiz_questions() procedure');

exception
    when  not_valid_instructor then
        dbms_output.put_line('You cannot access this procedure ');
    when not_valid_group_id then
        dbms_output.put_line('The group ID does not exist');
    when others then
        dbms_output.put_line('Issue in custom_question procedure with error code : '||SQLCODE||'  and message : '||SQLERRM);

        
end custom_question;

--------------------------------------------------------------------------------

-- Creating the add_quiz_questions procedure

create or replace procedure add_quiz_questions(
    required_quiz_id quiz_table.quiz_id%type,
    questions_ids varchar2
)as
valid_quiz boolean := false;
questions_tab NestedTableType := NestedTableType();
invalid_questions_tab NestedTableType := NestedTableType();
present_instructor instructor_table.instructor_id%type;
actual_instructor instructor_table.instructor_id%type;
invalid_quiz exception;
invalid_instructor exception;
begin
    -- checking valid quiz
    for i in (select quiz_id from quiz_table) loop
        if required_quiz_id = i.quiz_id then
            valid_quiz:=true;
            exit;
        end if;
    end loop;

    if not valid_quiz then
        raise invalid_quiz;
    end if;
    --checking the respective instructor
    present_instructor := LOWER(IS_INSTRUCTOR);
    select instructor_id into actual_instructor from schedule_table where quiz_id=required_quiz_id;
    if not present_instructor=actual_instructor then
        raise invalid_instructor;
    end if;

    --splitting the question ID's into the table
    questions_tab := string_slicing(questions_ids);
    --inserting valid questions
    for i in 1..questions_tab.COUNT loop
        if not valid_question_id(questions_tab(i)) then
            invalid_questions_tab.extend;
            invalid_questions_tab(invalid_questions_tab.last):=questions_tab(i);
            continue;
        else
            insert into quiz_table values(required_quiz_id,questions_tab(i));
        end if;
    end loop;

    --displaying invalid questions
    if invalid_questions_tab.count > 0 then
        dbms_output.put_line('These question IDs you have mentioned do not exist : ');
        for i in 1..invalid_questions_tab.count loop
            dbms_output.put_line(invalid_questions_tab(i));
        end loop;
    end if;

    dbms_output.put_line('The quiz has been updated with valid question IDs');
    dbms_output.put_line('To add more questions to the quiz use add_quiz_questions() procedure');
    dbms_output.put_line('To remove questions from quiz use remove_quiz_questions() procedure');
    
    exception
        when invalid_quiz then
            dbms_output.put_line('The quiz ID is invalid !!');
        when invalid_instructor then
            dbms_output.put_line('You do not have access to modify this quiz');
        when others then
            dbms_output.put_line('Issue in add_quiz_questions procedure with error code : '||SQLCODE||'  and message : '||SQLERRM);

end add_quiz_questions;
-------------------------------------------------------------------------------------


-- Creating the remove_quiz_questions procedure
create or replace procedure remove_quiz_questions(
    required_quiz_id quiz_table.quiz_id%type,
    questions_ids varchar2
) as
present_instructor instructor_table.instructor_id%type;
actual_instructor instructor_table.instructor_id%type;
valid_quiz boolean := false;
questions_tab NestedTableType := NestedTableType();
invalid_questions_tab NestedTableType := NestedTableType();
invalid_quiz exception;
invalid_instructor exception;
begin
    --checking for valid quiz
    for i in (select quiz_id from quiz_table) loop
        if required_quiz_id = i.quiz_id then
            valid_quiz:=true;
            exit;
        end if;
    end loop;

    if not valid_quiz then
        raise invalid_quiz;
    end if;

    --checking for valid instructor
    present_instructor := LOWER(IS_INSTRUCTOR);
    select instructor_id into actual_instructor from schedule_table where quiz_id=required_quiz_id;
    if not present_instructor=actual_instructor then
        raise invalid_instructor;
    end if;

    --deleting the questions from questions_table
    for i in 1..questions_tab.COUNT loop
        if not valid_question_id(questions_tab(i)) then
            invalid_questions_tab.extend;
            invalid_questions_tab(invalid_questions_tab.last):=questions_tab(i);
            continue;
        else
            delete from quiz_table where (quiz_id = required_quiz_id and question_id = questions_tab(i));
        end if;
    end loop;

    --displaying invalid questions
    if invalid_questions_tab.count > 0 then
        dbms_output.put_line('These question IDs you have mentioned do not exist : ');
        for i in 1..invalid_questions_tab.count loop
            dbms_output.put_line(invalid_questions_tab(i));
        end loop;
    end if;

    dbms_output.put_line('The quiz has been updated and the valid questions are removed');
    dbms_output.put_line('To add more questions to the quiz use add_quiz_questions() procedure');
    dbms_output.put_line('To remove questions from quiz use remove_quiz_questions() procedure');

exception
        when invalid_quiz then
            dbms_output.put_line('The quiz ID is invalid !!');
        when invalid_instructor then
            dbms_output.put_line('You do not have access to modify this quiz');
        when others then
            dbms_output.put_line('Issue in remove_quiz_questions procedure with error code : '||SQLCODE||'  and message : '||SQLERRM);

end remove_quiz_questions;

-------------------------------------------------------------------------

-- Creating the delete_quiz procedure
create or replace procedure delete_quiz(
    required_quiz_id quiz_table.quiz_id%type
)as
present_instructor instructor_table.instructor_id%type;
actual_instructor instructor_table.instructor_id%type;
valid_quiz boolean := false;
invalid_quiz exception;
invalid_instructor exception;
begin
    --checking for valid quiz
    for i in (select quiz_id from quiz_table) loop
        if required_quiz_id = i.quiz_id then
            valid_quiz:=true;
            exit;
        end if;
    end loop;

    if not valid_quiz then
        raise invalid_quiz;
    end if;

    --checking for valid instructor
    present_instructor := LOWER(IS_INSTRUCTOR);
    select instructor_id into actual_instructor from schedule_table where quiz_id=required_quiz_id;
    if not present_instructor=actual_instructor then
        raise invalid_instructor;
    end if;

    -- deleting the records from schedule_table
    delete from schedule_table where (quiz_id = required_quiz_id and instructor_id = present_instructor);

    -- deleting the records from quiz_table
    delete from quiz_table where (quiz_id = required_quiz_id);

    dbms_output.put_line('The quiz has been succesfully deleted !!');

exception
    when invalid_quiz then
        dbms_output.put_line('The quiz ID is invalid !!');
    when invalid_instructor then
        dbms_output.put_line('You do not have access to modify this quiz');
    when others then
        dbms_output.put_line('Issue in remove_quiz_questions procedure with error code : '||SQLCODE||'  and message : '||SQLERRM);


end delete_quiz;

--select*from tab;

desc results_table;
