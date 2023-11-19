

-- 1)How many employees are working in each department? 

select Department, count(EmployeeID) as empl_count  from [dbo].[PersonalInfo]
group by Department
order by empl_count desc




-- 2)How many employee suffer attrition in each department? 

select Department, count([EmployeeID]) as attrition_count,
(select  count(Attrition) from PersonalInfo
where Attrition = 'Yes') as total_attrition
from PersonalInfo
where Attrition = 'Yes'
group by Department
order by attrition_count desc




 --3) What is attrition percentage of each department? (divided by total attrition count)

with Y  as
(select Department,  count (*) as total_dept_count from PersonalInfo
where Attrition = 'Yes'  group by Department )

select  Department,   total_dept_count * 100 /  (select sum(total_dept_count) from Y) as attrition_rate 
from Y
order by attrition_rate desc




 --4)How is average monthly income of attrition sufferers by department?

select a.Department, AVG(b.MonthlyIncome) as avg_income_attrition
from PersonalInfo a 
join JobInfo b
on a.[EmployeeID] = b.[EmployeeID]
where a.Attrition = 'Yes'
group by  a.Department
order by avg_income_attrition desc



 
  -- 5)How is work life balance scores of attrition sufferers?

 select case when
b.WorkLifeBalance = '1' then 'Bad' 
when  b.WorkLifeBalance = '2' then 'Good' 
when b.WorkLifeBalance = '3' then 'Better'
 else 'Best'
 end as Work_Life_Balance, count (b.WorkLifeBalance) as total_count
from PersonalInfo a
join JobInfo b
on a.[EmployeeID] = b.[EmployeeID]
where a.Attrition = 'Yes'
group by b.WorkLifeBalance





-- 6)How is work life balance score is correlated with monthly income and workplace distance from home?

select distinct
case when
WorkLifeBalance = '1' then 'Bad' 
when WorkLifeBalance = '2' then 'Good' 
when WorkLifeBalance = '3' then 'Better'
 else 'Best'
 end as Work_Life_Balance,  AVG(MonthlyIncome) over( partition by WorkLifeBalance) as avg_income, 
 AVG(DistanceFromHome) over( partition by WorkLifeBalance) as avg_distance_from_home
 from JobInfo
 order by avg_income desc





   --7) How is employee gender distribution among attrition sufferers?

   select Gender, count([EmployeeID]) as attrition_count from PersonalInfo
   Where Attrition = 'Yes'
   GROUP BY Gender



  
  -- 8) How is employee gender distribution by department?

 
 Select distinct Gender, Department,
 count(*) over ( partition by Gender, department ) as total_count from PersonalInfo 
 order by Department





 -- 9)How is employee gender distribution among attrition sufferers by department?


 Select distinct Gender, Department,
 count(*) over ( partition by Gender, department ) as attr_total_count from PersonalInfo 
 Where Attrition = 'Yes'
 order by Department



 -- 10) Which job is the majority in each department

 Select distinct  Department, JobRole as top_job from PersonalInfo
 Where JobRole =
 (select TOP 1 JobRole 
 from PersonalInfo 
 group by JobRole
 order by count(JobRole) desc)




 -- 11)Which job is the majority among attrition sufferers in each department?

  Select distinct Department, JobRole as top_job from PersonalInfo
 Where JobRole =
 (select TOP 1 JobRole 
 from PersonalInfo 
 group by JobRole
 order by count(JobRole) desc) and Attrition = 'Yes'



 -- 12)How many employees are in each job role?

 select JobRole , count (*) as total_employee from PersonalInfo 
 group by JobRole order by total_employee desc





 --13) How many employees are working in each department from top 1 job role?

 SELECT Department, count(JobRole) as total_count_top_employee
 FROM PersonalInfo 
 WHERE JobRole = (
 SELECT TOP 1 JobRole FROM PersonalInfo GROUP BY JobRole ORDER BY Count(JobRole) desc)
 GROUP BY Department
 ORDER BY total_count_top_employee desc



 -- 14)How much are the scores of different jobs in each departments' overall job satisfaction ?

SELECT b.Department, b. JobRole, 
avg(a.RelationshipSatisfaction) as relationship_score,
avg(a.EnvironmentSatisfaction) as environment_satisfaction,
avg(a.JobSatisfaction) as job_satisfaction,
avg(a.WorkLifeBalance) as work_life_balance,
count (a.EmployeeID) as count_of_employee
 FROM JobInfo a
JOIN PersonalInfo b
 ON a.EmployeeID = b.EmployeeID
 group  by b.Department, b. JobRole
 order by b.Department desc


  -- 15) Is there a gender inequality based on salary in every department?

   SELECT  distinct a.Department,   a.Gender,
 count(b.EmployeeID) over (partition by a.Department, a. Gender) as total_count_of_employee, 
 avg(b.MonthlyIncome) over (partition by a.Department,  a. Gender) as avg_income
 From PersonalInfo a
 JOIN JobInfo b 
 ON a.EmployeeID = b.EmployeeID



 -- 16)How many employee in each department have income higher than the average income of their own department?

Select   distinct  a.JobRole , count(a.EmployeeID) as personel_count, avg(b.MonthlyIncome) as avg_income
From PersonalInfo a
JOIN JobInfo b  ON a.EmployeeID = b.EmployeeID
where b.MonthlyIncome > (select avg(MonthlyIncome) from JobInfo )
group by a.JobRole 
order by avg_income desc 


 -- 17)What is the percentage of each job role in each department?
  -- Using CTE:

with t  as
(
select Department, EducationField, count (*) as total_count_in_dept from PersonalInfo
group by 
Department, EducationField )

select  Department, EducationField as Field, total_count_in_dept,  total_count_in_dept * 100 / (select sum(total_count_in_dept) from t) as percentage_
from t
order by 4 desc






