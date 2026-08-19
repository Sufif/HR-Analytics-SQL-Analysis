create table employee(
	employee_id int,
	employey_name varchar(100),
	department varchar(100),
	salary numeric(10,2),
	manager_id int
);

insert into employee values(1,'sufi','Data Analyst',33000,101);
insert into employee values(2,'sufiyan','Data Analyst',35000,101),
							(3,'shkh','Data scince',40000,102),
							(4,'saif','web developer',35000,103),
							(5,'ibrahim','Data Analystt',300,null),
							(6,'ibra','web developer',30,null);

select * from employee;

alter table employee
rename column employey_name to employee_name;
--Q1:
select employey_name,department,salary
from employee
where department='Data Analyst'
order by salary desc;

--Q2:
select department,count(*)
from employee
group by department
having count(*)>=2;

--Q3:
select max(salary) as secord_max_salary
from employee
where salary< (select max(salary) from employee);

--Q4:
select employee_name,salary,avg(salary)
from employee
where salary>(select avg(salary)from employee)
group by employee_name,salary;

--Q5:
select department,max(salary)
from employee
group by department;


--Q6:
select * from 
employee e 
join
employee m
on 
e.employee_id=m.employee_id
where e.salary>m.salary;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
-------------------------------------------------------------------------------------------------------
--Q7:
select o.order_id,c.name,o.total_amount
from customers c
join
Orders o
on
c.customer_id=o.customer_id;


--Q8:
select c.customer_id,o.order_id,c.name,o.total_amount
from customers c
 left join
Orders o
on
c.customer_id=o.customer_id
where o.customer_id is null;


--Q9:
select c.name,count(*)
from customers c
join orders o
on
c.customer_id=o.customer_id
group by c.name
having count(*) >1;


--Q10:
select c.customer_id,c.name,sum(o.total_amount)
from customers c
join orders o
on
c.customer_id=o.customer_id
group by c.customer_id,c.name
order by sum(o.total_amount) desc
limit 1;

--Q11:
select employee_name,salary,
	row_number()over(order by salary desc) as Row_func,
	rank()over(order by salary desc) as Rank_func,
	dense_rank()over(order by salary desc) as dence_rank_func
from employee;

select * from employee;



--------------------------------------------------------------------------------------------------------------------
--Windows Function:
--Row_Number():
select * ,row_number()over( partition by department order by salary desc) as row_rank
from employee;

select * from (
select *,row_number() over(partition by department order by salary desc) as rnk
from employee
) as temprary
where rnk=1
order by salary desc;
--------------------------------------------------------------------------------------------------------------------
--Rank():
select *,rank() over(partition by department order by salary desc) as Rank_func
from employee;



---------------------------------------------Find Nth Number-----------------------------------------------------------------------
--Dense_Rank():
select * from (
select *,dense_rank() over(order by salary desc) as nth
from employee) as temporar
where nth=1;
--------------------------------------------------------------------------------------------------------------------
--Dence_Rank():
select *,dense_rank() over(partition  by department order by salary) as dence_func
from employee;

--------------------------------------------------------------------------------------------------------------------
--LAG(): Previous
select *,lag(salary) over(order by salary desc) as lag_func
from employee;

--------------------------------------------------------------------------------------------------------------------
--Lead(): Forward
select*,lead(salary) over(order by salary desc) as lead_func
from employee;


--------------------------------------------------------------------------------------------------------------------
---------------------------------------------------CTE'S-----------------------------------------------------------------
with demo as(
	select max(salary) as max_salary from employee
)
select employee_id,employee_name,salary from employee
where salary=(select max_salary from demo);


select *
from employee
where salary=(select max(salary) from employee where salary <(select max(salary) from employee));



-----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------Practise-----------------------------------------------------------------
select * from emp;
--Q1:
with demo as (
	select department,count(employee_count) as Total_employee
	from emp
	group by department
	) 
select * from demo;

--Q2:
with demo as(
	select department,avg(monthly_income) as avg_salary
	from emp
	group by department
)
select department,round(avg_salary,2) as avg_salary
from demo
where avg_salary>(select avg(monthly_income) from emp);

--Q3:
with demo as (
	select employee_number,job_role,avg(monthly_income) as avg_income
	from emp
	group by employee_number,job_role
)
select employee_number,job_role,round(avg_income,2) as Avg_salary
from demo
where avg_income>(select avg(monthly_income) from emp)
order by Avg_salary desc ;

--Q4:
with demo as (
	select department,
	count(employee_count)as total_employee,
	count(employee_count) filter (where(attrition='Yes'))as Exited,
	count(employee_count) filter (where(attrition='Yes'))*100.0/count(employee_count) as Attrition_rate
	from emp
	group by department
)
select * from demo;

