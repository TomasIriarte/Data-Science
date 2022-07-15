/* ------------------------------------------
--DDL statement for table 'HR' database--
--------------------------------------------

-- Drop the tables in case they exist

DROP TABLE EMPLOYEES;
DROP TABLE JOB_HISTORY;
DROP TABLE JOBS;
DROP TABLE DEPARTMENTS;
DROP TABLE LOCATIONS;

-- Create the tables

CREATE TABLE EMPLOYEES (
                          EMP_ID CHAR(9) NOT NULL,
                          F_NAME VARCHAR(15) NOT NULL,
                          L_NAME VARCHAR(15) NOT NULL,
                          SSN CHAR(9),
                          B_DATE DATE,
                          SEX CHAR,
                          ADDRESS VARCHAR(30),
                          JOB_ID CHAR(9),
                          SALARY DECIMAL(10,2),
                          MANAGER_ID CHAR(9),
                          DEP_ID CHAR(9) NOT NULL,
                          PRIMARY KEY (EMP_ID)
                        );

CREATE TABLE JOB_HISTORY (
                            EMPL_ID CHAR(9) NOT NULL,
                            START_DATE DATE,
                            JOBS_ID CHAR(9) NOT NULL,
                            DEPT_ID CHAR(9),
                            PRIMARY KEY (EMPL_ID,JOBS_ID)
                          );

CREATE TABLE JOBS (
                    JOB_IDENT CHAR(9) NOT NULL,
                    JOB_TITLE VARCHAR(30) ,
                    MIN_SALARY DECIMAL(10,2),
                    MAX_SALARY DECIMAL(10,2),
                    PRIMARY KEY (JOB_IDENT)
                  );

CREATE TABLE DEPARTMENTS (
                            DEPT_ID_DEP CHAR(9) NOT NULL,
                            DEP_NAME VARCHAR(15) ,
                            MANAGER_ID CHAR(9),
                            LOC_ID CHAR(9),
                            PRIMARY KEY (DEPT_ID_DEP)
                          );

CREATE TABLE LOCATIONS (
                          LOCT_ID CHAR(9) NOT NULL,
                          DEP_ID_LOC CHAR(9) NOT NULL,
                          PRIMARY KEY (LOCT_ID,DEP_ID_LOC)
                        );
*/

/* Exercise 1: String Patterns */ 
/* 1. Problem Retrieve all employees whose address is in Elgin,IL. */

SELECT F_NAME, L_NAME 
FROM EMPLOYEES
WHERE ADDRESS LIKE '%Elgin,IL%';

/* 2. Retrieve all employees who were born during the 1970's. */

SELECT F_NAME, L_NAME, B_DATE
FROM EMPLOYEES
WHERE B_DATE LIKE '197%';

/* 3. Retrieve all employees in department 5 whose salary 
is between 60000 and 70000. */

SELECT *
FROM EMPLOYEES
WHERE (SALARY BETWEEN 60000 AND 70000) AND DEP_ID = 5;

/* Exercise 2: Sorting */
/* 1. Retrieve a list of employees ordered by department ID.*/

SELECT F_NAME, L_NAME, DEP_ID
FROM EMPLOYEES
ORDER BY DEP_ID; 
 
/* 2. Retrieve a list of employees ordered in descending order by 
department ID and within each department ordered alphabetically in 
descending order by last name.*/ 

SELECT F_NAME, L_NAME, DEP_ID
FROM EMPLOYEES
ORDER BY DEP_ID DESC, L_NAME DESC; 

/* 3. In SQL problem 2 (Exercise 2 Problem 2), use department name
 instead of department ID. Retrieve a list of employees ordered 
 by department name, and within each department ordered 
 alphabetically in descending order by last name.*/

SELECT D.DEP_NAME , E.F_NAME, E.L_NAME
FROM EMPLOYEES as E, DEPARTMENTS as D
WHERE E.DEP_ID = D.DEPT_ID_DEP
ORDER BY D.DEP_NAME, E.L_NAME DESC;
 
 
/* Exercise 3: Grouping */
/* 1. For each department ID retrieve the number of 
employees in the department. */

SELECT DEP_ID, COUNT(*)
FROM EMPLOYEES
GROUP BY DEP_ID; 

/* 2. For each department retrieve the number of employees 
in the department, and the average employee salary in the 
department. */

SELECT DEP_ID, COUNT(*), AVG (SALARY)
FROM EMPLOYEES
GROUP BY DEP_ID ; 


/* 3. Label the computed columns in the result set of SQL 
problem 2 (Exercise 3 Problem 2) as NUM_EMPLOYEES and 
AVG_SALARY.*/

SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG (SALARY) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID ;

/* 4. In SQL problem 3 (Exercise 3 Problem 3), order the result 
set by Average Salary.*/

SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG (SALARY) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID
ORDER BY AVG_SALARY;

