-- creating a function that checks if the question is valid.
    create or replace function valid_question_id(req_id in varchar2) return boolean as
        cursor questions is select question_id from questions_table;
    begin
        for q_id in questions loop
            if q_id.question_id=req_id then
                return true;
            end if;
        end loop;
        return false;
    end valid_question_id;

-- creating a function that checks if the user is valid.
    create or replace function valid_user_id(req_id in varchar2) return boolean as
        cursor valid_users is select user_id from users_table;
    begin
        for i in valid_users loop
            if i.user_id = req_id then
                return true;
            end if;
        end loop;
        return false;
    end valid_user_id;

-- creating a function that checks if the instructor is valid .
    create or replace function valid_instructor_id return boolean as
		present_instructor instructor_table.instructor_id%type;
    begin
        present_instructor := LOWER(IS_INSTRUCTOR);
		for i in (select instructor_id,instructor_email from instructor_table) loop
			if i.instructor_email = present_instructor then
				return true;
			end if;
		end loop;
		return false;
    end valid_instructor_id;


