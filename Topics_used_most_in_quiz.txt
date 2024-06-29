-- Topics and questions mostly used in quizes.
select * from topic_question_table;
select * from quiz_table;
select * from schedule_table;
select * from topics_table;


create or replace procedure most_used_topics 
is
type ass_array is table of number index by varchar2(30);
overal_quiz_data ass_array;
v_first varchar2(30);
topics_nested NESTEDTABLETYPE := NESTEDTABLETYPE();
topics_count_nested NESTEDTABLETYPE := NESTEDTABLETYPE();
v_temp number;
v_temp1 varchar2(30);
t_sum number := 0;
begin
    -- To read all questions and topics involved in it.
    for i in (select question_id from quiz_table) loop
        for j in (select topic_id from topic_question_table where question_id = i.question_id) loop
            if overal_quiz_data.exists(j.topic_id) then
                overal_quiz_data(j.topic_id) := overal_quiz_data(j.topic_id) + 1;
            else
                overal_quiz_data(j.topic_id) := 1;
            end if;
        end loop;
    end loop;

    -- To sort topics based on topic usage percentage...
    v_first := overal_quiz_data.first;

    -- Storing into nested table for sorting
    while v_first is not null loop
        topics_nested.extend;
        topics_nested(topics_nested.last) := v_first;
        topics_count_nested.extend;
        topics_count_nested(topics_count_nested.last) := overal_quiz_data(v_first);
        t_sum := t_sum + overal_quiz_data(v_first);
        --dbms_output.put_line(v_first||' '||overal_quiz_data(v_first));
        v_first := overal_quiz_data.next(v_first);
    end loop;

    -- Topics sorting
    for i in 1..topics_count_nested.count-1 loop
        for j in 1..topics_count_nested.count-i loop
            if topics_count_nested(j) < topics_count_nested(j+1) then
                v_temp := topics_count_nested(j);
                topics_count_nested(j) := topics_count_nested(j+1);
                topics_count_nested(j+1) := v_temp;
                v_temp1 := topics_nested(j);
                topics_nested(j) := topics_nested(j+1);
                topics_nested(j+1) := v_temp1;
            end if;
        end loop;
    end loop;
    for i in 1..topics_count_nested.count loop
        select topic_name into v_temp1 from topics_table where topic_id = topics_nested(i);
        dbms_output.put_line(i ||' --> '||v_temp1||' --> '|| TRUNC((topics_count_nested(i)/t_sum) * 100)||' % ');
    end loop;
end;


begin 
    most_used_topics;
end;


