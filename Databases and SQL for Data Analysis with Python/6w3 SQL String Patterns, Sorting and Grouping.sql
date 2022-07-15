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

/* 3. Retrieve all employees in department 5 whose salary is between 60000 and 70000. */

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

