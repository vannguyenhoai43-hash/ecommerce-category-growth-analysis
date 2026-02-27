-- ==========================================
Category-Growth-analysis
Author: Van
Description:
- Union monthly raw tables
- Clean & standardize numeric fields
- Calculate monthly delta using LAG
-- ==========================================

	
----------------------------------------
-- B1: Union các tháng trong dữ liệu
----------------------------------------
CREATE VIEW sales_raw AS
SELECT * FROM Cat_Report.dbo.Jul
UNION ALL
SELECT * FROM Cat_Report.dbo.Aug
UNION ALL
SELECT * FROM Cat_Report.dbo.Sep;

-- Union thêm tháng khi có dữ liệu mới

-----------------------------------------------
-- B2: Làm sạch và chuyển đổi dữ liệu tính toán
-----------------------------------------------

CREATE VIEW sale_base AS
SELECT
	CONVERT(CHAR(7), start_date, 120) AS year_month,
    level1_kpi_category,
    level2_kpi_category,
    item_name,
    TRY_CAST(ADO AS DECIMAL(18,6)) AS ADO,
    TRY_CAST(
        CASE
            WHEN AdGMV LIKE '%E%'
                THEN CAST(CAST(AdGMV AS FLOAT) AS DECIMAL(18,6))
            ELSE AdGMV
        END AS DECIMAL(18,6)
    ) AS AdGMV
FROM sales_raw;

SELECT * FROM sale_base;

---------------------------------------
--B3: Tạo bảng delta theo tháng
---------------------------------------

-- Group theo level 2

WITH base_total_lv2 AS (
SELECT  year_month,
		level1_kpi_category,
		level2_kpi_category,
		SUM([ADO]) AS ADO_M,
		SUM([AdGMV]) AS AdGMV_M
FROM sale_base
GROUP BY year_month,
		level1_kpi_category,
		level2_kpi_category
)
---tạo bảng M_1
,total_lv2 AS(
SELECT	year_month,
		level1_kpi_category,
		level2_kpi_category,
		ADO_M, AdGMV_M,
		LAG(ADO_M) OVER( PARTITION BY level2_kpi_category ORDER BY CAST(year_month + '-01' AS DATE)) AS ADO_M_1,
		LAG(AdGMV_M) OVER( PARTITION BY level2_kpi_category ORDER BY CAST(year_month + '-01' AS DATE)) AS AdGMV_M_1
FROM base_total_lv2
)
SELECT * FROM total_lv2;

-- Group theo item

WITH base_total_items AS (
SELECT  year_month,
		level1_kpi_category,
		level2_kpi_category,
		item_name,
		SUM([ADO]) AS ADO_M,
		SUM([AdGMV]) AS AdGMV_M
FROM sale_base
GROUP BY year_month,
		level1_kpi_category,
		level2_kpi_category,
		item_name
)
---tạo bảng M_1
,total_items AS(
SELECT	year_month,
		level1_kpi_category,
		level2_kpi_category,
		item_name,
		ADO_M, AdGMV_M,
		LAG(ADO_M) OVER( PARTITION BY level2_kpi_category, item_name ORDER BY CAST(year_month + '-01' AS DATE)) AS ADO_M_1,
		LAG(AdGMV_M) OVER( PARTITION BY level2_kpi_category, item_name ORDER BY CAST(year_month + '-01' AS DATE)) AS AdGMV_M_1
FROM base_total_items
)
SELECT  *
FROM total_items;

