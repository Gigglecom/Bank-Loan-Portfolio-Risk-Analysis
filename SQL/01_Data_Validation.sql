-- BANK LOAN PORTFOLIO & RISK ANALYSIS
-- Data structure and quality
-- SQL Server (T-SQL) | Historical loan issuances: 2007–2011
-- Requires a table named dbo.loan in the active database.
-- Original user SQL reviewed and selectively corrected; execute locally to verify.

--Dataset Structure Validation

SELECT 

COLUMN_NAME AS ColumnName,
DATA_TYPE AS Datatype,
CHARACTER_MAXIMUM_LENGTH AS MaxLengthh,
IS_NULLABLE AS AllowsNull

FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
AND TABLE_NAME = 'Loan'
Order By ORDINAL_POSITION

-- Data Quality Assesment
SELECT
COUNT(*) AS TotalApplication,
COUNT(DISTINCT id) AS TotalIdCount,
Count(*) - Count(Distinct id) AS DublicateID,
SUM(CASE WHEN funded_amnt IS NULL THEN 1 ELSE 0 END) AS Missing_funded_amnt,
SUM(CASE WHEN int_rate IS NULL OR LTRIM(RTRIM(int_rate)) = '' THEN 1 ELSE 0 END) AS Missing_int_rate,
SUM(CASE WHEN issue_d IS NULL OR LTRIM(RTRIM(issue_d))= '' THEN 1 ELSE 0 END) AS MissingIssue_d,
SUM(CASE WHEN grade IS NULL OR LTRIM(RTRIM(grade))='' THEN 1 ELSE 0 END) AS Missing_grade,
SUM(CASE WHEN funded_amnt < 0 THEN 1 ELSE 0 END) AS Negative_funded_amnt
FROM dbo.loan;


SELECT TOP 10
    id,
    loan_amnt,
    funded_amnt,
    int_rate,
    term,
    issue_d,
    grade,
    loan_status
FROM dbo.loan
ORDER BY id;
