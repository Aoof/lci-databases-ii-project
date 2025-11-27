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
    PROCEDURE Update_Salary(p_PilotId IN NUMBER, p_Amount IN NUMBER);
    PROCEDURE Update_Salary(p_PilotId IN NUMBER, p_Percentage IN NUMBER);
    PROCEDURE List_Of_Pilots(p_PlaId IN NUMBER);
    FUNCTION Nb_Planes(p_PilotId IN NUMBER) RETURN NUMBER;
END Pack_Pilot;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY Pack_Pilot AS
    PROCEDURE Update_Salary(p_PilotId IN NUMBER, p_Amount IN NUMBER) IS
        v_OldSalary PILOT.SALARY%TYPE;
        v_NewSalary PILOT.SALARY%TYPE;
        v_LastName PILOT.LAST_NAME%TYPE;
    BEGIN
        SELECT last_name, salary INTO v_LastName, v_OldSalary FROM pilot WHERE pilot_id = p_PilotId;
        v_NewSalary := v_OldSalary + p_Amount;
        UPDATE pilot SET salary = v_NewSalary WHERE pilot_id = p_PilotId;
        DBMS_OUTPUT.PUT_LINE('Pilot ID: ' || p_PilotId || ', Last Name: ' || v_LastName || ', Old Salary: ' || v_OldSalary || ', New Salary: ' || v_NewSalary || ', Amount: ' || p_Amount);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Pilot with ID ' || p_PilotId || ' not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    PROCEDURE Update_Salary(p_PilotId IN NUMBER, p_Percentage IN NUMBER) IS
        v_OldSalary PILOT.SALARY%TYPE;
        v_NewSalary PILOT.SALARY%TYPE;
        v_LastName PILOT.LAST_NAME%TYPE;
    BEGIN
        SELECT last_name, salary INTO v_LastName, v_OldSalary FROM pilot WHERE pilot_id = p_PilotId;
        v_NewSalary := v_OldSalary * (1 + p_Percentage / 100);
        UPDATE pilot SET salary = v_NewSalary WHERE pilot_id = p_PilotId;
        DBMS_OUTPUT.PUT_LINE('Pilot ID: ' || p_PilotId || ', Last Name: ' || v_LastName || ', Old Salary: ' || v_OldSalary || ', New Salary: ' || v_NewSalary || ', Percentage: ' || p_Percentage || '%');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Pilot with ID ' || p_PilotId || ' not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    PROCEDURE List_Of_Pilots(p_PlaId IN NUMBER) IS
        CURSOR c_Pilots IS
            SELECT DISTINCT p.pilot_id, p.last_name, pl.pla_desc, c.city_name
            FROM pilot p
            JOIN flight f ON p.pilot_id = f.pilot_id
            JOIN plane pl ON f.pla_id = pl.pla_id
            JOIN city c ON p.city_id = c.city_id
            WHERE pl.pla_id = p_PlaId;
        v_Count NUMBER := 0;
        pilot_Record c_Pilots%ROWTYPE;
    BEGIN
        OPEN c_Pilots;
        LOOP
            FETCH c_Pilots INTO pilot_Record;
            EXIT WHEN c_Pilots%NOTFOUND;
            v_Count := v_Count + 1;
            DBMS_OUTPUT.PUT_LINE('Pilot ID: ' || pilot_Record.pilot_id || ', Last Name: ' || pilot_Record.last_name || ', Plane Desc: ' || pilot_Record.pla_desc || ', City: ' || pilot_Record.city_name);
        END LOOP;
        CLOSE c_Pilots;
        IF v_Count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No pilots found for plane ID: ' || p_PlaId);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    FUNCTION Nb_Planes(p_PilotId IN NUMBER) RETURN NUMBER IS
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
    -- Test Update_Salary with amount
    Pack_Pilot.Update_Salary(1, 500);
    -- Test Update_Salary with percentage
    Pack_Pilot.Update_Salary(2, 10);
    -- Test List_Of_Pilots
    Pack_Pilot.List_Of_Pilots(1);
    -- Test Nb_Planes
    v_Nb := Pack_Pilot.Nb_Planes(1);
    DBMS_OUTPUT.PUT_LINE('Number of planes for pilot 1: ' || v_Nb);
END;
/
