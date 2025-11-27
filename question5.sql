-- Question 5A: Create the stored procedure ListOfFlights that accepts the parameter : city name (departure city) and displays the list of flights ordered in ascending order of departure time (the columns to display are : flight id, pilot name, plane description, departure time, arrival time, arrival city name)

--Procedure creation
CLEAR SCREEN
CREATE OR REPLACE PROCEDURE LIST_OF_FLIGHTS(P_DEPARTURE_CITY IN CITY.CITY_NAME%TYPE)
IS
  V_DEPARTURE_CITY CITY.CITY_NAME%TYPE;

  TYPE FLIGHT_REC IS RECORD (
  V_FLIGHT_ID FLIGHT.FLIGHT_ID%TYPE,
  V_PILOT_NAM PILOT.FIRST_NAME%TYPE,
  V_PLANE_DESC PLANE.PLA_DESC%TYPE,
  V_DEPARTURE_TIME FLIGHT.DEP_TIME%TYPE,
  V_ARRIVAL_TIME FLIGHT.ARR_TIME%TYPE,
  V_CITY_ARR FLIGHT.CITY_ARR%TYPE
  );

  TYPE FL_TAB IS TABLE OF FLIGHT_REC INDEX BY BINARY_INTEGER;
  V_FL_TAB FL_TAB;

BEGIN
  --Validating if the city exists
  SELECT DISTINCT CITY_NAME
  INTO V_DEPARTURE_CITY
  FROM CITY
  WHERE CITY_NAME = P_DEPARTURE_CITY;

  --Filtering the details
  SELECT FLIGHT_ID, FIRST_NAME, PLA_DESC, DEP_TIME, ARR_TIME, CITY_ARR
  BULK COLLECT INTO V_FL_TAB
  -- INTO V_FLIGHT_ID, V_PILOT_NAM, V_PLANE_DESC, V_DEPARTURE_TIME, V_ARRIVAL_TIME, V_CITY_ARR
  FROM CITY C 
    INNER JOIN FLIGHT F ON C.CITY_ID = F.CITY_DEP
    INNER JOIN PILOT P ON F.PILOT_ID = P.PILOT_ID
    INNER JOIN PLANE A ON F.PLA_ID = A.PLA_ID
  WHERE CITY_NAME = P_DEPARTURE_CITY
  ORDER BY DEP_TIME ASC;

  DBMS_OUTPUT.PUT_LINE(
          RPAD('FLIGHT ID', 11) ||
          RPAD('PILOT NAME', 14) ||
          RPAD('PLANE DESCRIPTION', 19) ||
          RPAD('DEPARTURE TIME', 15) ||
          RPAD('ARRIVAL TIME', 13) ||
          RPAD('CITY ARRIVAL', 12));
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));

  FOR I IN V_FL_TAB.FIRST .. V_FL_TAB.LAST LOOP
  DBMS_OUTPUT.PUT_LINE(
        RPAD(V_FL_TAB(I).V_FLIGHT_ID, 11 ) ||
        RPAD(V_FL_TAB(I).V_PILOT_NAM, 14) ||
        RPAD(V_FL_TAB(I).V_PLANE_DESC, 19 ) ||
        RPAD(V_FL_TAB(I).V_DEPARTURE_TIME, 15) ||
        RPAD(V_FL_TAB(I).V_ARRIVAL_TIME, 13) ||
        RPAD(V_FL_TAB(I).V_CITY_ARR, 12)
    ); 
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(RPAD('-', 75, '-'));  

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('THE CITY '||P_DEPARTURE_CITY||' IS NOT PART OF OUR SYSTEM');
END;
/



-- Question 5B: Test the procedure ListOfFlights (the city name could be entered in upper or lower case)
SET SERVEROUTPUT ON
SET VERIFY OFF
CLEAR SCREEN 
ACCEPT S_CITY_NAME PROMPT 'ENTER A CITY NAME (DEPARTURE CITY): '
DECLARE
  V_CITY_NAME CITY.CITY_NAME%TYPE;
BEGIN
  V_CITY_NAME := UPPER('&S_CITY_NAME');
  LIST_OF_FLIGHTS(V_CITY_NAME);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- Question 5:
-- a) Create the stored procedure ListOfFlights that accepts the parameter : city
-- name (departure city) and displays the list of flights ordered in ascending
-- order of departure time (the columns to display are : flight id, pilot name,
-- plane description, departure time, arrival time, arrival city name)
-- b) Test the procedure ListOfFlights (the city name could be entered in upper or
-- lower case)

SET SERVEROUTPUT ON
SET VERIFY OFF

CREATE OR REPLACE PROCEDURE ListOfFlights(p_CityName IN VARCHAR2) IS
    CURSOR c_Flights IS
        SELECT f.flight_id, p.last_name, pl.pla_desc, f.dep_time, f.arr_time, c.city_name
        FROM flight f
        JOIN pilot p ON f.pilot_id = p.pilot_id
        JOIN plane pl ON f.pla_id = pl.pla_id
        JOIN city c ON f.city_arr = c.city_id
        JOIN city dep ON f.city_dep = dep.city_id
        WHERE UPPER(dep.city_name) = UPPER(p_CityName)
        ORDER BY f.dep_time;
    v_Count NUMBER := 0;
    flight_Record c_Flights%ROWTYPE;
BEGIN
    OPEN c_Flights;
    LOOP
        FETCH c_Flights INTO flight_Record;
        EXIT WHEN c_Flights%NOTFOUND;
        v_Count := v_Count + 1;
        DBMS_OUTPUT.PUT_LINE('Flight ID: ' || flight_Record.flight_id || ', Pilot: ' || flight_Record.last_name || ', Plane: ' || flight_Record.pla_desc || ', Dep Time: ' || flight_Record.dep_time || ', Arr Time: ' || flight_Record.arr_time || ', Arr City: ' || flight_Record.city_name);
    END LOOP;
    CLOSE c_Flights;
    IF v_Count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No flights found departing from the city: ' || p_CityName);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-- Test the procedure
EXEC ListOfFlights('Montreal');
EXEC ListOfFlights('ottawa');
