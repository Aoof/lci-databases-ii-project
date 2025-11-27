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