--Q5:
with demo as (
	select department,count(employee_count) as Total_emp,total_working_years 
	from emp
	group by department ,total_working_years 
)
select 
		department,
		Total_emp,
		total_working_years 
		from demo
		where total_working_years >=10;

--Q6:
with demo as (
	select department,
	avg(monthly_income) as avg_salary,
	rank() over(order by avg(monthly_income) desc) as rnk
	from emp
	group by department
)
select * from demo;


--Q7:
with demo as(
	select department,
	count(employee_count)as Total_employee,
	count(employee_count) filter(where(attrition='Yes')) as Exited,
	count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count) as Attrition_rate
	from emp
	group by department
)
select * from demo
where Attrition_rate>(select count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count) from emp);


--Q8:
with demo as(
	select overtime,round(avg(monthly_income),2) as avg_Income
	from emp
	group by overtime
)
select * from  demo;

--Q9:
with demo as (
	select job_role,
			count(employee_count) as Total_employee,
			sum(monthly_income) as Total_income,
			round(avg(monthly_income),2) as avg_income,
			min(monthly_income),
			max(monthly_income)
			from emp
			group by job_role
)
select * from demo
order by  Total_income desc limit 5;


--Q10:
with demo as(
	select 
		case 
			when years_at_company<6 then 'Junior'
			when years_at_company>=6 and years_at_company<11 then 'Mid-level'
			when years_at_company>=11 and years_at_company<21 then 'Senior'
			else 'Except'
		end as category,
	count(employee_count) as Total_employee,
	count(employee_count) filter(where(attrition='Yes')) as Exited,
	round(avg(monthly_income),2) as average_Salary,
	round(count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count),2) as Attrition_Rate
	from emp
	group by category	
)
select * from demo;


--Q11:
with demo as (
	select employee_number,
		job_role,
		monthly_income,
		rank() over(order by monthly_income desc)
		from emp
)

select * from demo;


--Q12:
with demo as(
	select 
	employee_number,
	department,
	monthly_income,
	rank() over(partition by department order by monthly_income desc)
	from emp
)
select * from demo;


--Q13:
with demo as(
	select employee_number,
			department,
			monthly_income,
			rank() over(partition by department order by monthly_income desc) as rnk
			from emp
)
select * from demo
where rnk<4;


--Q14:
with demo as (
	select
	employee_number,
	monthly_income,
	department,
	round(avg(monthly_income) over(partition by department,2))as department_avg_salary
	from emp
)
select 
	employee_number,
	monthly_income,
	department,
	round(department_avg_salary,2)as department_avg_salary,
	round(monthly_income - department_avg_salary ) as salary_difference
from demo;



--Q15:
with demo as (
	select 
		employee_number,
		department,
		monthly_income,
		sum(monthly_income) over (partition by department),
		round(monthly_income*100.0/sum(monthly_income) over (partition by department),2)
		from emp
	group by employee_number,department,monthly_income	
)
select * from demo;


--Q16:
with demo as (
	select employee_number,
	department,
	monthly_income,
	lag(monthly_income) over(partition by department) 
	from emp	
)
select * from demo;


--Q17:
with demo as (
	select employee_number,
	department,
	monthly_income,
	lag(monthly_income) over(partition by department) ,
	monthly_income - lag(monthly_income) over(partition by department) as Salary_difference_with_Previous
	from emp	
)
select * from demo;


--Q18:
select 
	employee_number,
	department,
	total_working_years,
	lag(total_working_years) over(partition by department),
	total_working_years - lag(total_working_years) over(partition by department) as experience_differnce
from emp;
	

--Q19:
select 
	employee_number,
	department,
	total_working_years,
	lead(total_working_years) over(partition by department)
from emp;


--Q20:
select 
	employee_number,
	job_role,
	monthly_income,
	lead(monthly_income) over(partition by job_role) as next_emp_salary,
	monthly_income - lead(monthly_income) over(partition by job_role order by monthly_income desc) as salary_Difference
from emp;


--Q21:
with demo as (
	select 
		employee_number,
		job_role,
		monthly_income,
		rank() over(partition by job_role order by monthly_income desc) as rnk
		from emp
)
select * from demo
where rnk<=2;


--Q22:
with demo as (
	select employee_number,
			department,
			monthly_income,
			row_number() over(partition by department order by monthly_income desc) as rnk
	from emp
)
select * from demo
where rnk=1;


