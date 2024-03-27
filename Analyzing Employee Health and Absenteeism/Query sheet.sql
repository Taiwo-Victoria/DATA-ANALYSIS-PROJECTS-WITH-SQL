-- Checking through the 3 Tables before joining

SELECT *
FROM Absenteeism_at_work;

SELECT *
FROM Reasons;

SELECT *
FROM compensation;


-- Joining the 3 tables together

SELECT *
FROM Absenteeism_at_work a
LEFT JOIN Reasons r
ON a.Reason_for_absence = r.Number
LEFT JOIN compensation c
ON a.ID = c.ID;

-- Providing a list of healthy individuals and low absenteeism For the healthy bonus program

SELECT ID, Age, Body_mass_index	
FROM Absenteeism_at_work 
-- criterial for healthiness and low absenteeism
WHERE Social_drinker = 0 
		AND Social_smoker = 0 
		AND Body_mass_index BETWEEN 18 AND 24
		AND Absenteeism_time_in_hours < (SELECT AVG(Absenteeism_time_in_hours) FROM Absenteeism_at_work);


-- Compensation for all employees that are Non-Smokers
SELECT COUNT(*) total_non_smokers
FROM Absenteeism_at_work
WHERE Social_smoker = 0;
/*Insurance budget = 983,221
Total work done in a year = (5days_in_a_week) * (8hrs_per_day) * (52_weeks) = 2080 per_hour_in_a_year
For the total_non_smokers = 2080 * 686 = 1,426,880
wage increase per hour = 983,221 / 1,426,880 = 0.689 per hour
wage increase in a year for one non-smoker = 0.689 * 2080 = 1433.12 per year
*/

-- Optimizing the Query to View all the Absenteeism dataset focusing on needed attributes for the dashboard
SELECT a.ID,
		r.Number,
		a.Month_of_absence,
		a.Day_of_the_week,
		a.Transportation_expense,
		a.Body_mass_index,
		CASE WHEN a.Body_mass_index < 18 THEN 'Underweight'
			 WHEN a. Body_mass_index BETWEEN 18 AND 24 THEN 'Healthy_weight'
			 WHEN a.Body_mass_index BETWEEN 25 AND 30 THEN 'Overweight'
			 WHEN a.Body_mass_index > 30 THEN 'Obesity'
			 ELSE 'Unknown' END AS BMI_category,
		CASE WHEN a.Month_of_absence IN (12,1,2) THEN 'Winter'
			 WHEN a.Month_of_absence IN (3,4,5) THEN 'Spring'
			 WHEN a.Month_of_absence IN (6,7,8) THEN 'Summer'
			 WHEN a.Month_of_absence IN (9,10,11) THEN 'Fall'
			 ELSE 'Unknown' END AS Season_Period,
		CASE WHEN a.Distance_from_Residence_to_Work < 20 THEN 'Closeby'
			 WHEN a.Distance_from_Residence_to_Work BETWEEN 20 AND 50 THEN 'Normal'
			 WHEN a.Distance_from_Residence_to_Work > 50 THEN 'Far'
			 ELSE 'Unknown' END AS Residence_distance_from_workplace,
		a.Age,
		CASE WHEN a.Age < 36 THEN 'Youth'
			 WHEN a.Age BETWEEN 36 AND 60 THEN 'Adult'
			 WHEN a.Age > 50 THEN 'Old'
			 ELSE 'Unknown' END AS Age_range,
c.comp_hr,
a.Disciplinary_failure,
a.Education,
a.Pet,
a.Social_drinker,
a.Social_smoker,
a.Son,
a.Work_load_Average_day
FROM Absenteeism_at_work a
LEFT JOIN Reasons r
ON a.Reason_for_absence = r.Number
LEFT JOIN compensation c
ON a.ID = c.ID;
