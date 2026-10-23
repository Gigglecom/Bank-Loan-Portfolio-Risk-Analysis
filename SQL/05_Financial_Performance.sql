-- BANK LOAN PORTFOLIO & RISK ANALYSIS
-- Q13–Q15: Financial performance
-- SQL Server (T-SQL) | Historical loan issuances: 2007–2011
-- Requires a table named dbo.loan in the active database.
-- Original user SQL reviewed and selectively corrected; execute locally to verify.

-- BUSINESS QUESTION 13A
-- TOTAL FUNDING AND REPAYMENT PERFORMANCE
SELECT
COUNT(*) TotalLoan,
SUM(CAST(funded_amnt AS bigint)) AS Total_funded_Amount,
ROUND(
      SUM(CAST(total_pymnt AS DECIMAL(20,2))), 2
) AS Total_payment_receivced,
ROUND(
    SUM(CAST(total_rec_prncp AS DECIMAL(20,2))), 
2) AS Total_Principle_Recovered,
ROUND(
        SUM(CAST(total_rec_int AS DECIMAL(20,2))), 2
    ) AS Total_Interest_Received,

ROUND(
        SUM(CAST(total_rec_late_fee AS DECIMAL(20,2))), 2
    ) AS Total_Late_Fees_Received,

ROUND(
        SUM(CAST(recoveries AS DECIMAL(20,2))), 2
    ) AS Total_Recoveries

FROM dbo.loan;

-- BUSINESS QUESTION 13B
-- FINANCIAL PERFORMANCE BY LOAN STATUS
SELECT
loan_status AS Loan_Status,
COUNT(*) AS Total_Loans,
SUM(CAST(funded_amnt AS bigint)) AS Total_funded_Amount,
ROUND(
      SUM(CAST(total_pymnt AS DECIMAL(20,2))), 2
) AS Total_payment_receivced,
ROUND(
    SUM(CAST(total_rec_prncp AS DECIMAL(20,2))), 
2) AS Total_Principle_Recovered,
ROUND(
        SUM(CAST(total_rec_int AS DECIMAL(20,2))), 2
    ) AS Interest_Received,
ROUND(
        SUM(CAST(recoveries AS DECIMAL(20,2))), 2
    ) AS Recoveries

FROM dbo.loan
Group By loan_status
ORDER BY Total_Loans DESC;

-- BUSINESS QUESTION 14A
-- REPAYMENT TO FUNDED AMOUNT RATIO
SELECT
loan_status AS Loan_Status,

COUNT(*) AS Total_Loans,

SUM(CAST(funded_amnt AS DECIMAL(20,2)))
        AS Total_Funded_Amount,

ROUND(
        SUM(CAST(total_pymnt AS DECIMAL(20,2))), 2
    ) AS Total_Payments_Received,
ROUND(
      100.0 * SUM(CAST(total_pymnt AS DECIMAL(20,2)))/
      NULLIF(SUM(CAST(funded_amnt AS DECIMAL(20,2))), 0), 2
) AS Repayment_Ratio_percent,
ROUND( 
         SUM(CAST(total_pymnt AS DECIMAL(20,2)))
        -
      SUM(CAST(funded_amnt AS DECIMAL(20,2))) , 2
      
) AS Payment_Funding_Difference

FROM dbo.loan
GROUP BY loan_status
Order By Repayment_Ratio_percent DESC;

-- BUSINESS QUESTION 14B
-- OUTSTANDING PRINCIPAL ANALYSIS
SELECT
loan_status AS Loan_Status,

COUNT(*) AS Total_Loans,
ROUND(SUM(CAST(out_prncp AS DECIMAL(20,2))), 2) AS Outstanding_Principle,
ROUND(SUM(CAST(total_rec_prncp AS DECIMAL(20,2))), 2) AS Principle_Recovered,
SUM(CAST(funded_amnt AS DECIMAL(20,2)))
        AS Funded_Amount


FROM dbo.loan
GROUP BY loan_status
order by Outstanding_Principle DESC;

-- BUSINESS QUESTION 15A
-- CHARGED-OFF PRINCIPAL EXPOSURE
SELECT
COUNT(*) AS Total_Charged_Off_Loans,

SUM(CAST(funded_amnt AS DECIMAL(20,2)))
        AS Original_Funded_Amount,

ROUND(
        SUM(CAST(total_rec_prncp AS DECIMAL(20,2))),
        2
    ) AS Principal_Recovered,
ROUND(
    SUM(CAST(funded_amnt AS DECIMAL(20,2))) -
    SUM(CAST(total_rec_prncp AS DECIMAL(20,2)))
, 2) AS Unrecovered_Principle,
ROUND(
    100.0 * SUM(CAST(total_rec_prncp AS DECIMAL(20,2))) /
    NULLIF(SUM(CAST(funded_amnt AS DECIMAL(20,2))),0)
,2) AS Principle_recovery_Rate

FROM dbo.loan
WHERE loan_status= 'Charged Off';

-- BUSINESS QUESTION 15B
-- PRINCIPAL RECONCILIATION VALIDATION
SELECT 
COUNT(*) AS Total_Loans,
SUM(CASE WHEN total_rec_prncp > funded_amnt THEN 1 ELsE 0 END) AS Principle_exceeding_Funded,
SUM(CASE WHEN total_rec_prncp IS NULL OR out_prncp IS NULL THEN 1 ELSE 0 END) AS Missing_Priciples,
ROUND(
SUM(CAST(total_rec_prncp AS DECIMAL(20,2)) + CAST(out_prncp AS DECIMAL(20,2)) 
- CAST(funded_amnt AS DECIMAL(20,2))) ,2) AS Principle_reconciliation_diff
FROM dbo.loan
GROUP BY loan_status
ORDER BY loan_status
