# Quick Category Performance Diagnosis Framework (MoM)

## 1. Tổng quan dự án

**Quick Category Performance Diagnosis Framework** là một hệ thống phân tích MoM giúp chuẩn hóa quy trình review hiệu suất ngành hàng, phân rã động lực tăng trưởng và phát hiện sớm rủi ro cấu trúc.
Framework tập trung vào phân tích tỷ trọng, chất lượng và xu hướng tăng trưởng thay vì chỉ báo cáo % thông thường.

## 2. Business context:
- Dataset mô phỏng dữ liệu từ nền tảng E-commerce đa ngành.
- Đối tượng sử dụng: Category Manager / Business Development Team.
- KPI chính: ADO & AdGMV.

## 3. Problem Statement:

- MoM % không phản ánh bản chất tăng trưởng.
- Khó xác định động lực cụ thể ở cấp LV2 & sản phẩm.
- Không có cơ chế cảnh báo sớm rủi ro cấu trúc.
- Review monthly còn phụ thuộc xử lý thủ công.

## 4. Phương pháp phân tích

### 4.1 Phân tích tăng trưởng theo cấu trúc

Phân tích theo mô hình drill-down:

Ngành hàng Level 1 → Ngành hàng Level 2 → nhóm sản phẩm (đã chuẩn hóa theo keywords)

Tại mỗi cấp độ, tính:

    Diff (Current – Previous)

    MoM %

    Tỷ trọng đóng góp vào tổng tăng trưởng

**Mục tiêu:**

Không chỉ biết ngành tăng/giảm bao nhiêu %, mà biết tăng do đâu và mức độ phụ thuộc cao hay thấp.

Chi tiết: [growth_driver](notebooks/03_growth_driver.ipynb)


### 4.2 Đánh giá chất lượng tăng trưởng

Kết hợp hai yếu tố:

    Diff_ado/ Diff_gmv

    Tỷ trọng ADO/AdGMV

Phân loại LV2:

- Tỷ trọng lớn + tăng trưởng → Trụ cột tăng trưởng

- Tỷ trọng  lớn + suy giảm → Rủi ro cấu trúc

- Tỷ trọng  nhỏ + tăng trưởng → Cơ hội phát triển

Cách tiếp cận này giúp ưu tiên hành động thay vì chỉ nhìn vào tăng trưởng tuyệt đối.

Chi tiết: [quality_growth](notebooks/04_quality_growth.ipynb)

### 4.3 Chuẩn hóa và gom nhóm sản phẩm

Dữ liệu gốc có tình trạng phân mảnh tên sản phẩm.

Giải pháp:

- Chuẩn hóa text

- Loại bỏ từ nhiễu

- Giữ lại 5 từ khóa chính

- Nhóm theo từ khóa sản phẩm 

**Mục tiêu:**

- Giảm nhiễu phân tích

- Tránh đếm lặp sản phẩm cùng bản chất

- Phản ánh đúng hành vi tiêu dùng

Chi tiết: [product_keyword](notebooks/02_product_keyword.ipynb)

### 4.4 Xu hướng, đánh giá rủi ro và tiềm năng: 

Xây dựng theo logic:

- LV2 tăng/giảm liên tiếp ≥ 2 tháng gần nhất

- Sản phẩm tăng/giảm liên tiếp + mức giảm lớn + tỷ trọng ADO/AdGMV cao

Điều này giúp phát hiện sớm các nhóm nguy cơ có ảnh hưởng tới ADO/AdGMV tổng, trước khi biểu hiện rõ ở cấp LV1.

Chi tiết: [trend](notebooks/05_trend.ipynb)

## 5. Dataset & Teck Stack

### 5.1 Dataset
Danh mục ngành hàng đã được chuẩn hoá và tái cấu trúc cho mục đích phân tích, không phản ánh hệ thống phân loại gốc của nền tảng.
Trọng tâm dự án là phương pháp phân tích và tư duy dữ liệu.

Dataset gồm:
- 3 tháng dữ liệu
- 2 LV1 chính
- 20+ LV2
- ~500.000 items record

### 5.2. Tech stack
- SQL (Data cleaning & aggregation)
- Google Colab (Pandas, Numpy, Matplotlib)

## 6. Pipeline xử lý dữ liệu

### **SQL Layer**

- Union dữ liệu nhiều tháng

- Chuẩn hóa datatype

- Tạo trường year_month

- Aggregate theo LV2 và Product

- Tạo cột dữ liệu kì trước bằng window function LAG()

Output: Dataset sạch, có data dữ liệu kỳ trước, phục vụ cho phân tích dữ liệu sau nay.

File: cat_pfm_pipeline.sql

### **Python Layer**

- Xử lý text sản phẩm

- Tính tỷ trọng tăng trưởng và tỷ trọng ADO/AdGMV

- Phân loại chất lượng tăng trưởng

- Xây dựng logic cảnh báo xu hướng

- Trực quan hóa phục vụ storytelling

## 7. Example Insight – September

Tháng 9:

Hai ngành Vehicle Essentials và Home & Technical Supplies tăng trưởng tích cực, cụ thể +6.71% ADO và +14.64% AdGMV MoM

![Ảnh](image/overview_chart.png)

Tuy nhiên, cấu trúc tăng trưởng khác nhau:

- Vehicle Essentials tăng trưởng theo số lượng đơn hàng, phụ thuộc vào top 3 LV2 chính (đóng góp >100% tổng mức tăng trưởng)

→ tăng trưởng tập trung, rủi ro phụ thuộc cao.

![Ảnh](image/vehical_diff.png)

Home & Technical Supplies tăng trưởng theo giá trị đơn hàng, top 3 LV2 đóng góp ~81.9% 

→ cấu trúc lan tỏa và ổn định hơn.

![Ảnh](image/home_diff.png)

Ngoài ra:

- Một số LV2 có tỷ trọng ADO/AdGMV lớn nhưng giảm liên tiếp → cảnh báo rủi ro cấu trúc

- Một số nhóm tăng liên tiếp ≥ 2 tháng → tín hiệu tăng trưởng bền vững

Kết luận:

- Cùng là tăng trưởng, nhưng mức độ ổn định và mức độ phụ thuộc cấu trúc khác nhau → cần chiến lược vận hành khác nhau.

## 8. Impact đạt được

- Giảm thời gian review từ ~40 → 10–15 phút

- Chuẩn hóa logic phân tích → giảm sai sót thủ công

- Hỗ trợ xác định sớm nhóm ngành có rủi ro cấu trúc

- Tạo framework tái sử dụng cho các kỳ tiếp theo

- Nâng cấp báo cáo từ “mô tả số liệu” sang “giải thích bản chất tăng trưởng”

## 9. CẤU TRÚC REPOSITORY
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
## 10.Báo cáo đầu ra 
Đây là phiên bản báo cáo tổng hợp cuối cùng sau quá trình xử lý và phân tích dữ liệu

[BÁO CÁO CHI TIẾT](https://vannguyenhoai43-hash.github.io/ecommerce-category-growth-analysis/report_cat.html)


