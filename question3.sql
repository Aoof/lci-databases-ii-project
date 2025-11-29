-- Question 3:
-- a) By using a cursor, type a PL/SQL program that displays the (id, description, capacity
-- and city name) for all planes located in particular city (enter city name regardless of the
-- case: ex:MonTreal) and their max passenger is greater or equal to a particular number.
-- b) Execute this this code

SET SERVEROUTPUT ON;
SET VERIFY OFF;
CLEAR SCREEN;
ACCEPT C_CITYNAME PROMPT 'Enter City Name: '
declare
CURSOR c_city is select p.pla_id, p.pla_desc, p.max_passenger, c.city_name
from plane p 
join city c 
ON c.city_id = p.city_id
where c.city_name = '&C_CITYNAME'
and p.max_passenger >= &C_MAXPASSENGER;
BEGIN
    c_cityid:= '&C_CITYNAME';
    dbms_output.put_line('Plane ID    Plane Description        Max Passengers    City Name');
    dbms_output.put_line('--------    ------------------       ---------------   --------------');
    FOR rec IN c_city LOOP
        IF UPPER(c_cityid) = UPPER(rec.city_name) THEN
            dbms_output.put_line(
                RPAD(rec.pla_id, 10) || ' ' ||
                RPAD(rec.pla_desc, 22) || ' ' ||
                RPAD(rec.max_passenger, 15) || ' ' ||
                rec.city_name
            );
        END IF;
    END LOOP;
CASE
when rec.max_passenger >= 300 then 
dbms_output.put_line('Large Capacity Plane Found');
when rec.max_passenger between 150 and 299 then
dbms_output.put_line('Medium Capacity Plane Found');
else
dbms_output.put_line('Small Capacity Plane Found');
end case;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No planes found for the specified criteria.');
    WHEN OTHERS THEN
        dbms_output.put_line('An error occurred: ' || SQLERRM);
END;
/
