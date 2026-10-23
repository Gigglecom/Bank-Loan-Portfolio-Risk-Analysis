-- BANK LOAN PORTFOLIO & RISK ANALYSIS
-- Q5–Q8: Credit risk
-- SQL Server (T-SQL) | Historical loan issuances: 2007–2011
-- Requires a table named dbo.loan in the active database.
-- Original user SQL reviewed and selectively corrected; execute locally to verify.

-- BUSINESS QUESTION 5
-- Portfolio Charge-Off Rate Analysis
SELECT
COUNT(*) AS TotalLoans,
SUM(
    CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END
) AS Total_chargedOff,
SUM(
    CASE WHEN loan_status IN ('Fully Paid', 'Charged Off') THEN 1 ELSE 0 END
) AS Resolved_loan,

ROUND(
    CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END)/
    NULLIF(COUNT(*), 0) AS DECIMAL(18,2)), 2
) AS Overall_ChargedOff_Percent,

ROUND(
    CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN loan_status IN ('Fully Paid', 'Charged Off') THEN 1 ELSE 0 END) ,0) AS DECIMAL(18,2)), 2
) AS Overall_resolved_percent

FROM dbo.loan;

-- BUSINESS QUESTION 6A
-- Credit Grade vs Charge-Off Rate
SELECT 
grade AS Credit_Grade,
COUNT(*) AS TotalLoan,
SUM(
    CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END
) AS Total_Charged_Off,
SUM(
    CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE 0 END
) AS Total_FullyPaid,
SUM(
    CASE WHEN loan_status = 'Current' THEN 1 ELSE 0 END
) AS Total_Current,

ROUND( CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN loan_status IN ('Fully Paid', 'Charged Off') THEN 1 ELSE 0 END) ,0)
    AS DECIMAL(18,2)) ,2) AS Total_ChargedOFF
    

FROM dbo.loan
GROUP BY grade
Order By Total_ChargedOFF DESC;

-- BUSINESS QUESTION 6B
-- Credit Subgrade vs Charge-Off Rate

SELECT
grade AS Grade,
sub_grade,
COUNT(*) AS TotalLoans,
SUM(
    CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END
) AS Total_chargedOff,
SUM(
    CASE WHEN loan_status IN ('Fully Paid', 'Charged Off') THEN 1 ELSE 0 END
) AS Resolved_loan,

ROUND( CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN loan_status IN ('Fully Paid', 'Charged Off') THEN 1 ELSE 0 END) ,0)
    AS DECIMAL(18,2)) ,2) AS ChargedOFF_Rate_percent

FROM dbo.loan
Group By grade, sub_grade
Order By ChargedOFF_Rate_percent DESC;

-- BUSINESS QUESTION 7A
-- Average DTI by Loan Status
SELECT
loan_status,
COUNT(*) AS TotalLoan,
CAST(AVG(CAST(dti AS DECIMAL(18,2))) AS DECIMAL(18,2)) AS Avg_Dti,
ROUND(MAX(dti), 2) AS MAX_dti,
MIN(dti) AS MIN_dti
FROM dbo.loan

GROUP BY loan_status;

-- BUSINESS QUESTION 7B
-- DTI Segmentation and Charge-Off Analysis
WITH Dti_Category AS (
    SELECT
    loan_status,
    CASE 
        WHEN dti IS NULL THEN 'Unknown'
        WHEN dti < 10 THEN 'Below 10%'
        WHEN dti < 20 THEN '10 - 19.99%'
        WHEN dti < 30 THEN '20 - 29.99%'
        ELSE 'Above 30%' END AS DTi_Category_,
    CASE 
        WHEN dti IS NULL THEN 5
        WHEN dti < 10 THEN 1
        WHEN dti < 20 THEN 2
        WHEN dti < 30 THEN 3
        ELSE 4 END AS Sort_Order
    FROM dbo.loan
    WHERE loan_status in ('Fully Paid', 'Charged Off')
  
)

SELECT 
DTi_Category_,
COUNT(*) TotalLoans,
SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS Charged_Off,
ROUND(
      CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END)/
      NULLIF(COUNT(*),0) AS DECIMAL(18,2)), 2
) AS ChargedOff_percent

FROM Dti_Category
GROUP BY DTi_Category_, Sort_Order
ORDER BY Sort_Order;

-- BUSINESS QUESTION 8A
-- Average Interest Rate by Loan Status
SELECT 
loan_status AS Loan_Status,
ROUND(
     CAST( AVG(
      TRY_CONVERT(DECIMAL(18,2), REPLACE(int_rate, '%', ''))
      ) AS DECIMAL(18,2)), 2
) AS AVG_interest_Rate

FROM dbo.loan
Group By loan_status
Order By AVG_interest_Rate DESC;

-- BUSINESS QUESTION 8B
-- Interest Rate Segmentation and Credit Risk
WITH Interest_rate_Category AS(
    SELECT
    loan_status,

    TRY_CONVERT(DECIMAL(18,2), 
    REPLACE(int_rate, '%', '')) AS Int_rate
    FROM dbo.loan
    WHERE loan_status IN ('Fully Paid', 'Charged Off')
), 
GROUP_Category AS(
SELECT
loan_status,
CASE 
    WHEN int_rate IS NULL THEN 'Unknown'
    WHEN int_rate < 10 THEN 'Below 10%'
    WHEN int_rate < 15 THEN '10 - 14.99%'
    WHEN int_rate < 20  THEN '15 - 19.99%'
    ELSE 'Above 20%' END AS IntRate_Category,

CASE 
    WHEN int_rate IS NULL THEN 5
    WHEN int_rate < 10 THEN 1
    WHEN int_rate < 20 THEN 2
    WHEN int_rate < 30 THEN 3
    ELSE 4 END AS Sort_Order

FROM Interest_rate_Category 
)

SELECT
IntRate_Category,
COUNT(*) AS Total_resolvedLoan,
SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS Total_chargedOff,
ROUND(
    CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END)/
    NULLIF(Count(*),0) AS DECIMAL(18,2))
,2) AS ChargedOff_rate

FROM GROUP_Category
GROUP BY IntRate_Category, Sort_Order
Order by Sort_Order;
