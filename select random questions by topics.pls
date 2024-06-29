create OR replace type NestedTableType is table of VARCHAR2(100);

-- Function for string slicing
create or replace function string_slicing(input_string varchar2) return NestedTableType is 
tab_substrings NestedTableType := NestedTableType();
each_substring varchar2(100) := '';
begin
    for i in 1..length(input_string) loop
        if substr(input_string,i,1) != ',' then
            each_substring := each_substring || substr(input_string,i,1);
        elsif substr(input_string,i,1) = ',' and length(each_substring) >= 1 then 
            tab_substrings.extend;
            each_substring := trim(each_substring);
            tab_substrings(tab_substrings.last) := each_substring;
            each_substring := '';
        end if;
    end loop;
    if length(each_substring) >= 1 then
        tab_substrings.extend;
        each_substring := trim(each_substring);
        tab_substrings(tab_substrings.last) := each_substring;
        each_substring := '';
    end if;
    return tab_substrings;
end;


create sequence quiz_sequence;

-- Procedure to select random questions based on topics provided.
create or replace procedure random_quiz_creation_by_topics(v_topics varchar2,question_count number,difficulty varchar2 := null,
                                                            question_format varchar2 := null ,v_groups_id varchar2,pass_marks number,
                                                            completion_time number) is
tab_topics NestedTableType := NestedTableType();
type weak_ref_cursor is ref cursor;
type recordType is record(
    topic_name varchar2(20),
    question_id varchar2(50),
    difficulty_name varchar2(20),
    format_name varchar2(20)
);
cursor_res recordType;
questions_cursor weak_ref_cursor;
sql_code varchar2(500);
possible_questions NestedTableType := NestedTableType();
type random_not_repeated_type is table of number;
random_not_repeated random_not_repeated_type := random_not_repeated_type();
v_instructor_id varchar2(50);
quiz_id varchar2(50);
v_count number := 0;
v_random_number number;
invalid_question_format exception;
present_user varchar2(20);
valid_user boolean := false;
not_valid_user exception;
valid_group boolean := false;
not_valid_group exception;
not_valid_question_count exception;
not_valid_pass_marks exception;
begin
    -- Checking all inputs is valid or not;
    present_user := LOWER(IS_INSTRUCTOR);
    for i in (select instructor_id,instructor_email from instructor_table) loop
        if i.instructor_email = present_user then
            valid_user := true;
            v_instructor_id := i.instructor_id;
            exit;
        end if;
    end loop;
    if not valid_user then
        raise not_valid_user;
    end if;
    -- checking group_id 
    for i in (select groups_id from instructor_group_table) loop
        if i.groups_id = v_groups_id then
            valid_group := true;
            exit;
        end if;
    end loop;
    if not valid_group then
        raise not_valid_group;
    end if;

    -- Checking if question count is valid or not.
    if question_count < 1 then
        raise not_valid_question_count;
    end if;

    -- Checking valid pass marks or not 
    if pass_marks > question_count then
        raise not_valid_pass_marks;
    end if;
    -- Slicing the topics names
    tab_topics := string_slicing(v_topics);
    -- Creating an sql query for the requirements
    sql_code := 'select t1.topic_name,q1.question_id,d1.difficulty_name,f1.format_name
    from topics_table t1 join topic_question_table tq1 on t1.topic_id = tq1.topic_id 
    join questions_table q1 on tq1.question_id = q1.question_id 
    join difficulty_table d1 on q1.difficulty_id = d1.difficulty_id
    join QUESTION_FORMAT_TABLE f1 on q1.format_id = f1.format_id
    WHERE t1.topic_name IN (';
    -- Attaching topic names
    for i in 1..tab_topics.count loop
        sql_code := sql_code ||''''||tab_topics(i)||'''';
        if i != tab_topics.count then
            sql_code := sql_code||',';
        end if;
    end loop;
    sql_code := sql_code||')'; 
    -- Attaching difficulty 
    if difficulty is not null then
        sql_code := sql_code||' and d1.difficulty_name = '||''''||difficulty||'''';
    end if;
    -- Attaching question Format
    if question_format is not null then
        sql_code := sql_code||' and f1.format_name = '||''''||question_format||'''';
    end if;
    -- Fetching the data and storing all possible questions.
    open questions_cursor for sql_code;
    loop
        fetch questions_cursor into cursor_res;
        exit when questions_cursor%notfound;
        if cursor_res.question_id not member of possible_questions then
            possible_questions.extend;
            possible_questions(possible_questions.last) := cursor_res.question_id;
        end if;
        end loop;
    close questions_cursor;

    -- Raising exception when question not availabe with given format or no enough number of questions;
    if possible_questions.count < question_count then
        raise invalid_question_format;
    end if;


    -- Generating random numbers and checking that they are not repeated
    while v_count < question_count loop
        v_random_number := TRUNC(dbms_random.value(1,possible_questions.count+1));
        if v_random_number not member of random_not_repeated then
            random_not_repeated.extend ;
            random_not_repeated(random_not_repeated.count) := v_random_number;
            v_count := v_count+1;
        end if;
    end loop;


    quiz_id := 'qz'||generate_id;
    insert into SCHEDULE_TABLE values(v_instructor_id,quiz_id,v_groups_id,pass_marks,completion_time);

    for i in 1..random_not_repeated.count loop
        --dbms_output.put_line(possible_questions(random_not_repeated(i)));
        insert into quiz_table values(quiz_id,possible_questions(random_not_repeated(i)));
    end loop;
    dbms_output.put_line('Quiz created and assigned to the user group');
exception
    when not_valid_user then
        dbms_output.put_line('You dont have access to this procedure');
    when not_valid_group then
        dbms_output.put_line('no group with '||v_groups_id);
    when invalid_question_format then
        dbms_output.put_line('question not availabe with given format or no enough number of questions');
    when not_valid_question_count then
        dbms_output.put_line('Invalid question_count');
    when not_valid_pass_marks then
        dbms_output.put_line('Pass marks can''t be more then pass marks');
end;


begin
random_quiz_creation_by_topics('Mathematics,Science,Literature,Programming',10,'Easy',null,'g20240610040908576',15,30);
end;



select * from questions_table;
select * from  SCHEDULE_TABLE
select * from quiz_table;
select * from instructor_group_table;
select * from GROUPS_TABLE;
select * from topics_table;
select * from questions_table;
select * from question_format_table;
rename question_formart_table to question_format_table;
select t1.topic_name,q1.question_id,d1.difficulty_name,f1.format_name
from topics_table t1 join topic_question_table tq1 on t1.topic_id = tq1.topic_id 
join questions_table q1 on tq1.question_id = q1.question_id 
join difficulty_table d1 on q1.difficulty_id = d1.difficulty_id
join QUESTION_FORMAT_TABLE f1 on q1.format_id = f1.format_id
where t1.topic_name in ('Mathematics','Science','History','Literature','Programming');

select * from questions_table where question_id = 'q20240610083442494';
