# Bank Loan Portfolio & Risk Analysis

### End-to-End Data Analytics Portfolio Project | SQL Server & Power BI

## Project Overview

This project analyzes a historical bank loan portfolio comprising **39,717 loan records issued between June 2007 and December 2011**. Using Microsoft SQL Server and Power BI, the analysis evaluates lending performance, borrower characteristics, repayment outcomes, credit risk exposure, and geographic lending patterns.

The project demonstrates how data analytics can help financial institutions identify higher-risk loan segments, monitor lending performance, and support evidence-based credit risk management decisions.

## Business Problem

Financial institutions must balance lending growth with effective credit risk management. Inadequate understanding of borrower characteristics, historical charge-off patterns, and financial exposure can lead to poor lending decisions and substantial losses.

This project addresses the central business question:

**How can a lending institution evaluate its loan portfolio, identify characteristics associated with loan charge-offs, and make data-driven decisions to improve lending performance and credit risk management?**

## Tools and Technologies

| Tool | Application |
|---|---|
| Microsoft SQL Server | Data storage, querying, and analysis |
| SQL Server Management Studio (SSMS) | Query development and execution |
| Power BI Desktop | Interactive dashboards and visualizations |
| Power Query | Data transformation and preparation |
| DAX | KPI calculations and analytical measures |
| GitHub | Project documentation and version control |

## Project Objectives

1. Evaluate overall loan portfolio size and funding performance.
2. Analyze historical loan charge-off rates and repayment outcomes.
3. Identify borrower characteristics associated with elevated credit risk.
4. Assess principal recovery, cumulative payments, and financial exposure.
5. Examine geographic lending concentration and historical lending trends.
6. Develop analytical risk-prioritization recommendations.

## Dataset Description

The dataset contains 39,717 historical loan records with information covering:

- Loan amounts, funding, terms, and interest rates.
- Credit grades and repayment status.
- Borrower income, employment length, and homeownership.
- Debt-to-income ratios and loan purposes.
- Principal repayments, interest received, and recoveries.
- Loan issue dates and US state identifiers.

**Historical coverage:** June 2007 – December 2011.

**Loan outcomes:** Fully Paid, Charged Off, and Current.

The dataset is used for historical portfolio analysis rather than real-time credit risk prediction.

## Data Preparation and Validation

SQL Server was used to inspect the dataset structure, evaluate duplicate loan IDs, identify missing values, and verify important financial fields.

Power Query was used to create analytical fields, including:

- Numeric interest rates.
- Converted loan issuance dates.
- Loan year and month.
- Numeric loan terms.
- Interest rate, DTI, and annual income categories.

The analysis identified 39,717 unique loan IDs and no missing values in selected critical fields, including loan amount, loan status, and annual income.

Additional financial reconciliation checks were conducted to identify inconsistencies and document limitations.

## Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Loan Records | 39,717 |
| Total Requested Amount | 445.60M |
| Total Funded Amount | 434.81M |
| Total Payments Received | 482.70M |
| Average Interest Rate | 12.02% |
| Fully Paid Loans | 32,950 |
| Charged-Off Loans | 5,627 |
| Current Loans | 1,140 |
| Overall Charge-Off Rate | 14.17% |
| Resolved-Loan Charge-Off Rate | 14.59% |
| Estimated Unrecovered Principal on Charged-Off Loans | 43.81M |

*Financial amounts are expressed in the dataset's monetary units. Estimated unrecovered principal is not equivalent to an audited net loss.*

## SQL Business Analysis

The project answers **20 business questions across six analytical areas**.

| Analysis area | Questions | Focus |
|---|---|---|
| Loan Portfolio Overview | Q1–Q4 | Loan volume, funding, averages, loan status |
| Credit Risk Analysis | Q5–Q8 | Charge-offs, credit grades, interest rates, DTI |
| Borrower Segmentation | Q9–Q12 | Income, employment, homeownership, loan purpose |
| Financial Performance | Q13–Q15 | Repayments, principal recovery, financial exposure |
| Geographic & Trend Analysis | Q16–Q18 | Lending trends, state-level risk, funding concentration |
| Risk Prioritization | Q19–Q20 | Combined risk segments and recommendations |

### SQL Skills Demonstrated

- Aggregate functions: `SUM()`, `COUNT()`, `AVG()`, `MIN()`, and `MAX()`.
- Conditional aggregation with `CASE WHEN`.
- Common Table Expressions (CTEs).
- Window functions, including `RANK()` and `DENSE_RANK()`.
- Data conversion using `CAST()` and `TRY_CONVERT()`.
- Date transformations and time-based aggregation.
- Grouping, sorting, filtering, and risk segmentation.
- Defensive calculations using `NULLIF()` and `ROUND()`.

## Power BI Dashboard

The project includes five interactive dashboard pages.

### 1. Executive Overview

