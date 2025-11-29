-- Assigned to : Jawad
-- Question 2: 
-- a) By using SELECT .. BULK COLLECT .., type a plsql program that asks to enter a city id and display all planes based in this city (pla_id, desc, max_passenger and city name)     
-- b) Execute this code for the cities : 102, 101

SET SERVEROUTPUT ON;
SET VERIFY OFF;
cLEAR SCREEN;
ACCEPT C_CITYID PROMPT 'Enter City ID: '
DECLARE 
type t_planescity is RECORD(
  city_id       city.city_id%TYPE,
    city_name     city.city_name%TYPE,
    plane_id      plane.pla_id%TYPE,
    plane_desc    plane.pla_desc%TYPE,
    max_passenger plane.max_passenger%TYPE
);
TYPE t_planescity_tab IS TABLE OF t_planescity;
v_planescity_tab t_planescity_tab;
BEGIN
  SELECT c.city_id,
          c.city_name,
          p.pla_id,
          p.pla_desc,
          p.max_passenger
  BULK COLLECT INTO v_planescity_tab
  FROM city c
  JOIN plane p
    ON c.city_id = p.city_id
  WHERE c.city_id = TO_NUMBER('&C_CITYID');
  dbms_output.put_line('City ID    City Name        Plane ID    Plane Description        Max Passengers');
  dbms_output.put_line('-------    --------------   --------    ------------------       ---------------');
  FOR i IN 1 .. v_planescity_tab.COUNT LOOP
    dbms_output.put_line(
      RPAD(v_planescity_tab(i).city_id, 10) || ' ' ||
      RPAD(v_planescity_tab(i).city_name, 15) || ' ' ||
      RPAD(v_planescity_tab(i).plane_id, 10) || ' ' ||
      RPAD(v_planescity_tab(i).plane_desc, 22) || ' '||
      v_planescity_tab(i).max_passenger
    );
  END LOOP;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('No planes found for the specified city ID.');
  WHEN OTHERS THEN
    dbms_output.put_line('An error occurred: ' || SQLERRM);
END;
/





