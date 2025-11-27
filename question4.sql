-- Question 4:
-- a) Create the stored function NbOfPlanesPerCity that accepts the parameter : city
-- name and returns the number of planes located in that city.
-- b) Test the function NbOfPlanesPerCity (the city name could be entered in upper or
-- lower case)

SET SERVEROUTPUT ON
SET VERIFY OFF

CREATE OR REPLACE FUNCTION NbOfPlanesPerCity(p_CityName IN VARCHAR2) RETURN NUMBER IS
    v_Count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_Count
    FROM plane p
    JOIN city c ON p.city_id = c.city_id
    WHERE UPPER(c.city_name) = UPPER(p_CityName);
    RETURN v_Count;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        RETURN 0;
END;
/

-- Test the function
DECLARE
    v_Result NUMBER;
BEGIN
    v_Result := NbOfPlanesPerCity('Montreal');
    DBMS_OUTPUT.PUT_LINE('Number of planes in Montreal: ' || v_Result);
    v_Result := NbOfPlanesPerCity('ottawa');
    DBMS_OUTPUT.PUT_LINE('Number of planes in Ottawa: ' || v_Result);
END;
/