Displays portfolio-level KPIs, loan status distribution, annual lending volume, annual funding trends, and interactive filters.

### 2. Credit Risk Analysis

Examines charge-off rates across credit grades, interest rate categories, debt-to-income bands, and loan purposes.

### 3. Borrower Segmentation

Evaluates borrower income, employment length, homeownership, and loan purpose distributions.

### 4. Financial Performance

Compares original funding with cumulative payments, principal recovery, estimated unrecovered principal, and outstanding balances.

### 5. Geographic & Lending Trends

Analyzes state-level lending concentration, historical geographic charge-off rates, and annual funding growth.

## Key Business Findings

### 1. Credit Grade and Charge-Off Risk

The observed charge-off rate increased from **5.99% for Grade A loans to 33.78% for Grade G loans**.

This demonstrates a strong historical association between credit grades and loan repayment outcomes.

### 2. Interest Rate and Credit Risk

Loans carrying interest rates below 10% recorded a 6.62% charge-off rate, compared with **38.44% for loans with interest rates of at least 20%**.

This relationship may reflect existing risk-based pricing rather than a causal effect of interest rates.

### 3. Annual Income and Loan Repayment

Borrowers earning below 30K annually recorded an 18.70% charge-off rate, compared with 10.77% among borrowers earning 100K or more.

This suggests that annual income is useful for credit risk segmentation when considered alongside other borrower characteristics.

### 4. Small-Business Loan Risk

Small-business loans recorded the highest charge-off rate by loan purpose at **27.08%**.

Debt-consolidation loans contributed the largest number of charged-off loans, with 2,767.

### 5. Financial Exposure

Charged-off loans represented approximately **66.14M in original funding**, with 22.32M in recorded principal repayments.

The resulting estimated unrecovered principal was **43.81M**, subject to recovery and accounting limitations.

### 6. Geographic Lending Concentration

California represented 18.02% of original funded value, followed by New York, Texas, Florida, and New Jersey.

Together, these five states accounted for approximately **46.62%** of portfolio funding.

### 7. Historical Lending Growth

Annual loan issuance increased substantially during the study period, reaching **21,656 loans in 2011**.

Original funding in 2011 totaled approximately 256.24M, representing 119.7% growth compared with 2010.

## Business Recommendations

Based on the observed findings, the following actions are recommended for further evaluation:

1. Strengthen credit risk reviews for higher-risk loan grades and borrower segments.
2. Monitor debt-consolidation lending because of its substantial financial exposure.
3. Incorporate borrower income, DTI, interest rate, and loan characteristics into multidimensional risk assessments.
4. Investigate missing borrower employment information and improve data validation processes.
5. Monitor geographic concentration and compare state-level performance using appropriate sample sizes.
6. Evaluate principal recovery performance and reconcile inconsistent financial records.

## Analytical Limitations

This project uses historical observational data. Therefore, associations between borrower characteristics and charge-offs should not be interpreted as causal relationships.

Current loans are excluded when calculating charge-off rates among resolved loans because their final repayment outcomes are unknown.

The estimated unrecovered principal does not represent an audited accounting loss, and cumulative payments should not be interpreted directly as profit.

The dataset covers 2007–2011 and does not represent current lending performance.

## Repository Structure

```text
Bank-Loan-Portfolio-Risk-Analysis/
│
├── SQL/
│   ├── 01_Data_Validation.sql
│   ├── 02_Portfolio_Overview.sql
│   ├── 03_Credit_Risk_Analysis.sql
│   ├── 04_Borrower_Segmentation.sql
│   ├── 05_Financial_Performance.sql
│   ├── 06_Geographic_Trend_Analysis.sql
│   └── 07_Risk_Prioritization.sql
│
├── PowerBI/
│   └── Bank_Loan_Portfolio_Risk_Analysis.pbix
│
├── Screenshots/
│   ├── Executive_Overview.png
│   ├── Credit_Risk_Analysis.png
│   ├── Borrower_Segmentation.png
│   ├── Financial_Performance.png
│   └── Geographic_Trends.png
│
├── Data_Dictionary.md
└── README.md
```

## How to Explore the Project

1. Review the SQL scripts to understand the data validation and business-question analysis.
2. Open the `.pbix` file in Power BI Desktop, if included.
3. Explore the dashboard screenshots for an overview of the analytical results.
4. Examine the key findings and business recommendations presented in this README.

The Power BI file may require access to the original SQL Server data source or updated connection settings to refresh successfully.

## Conclusion

This project demonstrates an end-to-end data analytics workflow, from SQL-based data validation and exploratory analysis to Power BI visualization and business recommendations.

The findings show how loan performance can be assessed through borrower segmentation, historical charge-off rates, repayment behavior, geographic exposure, and risk prioritization.

The project highlights practical skills in **SQL Server, DAX, Power Query, Power BI, financial analysis, credit risk assessment, and data storytelling**.
