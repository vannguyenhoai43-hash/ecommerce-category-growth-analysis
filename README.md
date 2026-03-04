# Quick Category Performance Diagnosis Framework (MoM)

🌐 Read this in: **English** | [Tiếng Việt](README_VI.md)

## 1. Project Overview

**Quick Category Performance Diagnosis Framework** is a Month-over-Month (MoM) analytical system designed to standardize the category performance review process, decompose growth drivers, and detect structural risks early.

Instead of only reporting growth percentages, the framework focuses on analyzing **contribution weight, growth quality, and structural trends** to better understand the nature of performance changes.

---

## 2. Business Context

- Dataset simulates multi-industry data from an E-commerce platform.  
- Target users: Category Managers / Business Development Team.  
- Core KPIs: **ADO & AdGMV**.

---

## 3. Problem Statement

- MoM % alone does not reflect the true nature of growth.  
- Difficult to identify specific drivers at LV2 and product levels.  
- No early-warning mechanism for structural risk.  
- Monthly reviews still rely heavily on manual processing.

---

## 4. Analytical Methodology

### 4.1 Structural Growth Analysis

The framework applies a drill-down model:

**Level 1 Category → Level 2 Category → Product Group (standardized by keywords)**

At each level, the following metrics are calculated:
- Diff (Current – Previous)
- MoM %
- Contribution Weight to Total Growth

**Objective:**

Go beyond knowing how much a category grew or declined, and understand  
**where the growth comes from and how concentrated or diversified it is.**

Details: [growth_driver](notebooks/03_growth_driver.ipynb)

---

### 4.2 Growth Quality Assessment

Growth quality is evaluated by combining: 

- Diff_ADO / Diff_GMV
- ADO / AdGMV Weight
LV2 categories are classified into:

- Large weight + Growth → Growth Pillar  
- Large weight + Decline → Structural Risk  
- Small weight + Growth → Growth Opportunity  

This approach enables action prioritization instead of relying solely on absolute growth.

Details: [quality_growth](notebooks/04_quality_growth.ipynb)

---

### 4.3 Product Standardization & Keyword Grouping

Raw product names are often fragmented and inconsistent.

**Solution:**

- Standardize text  
- Remove noise words  
- Extract top 5 core keywords  
- Group products based on dominant keywords  

**Objective:**

- Reduce analytical noise  
- Avoid double-counting similar products  
- Reflect real consumer behavior more accurately  

Details: [product_keyword](notebooks/02_product_keyword.ipynb)

---

### 4.4 Trend, Risk & Potential Detection

Trend logic is built based on:

- LV2 categories increasing/decreasing for ≥ 2 consecutive months  
- Products with consecutive decline + significant drop + high ADO/AdGMV weight  

This helps detect early-risk clusters that may significantly impact total ADO/AdGMV  
before they become visible at the LV1 level.

Details: [trend](notebooks/05_trend.ipynb)

---

## 5. Dataset & Tech Stack

### 5.1 Dataset

The category hierarchy has been standardized and restructured for analytical purposes.  
It does not reflect the platform’s original classification system.

The focus of the project is on analytical methodology and data-thinking.

Dataset characteristics:

- 3 months of data  
- 2 main LV1 categories  
- 20+ LV2 categories  
- ~500,000 item-level records  

---

### 5.2 Tech Stack

- **SQL** (Data cleaning & aggregation)  
- **Google Colab** (Pandas, NumPy, Matplotlib)

---

## 6. Data Processing Pipeline

### SQL Layer

- Union multi-month datasets  
- Standardize data types  
- Create `year_month` field  
- Aggregate by LV2 and Product  
- Generate previous-period columns using `LAG()` window function  

**Output:** Clean dataset with previous-period data ready for downstream analysis.

File: `cat_pfm_pipeline.sql`

---

### Python Layer

- Product text processing  
- Growth contribution & weight calculation  
- Growth quality classification  
- Trend-based risk detection logic  
- Visualization for storytelling  

---

## 7. Example Insight – September

In September:

Two categories — **Vehicle Essentials** and **Home & Technical Supplies** — showed positive growth:  
+6.71% ADO and +14.64% AdGMV MoM.

![Overview](image/overview_chart.png)

However, the growth structures differ:

- **Vehicle Essentials** grew mainly by order volume, heavily dependent on the top 3 LV2 categories  
  (contributing >100% of total growth).

→ Highly concentrated growth, high dependency risk.

![Vehicle](image/vehical_diff.png)

- **Home & Technical Supplies** grew by order value, with top 3 LV2 contributing ~81.9%.

→ More diversified and structurally stable growth.

![Home](image/home_diff.png)

Additionally:

- Some LV2 categories with high ADO/AdGMV weight are declining consecutively  
  → structural risk warning.  

- Some groups growing ≥ 2 consecutive months  
  → signal of sustainable growth momentum.  

**Conclusion:**

Growth alone is not enough.  
Structural concentration and dependency levels determine sustainability and require different operational strategies.

---

## 8. Impact Achieved

- Reduced review time from ~40 minutes to 10–15 minutes  
- Standardized analytical logic → minimized manual errors  
- Enabled early detection of structural-risk categories  
- Built a reusable framework for future reporting cycles  
- Upgraded reporting from “descriptive numbers” to “growth explanation”

---

## 9. Repository Structure
```text
quick-category-performance-report/
│
├── README.md
├── sql/
│   └── cat_pfm_pipeline.sql
│
├── notebooks/
│   ├── 01_overview.ipynb
│   ├── 02_product_keyword.ipynb
│   ├── 03_growth_driver.ipynb
│   ├── 04_quality_growth.ipynb
│   ├── 05_trend.ipynb
│   └── cat_quick_report.ipynb
│
└── src/
    ├── load_data.py
    ├── metrics.py
    └── charts.py

```
## 10. Final Output ReportBáo cáo đầu ra 
This is the final consolidated report generated after the full data processing and analytical workflow:

[DETAIL_REPORT](https://vannguyenhoai43-hash.github.io/ecommerce-category-growth-analysis/report_cat.html)


