# Quick Category Performance Diagnosis Framework (MoM)

## 1. Tổng quan dự án

Dự án xây dựng một framework phân tích hiệu quả ngành hàng theo Month-over-Month (MoM) nhằm hỗ trợ team:

- Hiểu bản chất tăng trưởng (volume hay value-driven)

- Xác định chính xác động lực tăng/giảm

- Phát hiện sớm rủi ro cấu trúc

- Chuẩn hóa quy trình review hiệu suất hàng tháng

Thay vì chỉ báo cáo % tăng trưởng, framework tập trung vào phân tích tăng trưởng và đánh giá chất lượng tăng trưởng, giúp việc ra quyết định dựa trên cấu trúc dữ liệu thay vì cảm tính.

Framework được thiết kế để tái sử dụng:

Khi có dữ liệu tháng mới, chỉ cần cập nhật input, toàn bộ pipeline và logic phân tích vẫn giữ nguyên.

## 2. Dataset 

Danh mục ngành hàng đã được chuẩn hoá và tái cấu trúc cho mục đích phân tích, không phản ánh hệ thống phân loại gốc của nền tảng.
Trọng tâm dự án là phương pháp phân tích và tư duy dữ liệu.

Dataset gồm:
- 3 tháng dữ liệu
- 2 LV1 chính
- 20+ LV2
- ~300.000 product record


## 3. Tech stack
- SQL (Data cleaning & aggregation)
- Google Colab (Pandas, Numpy, Matplotlib)

## 4. Bài toán kinh doanh

Khi kết thúc tháng, các câu hỏi thực tế từ business bao gồm:

1. Hiệu suất Level 1 thay đổi thế nào theo tháng?

2. LV2 và sản phẩm tương ứng nào đang thúc đẩy hoặc kìm hãm tăng trưởng?

3. Tăng trưởng hiện tại có bền vững không?

4. LV2 nào có xu hướng tăng/giảm liên tục trong 3 tháng?

5. Sản phẩm nào cần ưu tiên theo dõi?

Framework được xây dựng để trả lời các câu hỏi trên theo cấu trúc rõ ràng:

Tổng quan → Động lực → Chất lượng → Xu hướng 

## 5. Chỉ số

### 5.1 Cấp độ phân tích:

- LV1: Ngành hàng cấp 1 

- LV2: Ngành hàng cấp 2 

- Nhóm sản phẩm (chuẩn hóa từ tên sản phẩm)

### 5.2 Chỉ số chính:

- ADO (Average Daily Orders)

- AdGMV (Average Daily GMV)

- Diff (Current – Previous)

- Tỷ trọng tăng trưởng: contrib

- Tỷ trọng ADO/AdGMV: share

## 6. Phương pháp phân tích

### 6.1 Phân tích tăng trưởng theo cấu trúc

Phân tích theo mô hình drill-down:

Ngành hàng Level 1 → Ngành hàng Level 2 → nhóm sản phẩm (đã chuẩn hóa theo keywords)

Tại mỗi cấp độ, tính:

    Diff (Current – Previous)

    MoM %

    Tỷ trọng đóng góp vào tổng tăng trưởng

Mục tiêu:

Không chỉ biết ngành tăng/giảm bao nhiêu %, mà biết tăng do ai và mức độ phụ thuộc cao hay thấp.

### 6.2 Đánh giá chất lượng tăng trưởng

Kết hợp hai yếu tố:

    Diff_ado/ Diff_gmv

    Tỷ trọng cấu trúc ADO/AdGMV

Phân loại LV2:

- Share lớn + tăng trưởng → Trụ cột tăng trưởng

- Share lớn + suy giảm → Rủi ro cấu trúc

- Share nhỏ + tăng trưởng → Cơ hội phát triển


Cách tiếp cận này giúp ưu tiên hành động thay vì chỉ nhìn vào tăng trưởng tuyệt đối.

### 6.3 Chuẩn hóa và gom nhóm sản phẩm

Dữ liệu gốc có tình trạng phân mảnh tên sản phẩm.

Giải pháp:

- Chuẩn hóa text

- Loại bỏ từ nhiễu

- Giữ lại 5 từ khóa chính

- Nhóm theo từ khóa sản phẩm 

Mục tiêu:

- Giảm nhiễu phân tích

- Tránh đếm lặp sản phẩm cùng bản chất

- Phản ánh đúng hành vi tiêu dùng

### 6.4 Xu hướng, đánh giá rủi ro và tiềm năng: 

Xây dựng theo logic:

- LV2 tăng/giảm liên tiếp ≥ 2 tháng gần nhất

- Sản phẩm tăng/giảm liên tiếp + mức giảm lớn + tỷ trọng ADO/AdGMV cao

Điều này giúp phát hiện sớm các nhóm có nguy cơ ảnh hưởng đến GMV tổng trước khi biểu hiện rõ ở cấp LV1.

## 7. Pipeline xử lý dữ liệu

SQL Layer

- Union dữ liệu nhiều tháng

- Chuẩn hóa định dạng

- Tạo trường year_month

- Aggregate theo LV2 và Product

- Tính MoM bằng window function LAG()

Output: Dataset sạch, có data dữ liệu kỳ trước, phục vụ cho phân tích dữ liệu sau nay.

File: cat_pfm_pipeline.sql

Python Layer

- Xử lý text sản phẩm

- Tính tỷ trọng tăng trưởng và tỷ trọng ADO/AdGMV

- Phân loại chất lượng tăng trưởng

- Xây dựng logic cảnh báo xu hướng

- Trực quan hóa phục vụ storytelling

Notebook:

[01_overview](notebooks/01_overview.ipynb)

[02_product_keyword](notebooks/02_product_keyword.ipynb)

[03_growth_driver](notebooks/03_growth_driver.ipynb)

[04_quality_growth](notebooks/04_quality_growth.ipynb)

[05_trend](notebooks/05_trend.ipynb)

## 8. Ví dụ Insight thực tế

Tháng 9:

Hai ngành Vehicle Essentials và Home & Technical Supplies tăng +6.71% ADO và +14.64% GMV MoM

![Ảnh](image/overview_chart.png)

Tuy nhiên, cấu trúc tăng trưởng khác nhau:

- Vehicle Essentials tăng trưởng theo số lượng đơn hàng , phụ thuộc vào 3 top LV2 chính (đóng góp >100% mức tăng ròng)

→ tăng trưởng tập trung, rủi ro phụ thuộc cao.

![Ảnh](image/vehical_diff.png)

Home & Technical Supplies tăng trưởng theo giá trị đơn hàng, 3 top LV2 đóng góp ~81.9% 

→ cấu trúc lan tỏa và ổn định hơn.

![Ảnh](image/home_diff.png)

Ngoài ra:

- Một số LV2 có tỷ trọng ADO/AdGMV lớn nhưng giảm liên tiếp → cảnh báo rủi ro cấu trúc

- Một số nhóm tăng liên tiếp ≥ 2 tháng → tín hiệu tăng trưởng bền vững

Kết luận:

- Cùng là tăng trưởng, nhưng mức độ ổn định và mức độ phụ thuộc cấu trúc khác nhau → cần chiến lược vận hành khác nhau.

## 9. Impact đạt được

- Giảm thời gian chuẩn bị báo cáo từ ~40 phút xuống 10–15 phút

- Chuẩn hóa logic phân tích → giảm sai sót thủ công

- Hỗ trợ xác định sớm nhóm ngành có rủi ro cấu trúc

- Tạo framework tái sử dụng cho các kỳ tiếp theo

- Nâng cấp báo cáo từ “mô tả số liệu” sang “giải thích bản chất tăng trưởng”

## 10. CẤU TRÚC REPOSITORY
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
## 11.Báo cáo đầu ra 
Đây là phiên bản báo cáo tổng hợp cuối cùng sau quá trình xử lý và phân tích dữ liệu

[BÁO CÁO CHI TIẾT](https://vannguyenhoai43-hash.github.io/ecommerce-category-growth-analysis/report_cat.html)


