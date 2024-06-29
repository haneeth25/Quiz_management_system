select * from questions_table;
create or replace function generate_words(word_length number) return varchar2 is
    generated_word varchar2(20);
begin
    generated_word := LOWER(dbms_random.string('a',word_length));
    return generated_word;
end;


create or replace procedure generate_questions is
    v_question_id varchar2(50);
    v_generated_question clob;
    v_question_length number;
    v_question_word_length varchar2(20);
    v_generated_word varchar(20);
    v_generated_answer varchar2(50);
    v_generated_explanation clob;
    v_explanation_length number;
    v_explanation_word_length varchar2(20);
    v_explanation_word varchar(20);
    v_random_number number;
    v_difficulty_id varchar2(20);
    v_format_id varchar2(20);
    v_options varchar2(100);
    check_topic NESTEDTABLETYPE := NESTEDTABLETYPE();
    v_random_topic_number number;
    type v_array_type is varray(4) of varchar2(20);
    v_mcq_array v_array_type := v_array_type();
begin
    v_question_id := 'q'||generate_id;
    -- Generating question 
    -- Question length
    v_question_length := TRUNC(dbms_random.value(6,10));
    for i in 1..v_question_length loop
        v_question_word_length := TRUNC(dbms_random.value(2,10));
        v_generated_word := generate_words(v_question_word_length);
        v_generated_question := v_generated_question ||' '|| v_generated_word;
    end loop;

    -- generate answer
    v_generated_answer := generate_words(TRUNC(dbms_random.value(6,10)));


    -- generate explantion 
    v_explanation_length := TRUNC(dbms_random.value(6,20));
    for i in 1..v_explanation_length loop
        v_explanation_word_length := TRUNC(dbms_random.value(2,10));
        v_explanation_word := generate_words(v_explanation_word_length);
        v_generated_explanation := v_generated_explanation ||' '|| v_explanation_word;
    end loop;

    -- generate difficulty_id
    v_random_number := TRUNC(dbms_random.value(1,4));
    v_difficulty_id := case v_random_number
                        when 1 then 'd1'
                        when 2 then 'd2'
                        when 3 then 'd3'
                        end;

    -- generate format_id
    v_random_number := TRUNC(dbms_random.value(1,4));
    v_format_id := case v_random_number
                        when 1 then 'f1'
                        when 2 then 'f2'
                        when 3 then 'f3'
                        end;

    -- generate options

    if v_format_id = 'f1' then
        v_options := '-';
    elsif v_format_id = 'f2' then
        for i in 1..4 loop
            v_mcq_array.extend;
            v_mcq_array(v_mcq_array.last) := generate_words(TRUNC(dbms_random.value(6,10)));
        end loop;
        v_options := '1.'||v_mcq_array(1)||
                ',2.'||v_mcq_array(2)||
                ',3.'||v_mcq_array(3)||
                ',4.'||v_mcq_array(4);
        v_random_number := Trunc(dbms_random.value(1,3));
        v_generated_answer := v_mcq_array(v_random_number);
    else
        v_options := '1.True,2.False';
        v_random_number := TRUNC(dbms_random.value(1,3));
        if v_random_number = 1 then
            v_generated_answer := 'True';
        else
            v_generated_answer := 'False';
        end if;
    end if;
    -- dbms_output.put_line('question_id --> '|| v_question_id);
    -- dbms_output.put_line('v_generated_question --> '|| trim(v_generated_question));
    -- dbms_output.put_line('v_generated_answer --> '|| v_generated_answer);
    -- dbms_output.put_line('v_generated_explanation --> '|| trim(v_generated_explanation));
    -- dbms_output.put_line('v_difficulty_id --> '||v_difficulty_id);
    -- dbms_output.put_line('v_format_id --> '||v_format_id);
    -- dbms_output.put_line('v_options --> '||v_options);
    insert into questions_table values(v_question_id,trim(v_generated_question),v_generated_answer,trim(v_generated_explanation),
                                        v_difficulty_id,v_format_id,v_options);


    -- To connect question with topics
    v_random_number := TRUNC(dbms_random.value(1,4));
    for i in 1..v_random_number loop 
        v_random_topic_number := TRUNC(dbms_random.value(1,6));
        if v_random_topic_number not member of check_topic then
            --dbms_output.put_line(v_random_topic_number);
            check_topic.extend;
            check_topic(check_topic.last) := v_random_topic_number;
            if v_random_topic_number = 1 then
                insert into topic_question_table values('t1',v_question_id);
            elsif v_random_topic_number = 2 then
                insert into topic_question_table values ('t2',v_question_id);
            elsif v_random_topic_number = 3 then
                insert into topic_question_table values('t3',v_question_id);
            elsif v_random_topic_number = 4 then
                insert into topic_question_table values('t4',v_question_id);
            else
                insert into topic_question_table values('t5',v_question_id);
            end if;
        end if;
    end loop;
    dbms_output.put_line('Questions generated');
end;

begin
    generate_questions;
end;

select * from groups_table;
select * from topics_table;
select * from questions_table;
delete from quiz_table;
delete from questions_table;
select * from topic_question_table;
select * from quiz_table;
delete from topic_question_table;
select question_id,count(topic_id) from topic_question_table group by question_id;
/
