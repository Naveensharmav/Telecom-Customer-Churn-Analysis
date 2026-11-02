CREATE DATABASE telco_churn_analysis;
USE telco_churn_analysis;

SELECT COUNT(*) FROM telcocustomerchurn_raw;

SELECT * FROM telcocustomerchurn_raw LIMIT 20; 

SELECT COUNT(DISTINCT customerID) FROM telcocustomerchurn_raw; -- unique identifier

DESCRIBE telcocustomerchurn_raw;

SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'telcocustomerchurn_raw'
AND TABLE_SCHEMA = 'telco_churn_analysis';

SELECT 
	customerID,
	COUNT(*) AS isduplicates
 FROM telcocustomerchurn_raw
 GROUP BY customerID
 HAVING COUNT(*) > 1; -- NO DUPLICATES 

SELECT 
	MIN(TotalCharges),
	MAX(TotalCharges)
FROM telcocustomerchurn_raw; -- min is blank

SELECT 
	MIN(tenure),
	MAX(tenure)
FROM telcocustomerchurn_raw;

SELECT COUNT(*) AS Blanks FROM telcocustomerchurn_raw
WHERE TRIM(TotalCharges) = ''; -- 11

SELECT COUNT(*) AS Blanks FROM telcocustomerchurn_raw
WHERE TRIM(tenure) = '' ; -- 0

SELECT COUNT(*) AS Blanks FROM telcocustomerchurn_raw
WHERE TRIM(MonthlyCharges) = '' ; -- 0

SELECT 
	SUM(CASE WHEN tenure < 0 THEN 1 ELSE 0 END) AS negative_tenures,
    SUM(CASE WHEN MonthlyCharges < 0 THEN 1 ELSE 0 END) AS negative_MonthlyCharges,
    SUM(CASE WHEN TotalCharges < 0 THEN 1 ELSE 0 END) AS negative_TotalCharges
FROM telcocustomerchurn_raw;
--  No negative values


SELECT DISTINCT Churn FROM telcocustomerchurn_raw;

SELECT COUNT(*) FROM telcocustomerchurn_raw
WHERE Churn IS NULL OR TRIM(Churn) = '';  

SELECT COUNT(*) FROM telcocustomerchurn_raw
WHERE SeniorCitizen IS NULL OR TRIM(SeniorCitizen) = ''; 

SET SQL_SAFE_UPDATES = 0;

UPDATE telcocustomerchurn_raw
SET TotalCharges = NULLIF(TotalCharges, ' ')
WHERE TRIM(TotalCharges) = '';

SELECT COUNT(*) AS Blanks FROM telcocustomerchurn_raw
WHERE TRIM(TotalCharges) = '' ;

SET SQL_SAFE_UPDATES = 1;


ALTER TABLE telcocustomerchurn_raw
MODIFY MonthlyCharges DECIMAL(10, 2); 

ALTER TABLE telcocustomerchurn_raw
MODIFY TotalCharges DECIMAL(10, 2); 

RENAME TABLE telcocustomerchurn_raw TO telco_customer_churn;

SELECT COUNT(*) AS NULL_CHECKS
FROM telco_customer_churn
WHERE TotalCharges IS NULL;

SELECT tenure, Churn, COUNT(*) AS records
FROM telco_customer_churn
WHERE TotalCharges IS NULL
GROUP BY tenure, Churn;
-- expected: one row, tenure 0, Churn No, 11 records
