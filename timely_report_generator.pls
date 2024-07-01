select * from results_table;


select * from tab;

-- creating weekly report 
create or replace procedure student_weekly_report (student_id in varchar2) as
    cursor weekly_scores is
        select trunc(submit_time, 'IW') as week_start,
               avg(score) as average_score
        from results_table
        where user_id = student_id
        group by trunc(submit_time, 'IW')
        order by week_start;

    invalid_user_id exception;
    valid_user boolean:= valid_user_id(student_id);
begin
    if  not valid_user then
        raise invalid_user_id;
    end if;

    for rec in weekly_scores loop
        dbms_output.put_line('Week starting on ' || TO_CHAR(rec.week_start, 'yyyy-mm-dd') || 
                             ' - Average Score: ' || rec.average_score);
    end loop;
exception
    when no_data_found then
        dbms_output.put_line('The student is not available !');
    when invalid_user_id then
        dbms_output.put_line('The student/user ID is invalid !');
    when others then
        dbms_output.put_line('Some error occured in weekly report procedure !');
end student_weekly_report;


--Generating Monthly report
create or replace procedure student_monthly_report (student_id in varchar2) as
    cursor monthly_scores is
        select to_char(submit_time, 'yyyy-mm') as month_year,
               avg(score) as average_score
        from results_table
        where user_id = student_id
        group by to_char(submit_time, 'yyyy-mm')
        order by month_year;
    invalid_user_id exception;
    valid_user boolean:= valid_user_id(student_id);
begin
    if  not valid_user then
        raise invalid_user_id;
    end if;

    for rec in monthly_scores loop
        dbms_output.put_line('Month: ' || rec.month_year || 
                             ' - Average Score: ' || rec.average_score);
    end loop;
exception
    when no_data_found then
        dbms_output.put_line('The student is not available');
    when invalid_user_id then
        dbms_output.put_line('The student/user ID is invalid !');
    when others then
        dbms_output.put_line('Some error occured in monthly report procedure : ' || SQLERRM );
end student_monthly_report;

-- Generating Yearly report
create or replace procedure student_yearly_report (student_id in varchar2) as
   
    cursor yearly_scores is
        select extract(year from submit_time) as year_wise,
               avg(score) as average_score
        from results_table
        where user_id = student_id
        group by extract(year from submit_time)
        order by year_wise;

    invalid_user_id exception;
    valid_user boolean:= valid_user_id(student_id);
begin
    if  not valid_user then
        raise invalid_user_id;
    end if;
    for rec in yearly_scores loop
        dbms_output.put_line('Year: ' || rec.year_wise || 
                             ' - Average Score: ' || rec.average_score);
    end loop;
exception
    when no_data_found then
        dbms_output.put_line('The student is not available');
    when invalid_user_id then
        dbms_output.put_line('The student/user ID is invalid !');
    when others then
        dbms_output.put_line('Some error occured in yearly report procedure');
end student_yearly_report;



begin
    student_yearly_report('u20240610034852694');
end;

desc results_table;