--Q23:
with demo as (
	select employee_number,
		department,
		monthly_income,
		rank() over(partition by department order by monthly_income desc) as rnk
		from emp
)
select * from demo
where rnk=2;


--Q24:
with demo as (
	select
	rank() over ( partition by department order by monthly_income desc),
	employee_number,
	department,
	monthly_income,
	round(avg(monthly_income) over(partition by department),2) as department_avg_salary,
	monthly_income - round(avg(monthly_income) over(partition by department),2) as Salary_Difference
	from emp
	group by employee_number,department,monthly_income
)
select * from demo
where monthly_income>department_avg_salary;


--Q25:
with demo as (
	select 
		employee_number,
		department,
		monthly_income,
		avg(monthly_income) over(partition by department) as department_avg_salary
		from emp
)
select employee_number,
	department,
	monthly_income,
	round(department_avg_salary,2) as department_avg_salary,
	case 
		when monthly_income<department_avg_salary then 'Below Average'
		when monthly_income=department_avg_salary then 'Equal to Average'
		else 'Above Average'
	end as Category
from demo;


--Q26:
select 
	case
		when monthly_income<5000 then 'Lowest Salary Group'
		when monthly_income>=5000 and  monthly_income<7000 then 'intermidiat salary group'
		when monthly_income>=7000 and  monthly_income<10000 then 'high salary group'
		else 'Highest salary group'
	end as salary_category,
	count(employee_count)as Total_employee,
	count(employee_count) filter (where(attrition='Yes')) as Exited,
	count(employee_count) filter (where(attrition='Yes'))*100.0/count(employee_count) as Attrition_rate
from emp
group by salary_category;


--Q27:
select 
	case 
		when total_working_years<5 then 'Early Stage'
		when total_working_years>=5 and total_working_years<10 then 'Intermediat Stage'
		when total_working_years>=10 and total_working_years<20 then 'Higher Level Stage'
		else 'Expert'
	end 
		as Exprirence_Category,
	count(employee_count)as Total_empployee,
	avg(monthly_income) Avg_Salary,
	count(employee_count) filter(where(attrition='Yes')) as Exited_employee,
	count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count) as Attrition_rate
from emp
group by Exprirence_Category;
	
	
--Q29:
select 
	employee_number,
	department,
	count(employee_number) over(partition by department order by employee_number)
from emp;
		


--Q30:
select 
	employee_number,
	department,
	monthly_income,
	avg(monthly_income) over(partition by department order by employee_number) as Running_Average
from emp;



--Q31;
with demo as(
	select 
		employee_number,
		overtime,
		environment_satisfaction,
		work_life_balance,
		years_since_last_promotion,
		job_involvement
	from emp
)
select * from demo
where overtime='Yes' and environment_satisfaction<2 and work_life_balance<2 and years_since_last_promotion>5 and job_involvement<2;


--Q32:
with demo as (
	select 
		department,
		count(employee_count) as Total_Employee,
		count(employee_count) filter(where(attrition='Yes')) as Exited_Employee,
		count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count) as Attrition_Rate,
		rank() over(order by count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count) desc) as rnk
	from emp
	group by department
)
select * from demo;



--Q33:
with demo as(
	select 
		department,
		count(employee_count) as Total_Employee,
		count(employee_count) filter(where(attrition='Yes')) as Exited_employee,
		count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count) as Attrition_Rate,
		lag(count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count))
		over(order by department) as Previous_Attrition_Rate
		from emp
		group by department	
)
select *,attrition_rate - Previous_Attrition_Rate from demo;



--Q34:
with demo as (
	select 
	employee_number,
	department,
	monthly_income,
	round(avg(monthly_income) over(partition by department),2) as Department_Average_Income
	from emp
)
select * ,case when monthly_income> Department_Average_Income then 'Above Average' else 'Below Average' end as persentage_category
from demo;

	

--Q35:
with demo1 as (
		select 
			job_role,
			avg(monthly_income) as avg_income,
			count(employee_count) filter(where(attrition='Yes'))*100.0/count(employee_count) as Attrition_Rate,
			avg(job_satisfaction) as Satisfaction
		from emp
		group by job_role
),
demo2 as (

		select *, percent_rank() over(order by avg_income) as salary_score,
					 percent_rank() over(order by  Attrition_Rate) as attrition_score,
					 percent_rank() over(order by  Satisfaction) as Satisfaction_score
				from demo1
),
demo3 as (

		select *, (salary_score+attrition_score+Satisfaction_score)/3.0 as overall
				from demo2
				)			
select * ,rank() over(order by overall desc) as job_rank_role from demo3
order by job_rank_role ;
	








