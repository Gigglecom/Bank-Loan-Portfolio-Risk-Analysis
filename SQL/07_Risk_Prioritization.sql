-- BANK LOAN PORTFOLIO & RISK ANALYSIS
-- Q19–Q20: Risk prioritization
-- SQL Server (T-SQL) | Historical loan issuances: 2007–2011
-- Requires a table named dbo.loan in the active database.
-- Original user SQL reviewed and selectively corrected; execute locally to verify.

-- BUSINESS QUESTION 19A
-- MULTI-DIMENSIONAL CREDIT RISK SEGMENTATION

WITH Risk_Segment AS (
    SELECT
    grade,
    purpose,
    COUNT(*) AS Total_Resolved_Loan,
    
    SUM(CASE
            WHEN loan_status = 'Charged Off'
            THEN 1 ELSE 0
     END) AS Charged_Off_Loans,

    SUM(CAST(funded_amnt AS DECIMAL(20,2)))
        AS Total_Funded_Amount,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN CAST(funded_amnt AS DECIMAL(18,2) ) ELSE 0 END) AS Charged_Off_Original_Funding

    FROM dbo.loan
    WHERE loan_status IN ('Charged Off', 'Fully Paid')
    GROUP BY grade, purpose
),
Risk_Rate AS(
SELECT 
*,
ROUND(
      100.0 * Charged_Off_Loans/
      NULLIF(  Total_Resolved_Loan,0) , 2
) AS Charged__OffRate

FROM Risk_Segment
WHERE Total_Resolved_Loan >= 100
)

SELECT
    grade AS Credit_Grade,
    purpose AS Loan_Purpose,
    Total_Resolved_Loan,
    Charged_Off_Loans,
    Charged__OffRate,
    Total_Funded_Amount,
    Charged_Off_Original_Funding,
    DENSE_RANK() OVER(ORDER BY  Charged__OffRate DESC) AS Risk_Rank
    FROM Risk_Rate
    Order by Risk_Rank;

-- BUSINESS QUESTION 20
-- CREDIT RISK PRIORITIZATION
WITH Segment_Performance AS (
    SELECT
    grade,
    purpose,
    COUNT(*) AS Total_Resolved_Loans,
    SUM(CASE WHEN loan_status ='Charged Off' THEN 1 ELSE 0 END) AS Total_Charged_Off,
    SUM(CASE WHEN loan_status ='Charged Off' THEN CAST(funded_amnt AS DECIMAL(18,2)) ELSE 0 END) AS Total_Original_ChargedOff_funding
    FROM dbo.loan
    WHERE loan_status IN ('Charged Off', 'Fully Paid')
    GROUP BY grade, purpose
),
Risk_Matrix AS (
SELECT 
*,
ROUND(
100.0 * Total_Charged_Off/
NULLIF(Total_Resolved_Loans,0), 2
) AS ChargedOff_rate_percent
FROM Segment_performance
)
SELECT
    grade AS Credit_Grade,
    purpose AS Loan_Purpose,
    Total_Resolved_Loans,
    Total_Charged_Off,
   ChargedOff_rate_percent,
    Total_Original_ChargedOff_funding,
CASE
  WHEN ChargedOff_rate_percent >= 25
     THEN 'High Risk Review'
  WHEN ChargedOff_rate_percent >= 15
     THEN 'Moderate Risk Review'
      ELSE 'Routine Monitoring'
  END AS Risk_Priority

FROM Risk_Matrix
WHERE Total_Resolved_Loans >= 100

ORDER BY
    Total_Original_ChargedOff_funding DESC,
    ChargedOff_rate_percent DESC;
