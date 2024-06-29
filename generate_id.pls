create or replace function generate_id return varchar2 is
v_id varchar2(50);
begin
    v_id := TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');
    return v_id;
end;
