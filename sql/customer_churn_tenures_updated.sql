USE telco_churn_analysis;

/* -------------------------------
	Exploratory Data Analysis
-------------------------------- */

-- Overall churn performance
SELECT 
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS active_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate,
    ROUND(SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS retained_rate
FROM telco_customer_churn;

-- Customer segments and churn patterns

-- 1. Which contract type (month-to-month, one-year, or two-year) has the highest churn rate?

SELECT 
	Contract,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY Contract
ORDER BY churn_rate DESC;

-- 2. Which payment method is associated with the highest churn rate?

SELECT 
	PaymentMethod,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- 3. How does churn rate differ between customers with different internet service types?

SELECT 
	InternetService,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY InternetService
ORDER BY churn_rate DESC;
    
    
-- 4. Which tenure group has the highest churn rate? (also answers: are shorter-tenure customers more likely to churn?)

SELECT 
	CASE
		WHEN tenure BETWEEN 0 AND 6 THEN '0-6 mo'
        WHEN tenure BETWEEN 7 AND 12 THEN '7-12 mo'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 mo'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 mo'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 mo'
	END AS tenure_bands,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn 
GROUP BY tenure_bands
ORDER BY churn_rate DESC;


-- 5. How does churn rate vary across monthly charge brackets?

SELECT
    CASE
        WHEN MonthlyCharges < 35 THEN 'Under 35'
        WHEN MonthlyCharges < 70 THEN '35 - 69.99'
        WHEN MonthlyCharges < 90 THEN '70 - 89.99'
        ELSE '90 and above'
    END AS monthly_charge_bracket,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY monthly_charge_bracket
ORDER BY MIN(MonthlyCharges);


-- 6. Does churn differ between customers who use paperless billing and those who do not?

SELECT 
	PaperlessBilling,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY PaperlessBilling
ORDER BY churn_rate DESC;

-- 7. Does churn differ between customers demographics?

-- Gender

SELECT 
    gender,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY 
	gender
ORDER BY churn_rate DESC;

-- Senior Citizens

SELECT 
    CASE 
		WHEN SeniorCitizen = 1 THEN 'Yes' 
		ELSE 'No' 
	END AS senior_citizen_flag,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY 
	SeniorCitizen
ORDER BY churn_rate DESC;

-- gender and senior_citizens combined

SELECT 
	gender,
    CASE 
		WHEN SeniorCitizen = 1 THEN 'Yes' 
		ELSE 'No' 
	END AS senior_citizen_flag,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY 
	gender,
	SeniorCitizen
ORDER BY churn_rate DESC;

-- Partners

SELECT 
    Partner,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY 
	Partner
ORDER BY churn_rate DESC; 

-- Dependents

SELECT 
    Dependents,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY 
	Dependents
ORDER BY churn_rate DESC; 
	
-- 8. How does churn rate vary across OnlineSecurity?

SELECT 
    OnlineSecurity,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY 
	OnlineSecurity
ORDER BY churn_rate DESC; 

-- 9. How does churn rate vary across TechSupport?

SELECT 
    TechSupport,
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn
GROUP BY 
	TechSupport
ORDER BY churn_rate DESC;

-- Customer tenure and charges
 
-- 1. Compare average tenure of churned vs retained customers.

SELECT 
	CASE 
		WHEN Churn = 'Yes' THEN 'Churned'
		ELSE 'Retained'
	END AS Customer_status,
    ROUND(AVG(tenure), 2) AS Avg_tenure
FROM telco_customer_churn
GROUP BY Churn;
    
-- 2.  What is the average monthly charge for churned versus retained customers?

SELECT 
	CASE 
		WHEN Churn = 'Yes' THEN 'Churned'
        ELSE 'Retained'
	END AS Customer_status,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM telco_customer_churn
GROUP BY Churn;

--  How does total spending differ between churned and retained customers?

SELECT 
	CASE 
		WHEN Churn = 'Yes' THEN 'Churned'
        ELSE 'Retained'
	END AS Customer_status,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges
FROM telco_customer_churn
GROUP BY Churn;

-- How do contract type and tenure together relate to churn rate? 

SELECT 
	Contract,
	CASE
		WHEN tenure BETWEEN 0 AND 6 THEN '0-6 mo'
        WHEN tenure BETWEEN 7 AND 12 THEN '7-12 mo'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 mo'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 mo'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 mo'
	END AS tenure_bands,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn 
GROUP BY 
	Contract,
	tenure_bands
ORDER BY churn_rate DESC;

-- How do contract type and internet service together relate to churn rate? 

SELECT 
	Contract,
	InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_cust,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100/ COUNT(*), 2) AS churn_rate
