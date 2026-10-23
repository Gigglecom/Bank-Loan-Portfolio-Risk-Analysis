-- BANK LOAN PORTFOLIO & RISK ANALYSIS
-- Q16–Q18: Geographic and trend analysis
-- SQL Server (T-SQL) | Historical loan issuances: 2007–2011
-- Requires a table named dbo.loan in the active database.
-- Original user SQL reviewed and selectively corrected; execute locally to verify.

-- BUSINESS QUESTION 16A
-- LOAN ISSUE DATE VALIDATION
WITH LoanDate AS (
    SELECT 
    issue_d,
    TRY_CONVERT(DATE,'01-' + LTRIM(RTRIM(issue_d)), 6
    
    ) AS Issue_Date

    FROM dbo.loan
)

SELECT 
COUNT(*) AS TotalLoans,
COUNT(Issue_Date) AS Total_Date,
SUM(CASE WHEN Issue_Date IS NULL THEN 1 ELSE 0 END) AS Invalid_dates,
MIN(Issue_Date) AS Earliest_Dates,
MAX(Issue_Date) AS Latest_Dates

FROM LoanDate;

-- BUSINESS QUESTION 16B
-- MONTHLY LOAN ISSUANCE TREND
WITH Monthly_Loans AS (
SELECT 
    TRY_CONVERT(DATE,'01-' + LTRIM(RTRIM(issue_d)), 6
    
    ) AS Issue_Date,
    funded_amnt,
    loan_amnt

FROM dbo.loan
)

SELECT 
YEAR(Issue_Date) AS Loan_Year,
MONTH(Issue_Date) AS Loan_Month,
COUNT(*) AS Total_Loans,
SUM(CAST(funded_amnt AS bigint)) AS Total_funuded_Amount,
ROUND(
AVG(CAST(loan_amnt AS DECIMAL(18,2))), 
2) AS Average_Loan_amount

FROM Monthly_Loans

WHERE Issue_Date IS NOT NULL
GROUP BY YEAR(Issue_Date), MONTH(Issue_Date)
ORDER BY Loan_Year, Loan_Month;

-- BUSINESS QUESTION 16C: ANNUAL LOAN ISSUANCE AND FUNDING TRENDS
-- ANNUAL LOAN ISSUANCE AND FUNDING TRENDS

WITH Annual_Loans AS (
    SELECT
        YEAR(
            TRY_CONVERT(
                DATE,
                '01-' + LTRIM(RTRIM(issue_d)),
                6
            )
        ) AS Loan_Year,
        loan_amnt,
        funded_amnt
    FROM dbo.loan
)
SELECT
    Loan_Year,
    COUNT(*) AS Total_Loans,
    SUM(CAST(loan_amnt AS BIGINT))
        AS Total_Requested_Amount,
    SUM(CAST(funded_amnt AS BIGINT))
        AS Total_Funded_Amount,
    ROUND(
        AVG(CAST(funded_amnt AS DECIMAL(18,2))),
        2
    ) AS Average_Funded_Amount
FROM Annual_Loans
WHERE Loan_Year IS NOT NULL
GROUP BY Loan_Year
ORDER BY Loan_Year;

-- BUSINESS QUESTION 17A
-- STATE-LEVEL LOAN PERFORMANCE AND CREDIT RISK
SELECT
addr_state AS STATE,
COUNT(*) AS Totals_loans,
SUM(CAST(loan_amnt as bigint)) AS Total_loan,
SUM(CAST(funded_amnt AS bigint)) AS Total_funded,
SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS Total_ChargedOff,
SUM(CASE WHEN loan_status IN ('Charged Off', 'Fully Paid') THEN 1 ELSE 0 END) AS Total_Resolved_Loan,
ROUND(
      CAST (100.0 * SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) / 
      NULLIF(SUM(CASE WHEN loan_status IN ('Charged Off', 'Fully Paid') THEN 1 ELSE 0 END) ,0) AS DECIMAL(18,2)), 2
) AS ChargedOFf_Rate

FROM dbo.loan
GROUP BY addr_state
ORDER BY ChargedOFf_Rate DESC;

-- BUSINESS QUESTION 17B
-- STATE CREDIT RISK WITH SAMPLE-SIZE FILTER
SELECT
    addr_state AS State,

    COUNT(*) AS Resolved_Loans,

    SUM(CASE
        WHEN loan_status = 'Charged Off'
        THEN 1 ELSE 0
    END) AS Charged_Off_Loans,

    ROUND(
       CAST( 100.0 * SUM(CASE
            WHEN loan_status = 'Charged Off'
            THEN 1 ELSE 0
        END)
        / NULLIF(COUNT(*), 0) AS DECIMAL(18,2)),
        2
    ) AS Charge_Off_Rate_Pct

FROM dbo.loan
WHERE loan_status IN ('Charged Off', 'Fully Paid')

GROUP BY addr_state
HAVING COUNT(*) >= 100
ORDER BY Charge_Off_Rate_Pct DESC;

-- BUSINESS QUESTION 18
-- GEOGRAPHIC FUNDING CONCENTRATION

WITH State_Funding AS (
    SELECT
        addr_state AS State,
        COUNT(*) AS Total_Loans,

        SUM(CAST(funded_amnt AS DECIMAL(20,2)))
            AS Total_Funded_Amount

    FROM dbo.loan
    GROUP BY addr_state
)

SELECT
    State,
    Total_Loans,
    Total_Funded_Amount,
ROUND(
      100.0 * Total_Funded_Amount /
      NULLIF(SUM(Total_funded_Amount) OVER(),0), 2
) AS Portfolio_Funding_Share_Pct,

RANK() OVER(ORDER BY Total_Funded_Amount DESC) AS Funding_Rank

FROM State_Funding
ORDER BY Funding_Rank;
