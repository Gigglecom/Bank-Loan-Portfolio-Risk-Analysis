-- BANK LOAN PORTFOLIO & RISK ANALYSIS
-- Q1–Q4: Portfolio overview
-- SQL Server (T-SQL) | Historical loan issuances: 2007–2011
-- Requires a table named dbo.loan in the active database.
-- Original user SQL reviewed and selectively corrected; execute locally to verify.

-- Total Number of Loan Applications
SELECT 
COUNT(*) AS Total_Loan_Application
FROM dbo.loan;

-- BANK LOAN PORTFOLIO & RISK ANALYSIS
-- BUSINESS QUESTION 2
-- Total Requested Amount vs Total Funded Amount
SELECT 
COUNT(*) AS TotalLoan,
SUM(CAST(loan_amnt AS bigint)) AS Total_Loan_Amount,
SUM(CAST(funded_amnt AS bigint)) AS Total_funded_Amount,
SUM(CAST(loan_amnt AS bigint) - CAST(funded_amnt AS bigint)) AS Funding_Gap,
CAST(ROUND(
        100.0 * SUM(CAST(funded_amnt AS BIGINT))
        / NULLIF(
            SUM(CAST(loan_amnt AS BIGINT)), 0
        ), 2) AS DECIMAL(5,2)) AS Funding_rate_percentage

FROM dbo.loan;

-- BUSINESS QUESTION 3
-- Average Loan, Interest Rate and DTI
SELECT 
COUNT(*) AS TotalLoans,
ROUND(CAST(AVG(CAST(loan_amnt AS DECIMAL(10,2))) AS DECIMAL(10,2)), 2) AS Average_LoanAmount,
ROUND(CAST(AVG(CAST(funded_amnt AS DECIMAL(10,2))) AS DECIMAL(10,2)), 2) AS Average_FundedAmount, 
CAST(AVG(TRY_CONVERT(DECIMAL(10,2), REPLACE(int_rate, '%', ''))) as decimal(10,2)) AS Avg_int_rate,
ROUND(CAST(AVG(CAST(dti AS DECIMAL(10,2))) AS DECIMAL(10,2)), 2) AS Avg_dti

FROM dbo.loan;

-- BUSINESS QUESTION 4
-- Loan Status Distribution

SELECT
loan_status AS Loan_Status,
COUNT(*) AS Total_Loan,
ROUND(
CAST(
    COUNT(*) * 100.0 /
    NULLIF((SELECT COUNT(*) FROM dbo.loan), 0) AS DECIMAL(18,2))
, 2) AS PercentageOfPortFolio,
SUM(CAST(funded_amnt AS bigint)) AS Total_Funded_amnt

FROM dbo.loan
GROUP BY loan_status
Order by Total_Loan;