FROM telco_customer_churn 
GROUP BY 
	Contract,
	InternetService
ORDER BY Contract, churn_rate DESC;

-- Risk Segmentation Table

CREATE OR REPLACE VIEW v_churn_risk AS
WITH risk_profiling AS
(
	SELECT 
		customerID,
        Contract,
        tenure,
        CASE
			WHEN tenure BETWEEN 0 AND 6 THEN '0-6 mo'
			WHEN tenure BETWEEN 7 AND 12 THEN '7-12 mo'
			WHEN tenure BETWEEN 13 AND 24 THEN '13-24 mo'
			WHEN tenure BETWEEN 25 AND 48 THEN '25-48 mo'
			WHEN tenure BETWEEN 49 AND 72 THEN '49-72 mo'
		END AS tenure_bands,
        InternetService,
        PaperlessBilling,
        MonthlyCharges,
        CASE
			WHEN MonthlyCharges < 35 THEN 'Under 35'
			WHEN MonthlyCharges < 70 THEN '35 - 69.99'
			WHEN MonthlyCharges < 90 THEN '70 - 89.99'
			ELSE '90 and above'
		END AS monthly_charge_bracket,
        PaymentMethod,
        TechSupport,
        SeniorCitizen,
		CASE WHEN Contract = 'Month-to-month' THEN 2 ELSE 0 END AS contract_score,
		CASE WHEN tenure BETWEEN 0 AND 6 THEN 2 ELSE 0 END AS months_0_6_score,
        CASE WHEN tenure BETWEEN 7 AND 12 THEN 1 ELSE 0 END AS months_7_12_score,
		CASE WHEN tenure BETWEEN 13 AND 24 THEN 1 ELSE 0 END AS months_13_24_score,
		CASE WHEN InternetService = 'Fiber optic' THEN 2 ELSE 0 END AS InternetService_score,
		CASE WHEN PaymentMethod = 'Electronic check' THEN 2 ELSE 0 END AS PaymentMethod_score,
		CASE WHEN TechSupport = 'No' THEN 2 ELSE 0 END AS TechSupport_score,
		CASE WHEN SeniorCitizen = 1 THEN 2 ELSE 0 END AS SeniorCitizen_score
	FROM telco_customer_churn
    WHERE Churn = 'No'
), risk_scoring AS
 (
	SELECT 
		customerID,
        Contract,
        tenure,
        tenure_bands,
        InternetService,
        PaperlessBilling,
        MonthlyCharges,
        monthly_charge_bracket,
        PaymentMethod,
        TechSupport,
        SeniorCitizen,
		(contract_score +
		months_0_6_score +
		months_7_12_score +
        months_13_24_score +
		InternetService_score +
		PaymentMethod_score +
		TechSupport_score +
		SeniorCitizen_score) AS total_score_per_customer
	FROM risk_profiling
)
SELECT 
	customerID,
	Contract,
	tenure,
    tenure_bands,
	InternetService,
    PaperlessBilling,
    MonthlyCharges,
    monthly_charge_bracket,
	PaymentMethod,
	TechSupport,
	SeniorCitizen,
	total_score_per_customer,
    CASE 
		WHEN total_score_per_customer BETWEEN 0 AND 3 THEN 'Low Risk'
        WHEN total_score_per_customer BETWEEN 4 AND 7 THEN 'Medium Risk'
        ELSE 'High Risk'
	END AS Risk_profiles
FROM risk_scoring;


SELECT 
	Risk_profiles,
    COUNT(*) AS total_cust
FROM v_churn_risk
GROUP BY Risk_profiles;

SELECT * FROM telco_customer_churn;
SELECT * FROM v_churn_risk;