/* 5. In SQL problem 4 (Exercise 3 Problem 4), limit the 
result to departments with fewer than 4 employees. */

SELECT DEP_ID, COUNT(*) AS "NUM_EMPLOYEES", AVG (SALARY) AS "AVG_SALARY"
FROM EMPLOYEES
GROUP BY DEP_ID
HAVING COUNT(*) < 4
ORDER BY AVG_SALARY ;

/*-----------------------------------------------------------------------------------*/

/* Sub-queries and Nested SELECTs */

/* 1. Execute a failing query (i.e. one which gives an error) to 
retrieve all employees records whose salary is 
lower than the average salary.*/

SELECT *
FROM EMPLOYEES
WHERE SALARY < AVG(SALARY);

/* 2. Execute a working query using a sub-select to retrieve 
all employees records whose salary is lower than the 
average salary.*/

SELECT * 
FROM EMPLOYEES
WHERE SALARY < (SELECT AVG(SALARY) FROM EMPLOYEES);

/* 3. Execute a failing query (i.e. one which gives an error) 
to retrieve all employees records with EMP_ID, 
SALARY and maximum salary as MAX_SALARY in every row.*/

SELECT EMP_ID, SALARY, MAX (SALARY) AS MAX_SALARY
FROM EMPLOYEES;

/* 4. Execute a Column Expression that retrieves all employees 
records with EMP_ID, SALARY and maximum salary as MAX_SALARY 
in every row. */

SELECT EMP_ID, SALARY, (SELECT MAX (SALARY) AS MAX_SALARY 
FROM EMPLOYEES)
FROM EMPLOYEES;

/* 5. Execute a Table Expression for the EMPLOYEES table that 
excludes columns with sensitive employee data (i.e. does not 
include columns: SSN, B_DATE, SEX, ADDRESS, SALARY). */

SELECT * 
FROM ( SELECT EMP_ID, F_NAME, L_NAME, DEP_ID FROM employees) 
AS EMP4ALL;

/*-----------------------------------------------------------------------------------------------*/
/* Working with Multiple Tables */
/* Exercise 1: Accessing Multiple Tables with Sub-Queries*/

/* 1. Retrieve only the EMPLOYEES records that correspond 
to jobs in the JOBS table. */

SELECT *
FROM EMPLOYEES
WHERE JOB_ID IN (SELECT JOB_IDENT FROM JOBS);

/* 2. Retrieve only the list of employees whose 
JOB_TITLE is Jr. Designer. */

SELECT *
FROM EMPLOYEES
WHERE JOB_ID IN (SELECT JOB_IDENT FROM JOBS WHERE JOB_TITLE='Jr. Designer');

/* 3. Retrieve JOB information and who earn more than $70,000. */ 

SELECT JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT
FROM JOBS
WHERE JOB_IDENT IN (SELECT JOB_ID FROM EMPLOYEES WHERE SALARY > 70000);

/* 4. Retrieve JOB information and whose birth 
year is after 1976.  */

SELECT JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT
FROM JOBS
WHERE JOB_IDENT IN (SELECT JOB_ID FROM EMPLOYEES WHERE YEAR(B_DATE)>1976);


/* 5. Retrieve JOB information for female employees 
whose birth year is after 1976. */

SELECT JOB_TITLE, MIN_SALARY,MAX_SALARY,JOB_IDENT
FROM JOBS
WHERE JOB_IDENT IN (SELECT JOB_ID FROM EMPLOYEES WHERE YEAR(B_DATE)>1976 AND SEX='F');

/* Exercise 2: Accessing Multiple Tables with Implicit Joins */
/* 1. Perform an implicit cartesian/cross join between 
EMPLOYEES and JOBS tables.*/

SELECT *
FROM EMPLOYEES, JOBS;

/* 2. Retrieve only the EMPLOYEES records that correspond 
to jobs in the JOBS table. */

SELECT * 
FROM EMPLOYEES, JOBS WHERE EMPLOYEES.JOB_ID=JOBS.JOB_IDENT;

/* 3. Redo the previous query, using shorter aliases 
for table names. */

SELECT * 
FROM EMPLOYEES E, JOBS J WHERE E.JOB_ID=J.JOB_IDENT;

/* 4. Redo the previous query, but retrieve only the 
Employee ID, Employee Name and Job Title. */

SELECT EMP_ID, F_NAME, L_NAME, JOB_TITLE
FROM EMPLOYEES E, JOBS J WHERE E.JOB_ID=J.JOB_IDENT;

/* 5. Redo the previous query, but specify the fully 
qualified column names with aliases in the SELECT clause.*/

SELECT E.EMP_ID, E.F_NAME, E.L_NAME, J.JOB_TITLE
FROM EMPLOYEES E, JOBS J WHERE E.JOB_ID=J.JOB_IDENT;













