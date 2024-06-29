select * from user_response_details;
select * from user_response_table where user_response_id = 'r20240611091600445';
select * from schedule_table;
select * from quiz_table where quiz_id = 'qz20240610085216049';

create or replace procedure view_past_test_answers(v_user_id varchar2 , v_quiz_id varchar2) is
v_user_response_id varchar2(50);
type user_test_tab is table of varchar2(50) index by varchar2(50);
user_test user_test_tab;
v_key varchar2(50);
v_orginal_answer varchar2(50);
v_explanation clob;
user_score number;
begin
    select score into user_score from results_table where user_id = v_user_id and v_quiz_id = quiz_id;
    dbms_output.put_line('Your score is : '||user_score);
    select user_response_id into v_user_response_id from user_response_details where quiz_id = v_quiz_id and user_id = v_user_id;
    for i in (select * from user_response_table where user_response_id =v_user_response_id) loop
        user_test(i.question_id):= i.user_answer;
    end loop;
    v_key := user_test.first;
    while v_key is not null loop
        select answer,explanation into v_orginal_answer,v_explanation from questions_table where question_id = v_key;
        dbms_output.put_line('question_id : '||v_key||', User Answer : '||user_test(v_key)||', Orginal Answer : '||v_orginal_answer||', Explanation : '||v_explanation);
        v_key := user_test.next(v_key);
    end loop;
exception
    when no_data_found then
        dbms_output.put_line('You didn''t attempt mentioned quiz_id');
end;


begin
    view_past_test_answers('u20240610034852689' , 'qz20240610085145576');
end;

select * from results_table where user_id = 'u20240610034852689' and quiz_id = 'qz20240610085145576';
delete from results_table where score_id = 's20240611091540347';
