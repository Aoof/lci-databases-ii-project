# lci-databases-ii-project

## Team Members

- Jawad Kazan
- Edward Angeles
- Abdulrahman Mousa

## Question Assignments

| SQL File | Assigned To |
|----------|-------------|
| question2.sql | Jawad Kazan |
| question3.sql | Jawad Kazan |
| question4.sql | Abdulrahman Mousa |
| question5.sql | Edward Angeles |
| question6.sql | Abdulrahman Mousa |

## Question Descriptions

### Question 2
a) By using SELECT .. BULK COLLECT .., type a plsql program that asks to enter a city id and display all planes based in this city (pla_id, desc, max_passenger and city name)     
b) Execute this code for the cities : 102, 101

### Question 3
a) By using a cursor, type a PL/SQL program that displays the (id, description, capacity and city name) for all planes located in particular city (enter city name regardless of the case: ex:MonTreal) and their max passenger is greater or equal to a particular number.  
b) Execute this this code

### Question 4
a) Create the stored function NbOfPlanesPerCity that accepts the parameter : city name and returns the number of planes located in that city.  
b) Test the function NbOfPlanesPerCity (the city name could be entered in upper or lower case)

### Question 5
a) Create the stored procedure ListOfFlights that accepts the parameter : city name (departure city) and displays the list of flights ordered in ascending order of departure time (the columns to display are : flight id, pilot name, plane description, departure time, arrival time, arrival city name)  
b) Test the procedure ListOfFlights (the city name could be entered in upper or lower case)

### Question 6
a) Create the package and package body called Pack_Pilot that defines the following objects :   
- Update_Salary : allows increase/decrease the salary of pilot according to a new amount or a percentage (use a technic to define an overload object with the same function/procedure name) (the info to output : pilot id, last name, old salary, new salary, the amount or percentage)  
- List_Of_Pilots : pilots who pilot a particular plane (pilot_id, last_name, pla_desc pilot city_name) (use cursor with parameter)  
- Nb_Planes : Returns the total number of planes flown by a given pilot.  
b) Type a plsql program that test the objects of this package - Test Update_Salary, List_Of_Pilots and Nb_Planes