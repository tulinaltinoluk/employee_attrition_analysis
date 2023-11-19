


select Top 10 * from ..watson_healthcare

 -- breaking dataset into 2 tables: one for personel info, one for atrition related info/scores
  

 select EmployeeID, Age, Gender, Department, Education, EducationField, Attrition, MaritalStatus, JobRole
 into PersonalInfo
 from watson_healthcare

  select EmployeeID, BusinessTravel, DistanceFromHome, HourlyRate, DailyRate, MonthlyRate, MonthlyIncome,
  EnvironmentSatisfaction, JobInvolvement, JobSatisfaction, NumCompaniesWorked, PercentSalaryHike, 
  PerformanceRating, StandardHours, Shift, TotalWorkingYears, TrainingTimesLastYear, WorkLifeBalance, 
  YearsAtCompany, YearsInCurrentRole, YearsWithCurrManager, RelationshipSatisfaction
  into JobInfo
 from watson_healthcare



 -- Dropping standart hours, because it has only one value.


 ALTER TABLE [dbo].[JobInfo]
 DROP COLUMN StandardHours




  
 -- Need to change datatype because text data does not work in this query.

 ALTER TABLE PersonalInfo
 ALTER COLUMN Attrition nvarchar(50) not null




   -- checking for null and blank values 


  SELECT * FROM ..PersonalInfo
  WHERE 
  EmployeeID in ( null, '') OR
  Age in ( null, '') OR
  Gender in ( null, '') OR
  Department in ( null, '') OR
  Education in ( null, '') OR
  EducationField in ( null, '') OR
  Attrition in ( null, '') OR
  MaritalStatus in ( null, '') OR
  JobRole in ( null, '') 













