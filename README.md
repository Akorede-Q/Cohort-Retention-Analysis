# Customer Cohort Retention Analysis

## Overview
This project analyzes customer retention behavior using the UCI Online Retail dataset — a transactional dataset containing over 500,000 records from a UK-based e-commerce business between 2010 and 2011.

The objective is to understand how customers behave after their first purchase and identify key opportunities to improve retention and long-term customer value.

---

## Business Questions Answered
- What percentage of customers return after their first purchase?
- At what point do most customers drop off?
- Are newer cohorts retaining better or worse than older ones?
- Which acquisition period produced the most loyal customers?
- Does the business have a retention or acquisition problem?
- Is there a natural point where customers become loyal?

---

## Tools Used
- SQL (SQL Server) — data cleaning, cohort modeling, retention calculations  
- Power BI — cohort heatmaps, retention trends, dashboard visualization  
- GitHub — version control and documentation  

---

## Dataset
- Source: UCI Online Retail Dataset (Kaggle)
- Records: 541,909 transactions  
- Period: December 2010 – December 2011  
- Key Fields: CustomerID, InvoiceDate, InvoiceNo, Quantity, UnitPrice, Country  

---

## Data Cleaning Process

The dataset required extensive preprocessing to ensure accurate cohort analysis.

### 1. Customer Identification
- Removed records with NULL CustomerID values  
- These records cannot be used for retention tracking  

---

### 2. Transaction Validity
- Removed transactions with negative quantities (returns/cancellations)  
- Ensured only valid purchase behavior was analyzed  

---

### 3. Pricing Cleaning
- Removed UnitPrice = 0 (invalid or missing pricing data)  
- Removed UnitPrice = 0.001 (bank charges and system adjustments)  
- Retained low-value transactions (0.04–0.09) after validation as legitimate sales  

---

### 4. Non-Product Transactions Removed
Excluded non-purchase activities such as:
- Postage  
- Carriage  
- Manual adjustments  
- Dotcom postage  
- Bank charges  

---

### 5. Data Standardization
- Converted StockCode to text to handle mixed alphanumeric values  
- Standardized DateTime format using Power Query (resolved mixed formats and invalid date strings)  

---

## Cohort Methodology

### Step 1 — First Purchase Assignment
Each customer was assigned a cohort based on their first purchase month.

### Step 2 — Cohort Index Calculation
Calculated the number of months between first purchase and all subsequent transactions.

### Step 3 — Retention Matrix
Aggregated distinct customers per cohort per month and calculated retention behavior over time.

---

## Power BI Dashboard

### Page 1 — Executive Summary
- KPI Cards (Total Customers, Returning Customers, Retention Rate)
- Cohort Retention Heatmap

### Page 2 — Retention Behavior
- Drop-off Trend Line Chart (Month 0 → Month 23)

### Page 3 — Cohort Comparison
- Retention comparison across different acquisition periods

---

## Key Insights

1. **Overall retention rate of 65.23% is misleading in isolation**  
   The metric is inflated by a small group of highly loyal customers and does not reflect the true distribution of customer behavior.

2. **Over 85% of customers drop off after Month 0**  
   The biggest churn occurs immediately after the first purchase, highlighting a critical early retention gap.

3. **Retention is driven by a small loyal segment**  
   A minority of customers return repeatedly over time, creating a long-tail effect in retention.

4. **Loyalty threshold occurs after first repeat purchase**  
   Customers who return after Month 1 show significantly higher long-term engagement.

5. **Cohort performance varies across acquisition periods**  
   Earlier cohorts (2010) outperform later cohorts (2011), suggesting changes in customer quality or acquisition channels.

6. **Retention problem, not acquisition problem**  
   The business successfully acquires customers but fails to retain them, indicating a “leaky bucket” scenario.

---

## Conclusion

This analysis reveals that the primary challenge for the business is not customer acquisition but early-stage retention. The majority of customers churn after their first purchase, while a small loyal segment drives long-term value. Improving early customer experience and encouraging second purchases presents the highest opportunity for increasing customer lifetime value.

---

## How to Run

1. Import dataset into SQL Server as `online_retail`
2. Run SQL scripts in order:
   - 01_data_cleaning.sql
   - 02_cohort_assignment.sql
   - 03_retention_matrix.sql
3. Load results into Power BI
4. Open dashboard file (`cohort_retention.pbix`)
