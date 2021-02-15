-- Create the database
create database "PH-EmployeeDB";

-- Create the tables
CREATE TABLE "departments" (
    "dept_no" varchar   NOT NULL,
    "dept_name" varchar   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "birthdate" date   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "gender" varchar   NOT NULL,
    "hire_date" varchar   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "managers" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_managers" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "dept_emp" (
    "dept_no" varchar   NOT NULL,
    "emp_no" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" int   NOT NULL,
    "title" varchar   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "emp_no","title"
     )
);

ALTER TABLE "managers" ADD CONSTRAINT "fk_managers_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "managers" ADD CONSTRAINT "fk_managers_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Deliverable 1
select e.emp_no,
       e.first_name,
       e.last_name,
       t.title,
       t.from_date,
       t.to_date
into retirement_titles
from employees e
left join titles t on e.emp_no = t.emp_no
where e.birthdate between '1952-01-01' and '1955-12-31';

-- Create a unique titles table
SELECT DISTINCT ON (emp_no)
       emp_no,
       first_name,
       last_name,
       title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Sum of retiring titles
select count(title) as count,
       title
from unique_titles
group by title
order by count desc;

-- Deliverable 2
select distinct on (e.emp_no)
       e.emp_no,
       e.first_name,
       e.last_name,
       e.birthdate,
       de.from_date,
       de.to_date,
       t.title
into mentorship_eligibility
from employees e
inner join titles t on e.emp_no = t.emp_no
inner join dept_emp de on e.emp_no = de.emp_no
where e.birthdate between '1965-01-01' and '1965-12-31'
order by e.emp_no;