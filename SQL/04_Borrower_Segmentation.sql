-- BANK LOAN PORTFOLIO & RISK ANALYSIS
-- Q9–Q12: Borrower segmentation
-- SQL Server (T-SQL) | Historical loan issuances: 2007–2011
-- Requires a table named dbo.loan in the active database.
-- Original user SQL reviewed and selectively corrected; execute locally to verify.

-- BUSINESS QUESTION 9A
-- Average Annual Income by Loan Status
SELECT
loan_status,
COUNT(*) TotalLoan,
ROUND(
CAST(AVG(CAST(annual_inc AS DECIMAL(18,2))) AS DECIMAL(18,2)),2) AS AVG_AnnualIncome,
MAX(annual_inc) AS MAX_Annula_Income,
MIN(annual_inc) AS MIN_Annual_Income

FROM dbo.loan
GROUP BY loan_status
ORDER BY AVG_AnnualIncome;

-- BUSINESS QUESTION 9B
-- Annual Income Segmentation and Charge-Off Risk
WITH INCOME_Groups AS (
    SELECT
    loan_status,
    CASE
        WHEN annual_inc IS NULL THEN 'Unknown'
        WHEN annual_inc < 30000 THEN 'Below 30K'
        WHEN annual_inc < 50000 THEN '30K - 49.99K'
        WHEN annual_inc < 75000 THEN '50k - 74.99k'
        WHEN annual_inc < 100000 THEN '75k - 99.99k'
        ELSE 'Above 100K' END AS Income_Category,
    CASE 
    WHEN annual_inc IS NULL THEN 6
    WHEN annual_inc < 30000 THEN 1
    WHEN annual_inc < 50000 THEN 2
    WHEN annual_inc < 75000 THEN 3
    WHEN annual_inc < 100000 THEN 4
    ELSE 5 END AS Sort_Order

    FROM dbo.loan
    WHERE loan_status IN ('Fully Paid', 'Charged Off'))

    SELECT
    Income_Category,
    COUNT(*) AS Resolved_Loan,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS TotalCharged, 
    ROUND(
          CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) /
          NULLIF(COUNT(*) ,0) AS DECIMAL(18,2)),2) AS Charged_rate
    FROM INCOME_Groups
    Group By Income_Category, Sort_Order
    Order By Sort_Order;


-- BUSINESS QUESTION 10A
-- Employment Length Distribution
SELECT
COALESCE(NULLIF(LTRIM(RTRIM(emp_length)),''),'Unknown') AS EmploymentLength,
COUNT(*) TotalLoans,
SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS Total_ChargedOff,
SUM(CASE WHEN loan_status = 'Fully Paid' THEN 1 ELSE 0 END) AS Total_FullyPaid,
SUM(CASE WHEN loan_status = 'Current' THEN 1 ELSE 0 END) As TotalCurrent
FROM dbo.loan
GROUP BY COALESCE(NULLIF(LTRIM(RTRIM(emp_length)),''),'Unknown')
Order By TotalLoans DESC;

-- BUSINESS QUESTION 10B
-- Employment Length and Charge-Off Rate
SELECT
COALESCE(NULLIF(LTRIM(RTRIM(emp_length)),''),'Unknown') AS EmploymentLength,
COUNT(*) TotalResolvedLoans,
SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS Total_ChargedOff,
ROUND(
          CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) /
          NULLIF(COUNT(*) ,0) AS DECIMAL(18,2)),2) AS Charged_rate
FROM dbo.loan
WHERE loan_status IN ('Charged Off', 'Fully Paid')
Group By COALESCE(NULLIF(LTRIM(RTRIM(emp_length)),''),'Unknown')
Order By Charged_rate;

-- BUSINESS QUESTION 11A
-- Homeownership Status Distribution
SELECT
COALESCE(
NULLIF(LTRIM(RTRIM(home_ownership)), '')
, 'Unknown') AS Home_Ownership,
COUNT(*) AS TotalLoans,
SUM(CASE WHEN loan_status='Charged Off' THEN 1 ELSE 0 END) AS Total_ChargedOff,
SUM(CASE WHEN loan_status='Fully Paid' THEN 1 ELSE 0 END) AS Total_FullyPaid,
SUM(CASE WHEN loan_status='Current' THEN 1 ELSE 0 END) AS Total_Current

FROM dbo.loan
GROUP BY COALESCE(
NULLIF(LTRIM(RTRIM(home_ownership)), '')
, 'Unknown')
ORDER BY TotalLoans;

-- BUSINESS QUESTION 11B
-- Homeownership and Charge-Off Risk
SELECT
COALESCE(
NULLIF(LTRIM(RTRIM(home_ownership)), '')
, 'Unknown') AS Home_Ownership,
COUNT(*) AS TotalLoans,
SUM(CASE WHEN loan_status='Charged Off' THEN 1 ELSE 0 END) AS Total_ChargedOff,
ROUND(
          CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) /
          NULLIF(COUNT(*) ,0) AS DECIMAL(18,2)),2) AS Charged_rate,
SUM(CAST(funded_amnt AS bigint)) AS Total_FundedAmount

FROM dbo.loan
WHERE loan_status IN ('Charged Off', 'Fully Paid')
GROUP BY COALESCE(
NULLIF(LTRIM(RTRIM(home_ownership)), '')
, 'Unknown') 
ORDER BY Total_ChargedOff DESC;

-- BUSINESS QUESTION 12A
-- Loan Purpose Distribution
SELECT 
purpose AS Loan_Purpose,
COUNT(*) AS TotalLoans,
SUM(CASE WHEN loan_status='Charged Off' THEN 1 ELSE 0 END) AS Total_ChargedOff,
SUM(CASE WHEN loan_status='Fully Paid' THEN 1 ELSE 0 END) AS Total_FullyPaid,
SUM(CASE WHEN loan_status='Current' THEN 1 ELSE 0 END) AS Total_Current,
SUM(CAST(funded_amnt AS bigint)) AS Funded_Amount

FROM dbo.loan
GROUP BY purpose
ORDER BY TotalLoans DESC;

-- BUSINESS QUESTION 12B
-- Loan Purpose and Credit Risk
SELECT 
purpose AS Loan_Purpose,
COUNT(*) AS Resolved_Loans,
SUM(CASE WHEN loan_status='Charged Off' THEN 1 ELSE 0 END) AS Total_ChargedOff,
ROUND(
          CAST(100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) /
          NULLIF(COUNT(*) ,0) AS DECIMAL(18,2)),2) AS Charged_rate,
SUM(CAST(funded_amnt AS bigint)) AS Total_FundedAmount,
SUM(CASE 
        WHEN loan_status = 'Charged Off' THEN CAST(funded_amnt AS bigint) ELSE 0 END 
   ) AS Original_Funding

FROM dbo.loan
WHERE loan_status IN ('Charged Off', 'Fully Paid')
GROUP BY purpose
ORDER BY Charged_rate DESC;
