/*Create a procedure that takes question id as parameter and changes the difficulty of the question based 
on the percentage of correct attempts by the users who have written the question in all the quizes  */

-- creating function modify_difficulty 

create or replace procedure modify_difficulty(
    required_question_id questions_table.question_id%type
)as
    --creating a cursor that runs on a joint table between user_response_table and questions_table
    cursor q is select question_id from questions_Table;
    cursor cs is
        select user_response_table.user_answer,questions_table.answer from user_response_table
        join questions_table on user_response_table.question_id = questions_table.question_id
        where questions_table.question_id = required_question_id;
    correct_count number:=0;
    wrong_count number:=0;    probability number(3);
    updated_difficulty questions_table.difficulty_id%type;
    invalid_question_id exception;
    not_valid_instructor exception;
begin 

    --checking for valid instructor
    if not valid_instructor_id then
        raise not_valid_instructor;
    end if;

    --checking if the question_id is valid
    if not valid_question_id(required_question_id) then
        raise invalid_question_id;
    end if;


    -- this for loop utilizes the cursor created to collect the correct and wrong responses by the user.
    for i in cs loop
        if i.user_answer = i.answer then
            correct_count:=correct_count+1;
        else
            wrong_count:=wrong_count+1;
        end if;
    end loop;

    -- The percentage of correct answers is calculated
    probability := (correct_count*100)/(correct_count+wrong_count);

    --These conditions decide the new difficulty value for the question
    if probability>70 then
        updated_difficulty:='d1';
    elsif probability>20 then
        updated_difficulty:='d2';
    else
        updated_difficulty:='d3';
    end if;

    -- This statement below is used to uipdate the difficulty_id in the questions_table
    update questions_table set difficulty_id = updated_difficulty where question_id = required_question_id;

exception
    when no_data_found then
        dbms_output.put_line('The question you mentioned is not attempted');
    when not_valid_instructor then
        dbms_output.put_line('You do not have access to this procedure');
    when invalid_question_id then
        dbms_output.put_line('Question is not present !!');
    when others then
    dbms_output.put_line('Issue in modify_difficulty procedure with error code : '||SQLCODE||'  and message : '||SQLERRM);
end modify_difficulty;

-----------------------


-- Creating a Procedure that updates the difficulty levels of all the questions present in the questions_table
create or replace procedure update_difficulties as
    cursor cs is select question_id from questions_table;
    not_valid_instructor exception;
begin

    --checking for valid instructor
    if not valid_instructor_id then
        raise not_valid_instructor;
    end if;

    -- iterating through all the question_id in the questions_table
    for i in cs loop
        modify_difficulty(i.question_id);
    end loop;

exception 
    when not_valid_instructor then
        dbms_output.put_line('You do not have access to this procedure');
    when others then
        dbms_output.put_line('Issue in modify_difficulty procedure with error code : '||SQLCODE||'  and message : '||SQLERRM);

end update_difficulties;


select*from tab;
desc questions_table;
desc user_response_details;
select *from user_response_table;
select *from difficulty_table;
