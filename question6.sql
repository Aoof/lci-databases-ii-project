-- Assigned to: Abdulrahman Mousa
-- Question 6:
-- a) Create the package and package body called Pack_Pilot that defines the following
-- objects :
--   - Update_Salary : allows increase/decrease the salary of pilot according to a new
-- amount or a percentage (use a technic to define an overload object with the same
-- function/procedure name) (the info to output : pilot id, last name, old salary, new
-- salary, the amount or percentage)
--   - List_Of_Pilots :  pilots who pilot a particular plane (pilot_id, last_name, pla_desc
-- pilot city_name) (use cursor with parameter)
--   - Nb_Planes : Returns the total number of planes flown by a given pilot.
-- b) Type a plsql program that test the objects of this package
--     - Test Update_Salary, List_Of_Pilots and Nb_Planes

SET SERVEROUTPUT ON
SET VERIFY OFF

-- Package Specification
CREATE OR REPLACE PACKAGE Pack_Pilot AS
    PROCEDURE Update_Salary(p_PilotId NUMBER, p_Amount NUMBER);
    PROCEDURE Update_Salary(p_PilotId NUMBER, p_Percentage VARCHAR2);
    PROCEDURE List_Of_Pilots(p_PlaId NUMBER);
    FUNCTION Nb_Planes(p_PilotId NUMBER) RETURN NUMBER;
END Pack_Pilot;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY Pack_Pilot AS
    PROCEDURE Update_Salary(p_PilotId NUMBER, p_Amount NUMBER) IS
        v_OldSalary PILOT.SALARY%TYPE;
        v_NewSalary PILOT.SALARY%TYPE;
        v_LastName PILOT.LAST_NAME%TYPE;
    BEGIN
        SELECT last_name, salary INTO v_LastName, v_OldSalary FROM pilot WHERE pilot_id = p_PilotId;
        v_NewSalary := v_OldSalary + p_Amount;
        UPDATE pilot SET salary = v_NewSalary WHERE pilot_id = p_PilotId;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Pilot ID:', 10) || LPAD(p_PilotId, 5) || ' | ' ||
            RPAD('Last Name:', 10) || RPAD(v_LastName, 15) || ' | ' ||
            RPAD('Old Salary:', 12) || LPAD(TO_CHAR(v_OldSalary, '999,999.99'), 10) || ' | ' ||
            RPAD('New Salary:', 12) || LPAD(TO_CHAR(v_NewSalary, '999,999.99'), 10) || ' | ' ||
            RPAD('Amount:', 8) || LPAD(TO_CHAR(p_Amount, '999,999.99'), 10)
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Pilot with ID ' || p_PilotId || ' not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    PROCEDURE Update_Salary(p_PilotId NUMBER, p_Percentage VARCHAR2) IS
        v_OldSalary PILOT.SALARY%TYPE;
        v_NewSalary PILOT.SALARY%TYPE;
        v_LastName PILOT.LAST_NAME%TYPE;
    BEGIN
        SELECT last_name, salary INTO v_LastName, v_OldSalary FROM pilot WHERE pilot_id = p_PilotId;
        v_NewSalary := v_OldSalary * (1 + TO_NUMBER(p_Percentage) / 100);
        UPDATE pilot SET salary = v_NewSalary WHERE pilot_id = p_PilotId;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Pilot ID:', 10) || LPAD(p_PilotId, 5) || ' | ' ||
            RPAD('Last Name:', 10) || RPAD(v_LastName, 15) || ' | ' ||
            RPAD('Old Salary:', 12) || LPAD(TO_CHAR(v_OldSalary, '999,999.99'), 10) || ' | ' ||
            RPAD('New Salary:', 12) || LPAD(TO_CHAR(v_NewSalary, '999,999.99'), 10) || ' | ' ||
            RPAD('Percentage:', 12) || LPAD(p_Percentage || '%', 6)
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Pilot with ID ' || p_PilotId || ' not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    PROCEDURE List_Of_Pilots(p_PlaId NUMBER) IS
        CURSOR c_Pilots IS
            SELECT DISTINCT p.pilot_id, p.last_name, pl.pla_desc, c.city_name
            FROM pilot p
            JOIN flight f ON p.pilot_id = f.pilot_id
            JOIN plane pl ON f.pla_id = pl.pla_id
            JOIN city c ON p.city_id = c.city_id
            WHERE pl.pla_id = p_PlaId;
        v_Count NUMBER := 0;
        v_Pilot c_Pilots%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('List of Pilots for Plane ID ' || p_PlaId || ':');
        DBMS_OUTPUT.PUT_LINE(RPAD('=', 70, '='));
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Pilot ID', 8) || ' | ' ||
            RPAD('Last Name', 15) || ' | ' ||
            RPAD('Plane Description', 20) || ' | ' ||
            RPAD('City', 15)
        );
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 70, '-'));
        OPEN c_Pilots;
        LOOP
            FETCH c_Pilots INTO v_Pilot;
            EXIT WHEN c_Pilots%NOTFOUND;
            v_Count := v_Count + 1;
            DBMS_OUTPUT.PUT_LINE(
                LPAD(v_Pilot.pilot_id, 8) || ' | ' ||
                RPAD(v_Pilot.last_name, 15) || ' | ' ||
                RPAD(v_Pilot.pla_desc, 20) || ' | ' ||
                RPAD(v_Pilot.city_name, 15)
            );
        END LOOP;
        CLOSE c_Pilots;
        IF v_Count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No pilots found for plane ID: ' || p_PlaId);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    FUNCTION Nb_Planes(p_PilotId NUMBER) RETURN NUMBER IS
        v_Count NUMBER;
    BEGIN
        SELECT COUNT(DISTINCT pla_id) INTO v_Count FROM flight WHERE pilot_id = p_PilotId;
        RETURN v_Count;
    END;
END Pack_Pilot;
/

-- Test Program
DECLARE
    v_Nb NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
    DBMS_OUTPUT.PUT_LINE(RPAD(' ', 30) || 'PACK_PILOT TEST RESULTS');
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
    
    -- Test Update_Salary with amount
    DBMS_OUTPUT.PUT_LINE('Test 1: Update Salary by Amount');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
    Pack_Pilot.Update_Salary(1, 500);
    
    -- Test Update_Salary with percentage
    DBMS_OUTPUT.PUT_LINE('Test 2: Update Salary by Percentage');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
    Pack_Pilot.Update_Salary(2, '10');
    
    -- Test List_Of_Pilots
    DBMS_OUTPUT.PUT_LINE('Test 3: List of Pilots for Plane');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
    Pack_Pilot.List_Of_Pilots(1);
    
    -- Test Nb_Planes
    DBMS_OUTPUT.PUT_LINE('Test 4: Number of Planes for Pilot');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
    v_Nb := Pack_Pilot.Nb_Planes(1);
    DBMS_OUTPUT.PUT_LINE(RPAD('Pilot ID:', 15) || LPAD('1', 3) || ' | ' || RPAD('Number of Planes:', 18) || LPAD(v_Nb, 3));
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
END;
/
