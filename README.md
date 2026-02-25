# Báo cáo nhanh hiệu quả ngành hàng (MoM)

## 1. Giới thiệu dự án

Dự án này xây dựng một **framework báo cáo nhanh hiệu quả ngành hàng theo tháng (Month-over-Month)**,  
nhằm hỗ trợ phân tích và trả lời nhanh các câu hỏi kinh doanh chính ngay khi có dữ liệu tháng mới.

Framework được thiết kế theo hướng:
- Xử lý dữ liệu thô và tổng hợp dữ liệu nhiều tháng bằng **SQL**
- Phân tích, tính toán chỉ số và trực quan hóa bằng **Python (Google Colab)**
- Có thể tái sử dụng cho nhiều tháng sau khi nhập dữ liệu mới

---
## 2.Tech Stack
- SQL (Data cleaning & aggregation)
- Python (Pandas, Matplotlib)
- Google Colab

## 3. Mục tiêu & câu hỏi kinh doanh

Dự án tập trung trả lời các câu hỏi:

1. **Hiệu suất tổng thể của ngành hàng Level 1 thay đổi như thế nào qua các tháng?**  
   → Đánh giá mức tăng/giảm của đơn và doanh thu theo tháng để nắm bức tranh tổng quan của ngành.

2. **Những yếu tố nào đang thúc đẩy hoặc kìm hãm tăng trưởng của Level 1?**  
   → Phân tích ngành hàng Level 2 và sản phẩm đóng vai trò chính trong mức tăng/giảm của đơn và doanh thu.

3. **Tăng trưởng hiện tại có chất lượng hay không?**  
   → Phân tích sự thay đổi tỷ trọng đơn và doanh thu để phân biệt:
   - Ngành hàng tăng trưởng tốt hoặc suy giảm dù chiếm tỷ trọng lớn.
   - Ngành hàng tăng trưởng nhanh nhưng xuất phát từ tỷ trọng nhỏ.

4. **Ngành hàng Level 2 nào đang có xu hướng tăng hoặc giảm rõ rệt trong 3 tháng gần nhất?**  
   → Phát hiện các xu hướng tăng/giảm mang tính liên tục thay vì chỉ biến động ngắn hạn theo từng tháng.

5. **Những sản phẩm nào cần được chú ý do có xu hướng tăng/ giảm đơn và doanh thu?**  
   → Lọc các sản phẩm tăng trưởng/suy giảm liên tiếp, mức giảm đủ lớn và có tỷ trọng đóng góp cao.

## 4. Phạm vi dữ liệu & chỉ số

### Cấp độ phân tích
- **Level 1 (LV1)**: Ngành hàng chính  
- **Level 2 (LV2)**: Ngành hàng chi tiết  
- **Sản phẩm (Items)**

### Chỉ số chính
- **ADO**: Số lượng đơn hàng ngày
- **AdGMV**: Giá trị doanh thu hàng ngày
- **grow_ado/ grow_gmv**: Tăng trưởng tháng so với tháng trước
- **diff_ado / diff_gmv**: Chênh lệch tuyệt đối
- **contrib_ado / contrib_gmv**: Mức độ đóng góp vào tăng trưởng chung
- **share_ado / share_gmv**: Tỷ trọng cơ cấu

---

## 5. Nội dung phân tích

### Phần 1: Tổng quan ngành hàng

Phần này cung cấp **bức tranh tổng quan về xu hướng tăng/giảm MoM của ngành hàng LV1** 
dựa trên hai chỉ số chính: **ADO** và **AdGMV**.

#### Nội dung phân tích
- So sánh biến động MoM của LV1 theo:
  - ADO 
  - AdGMV
- Đặt ADO và AdGMV trong cùng một biểu đồ để:
  - Quan sát xu hướng đồng pha / lệch pha
  - Làm cơ sở cho các bước phân tích động lực tăng trưởng ở các phần sau

#### Output
- Khái quát xu hướng tăng trưởng chung của toàn ngành LV1 theo thời gian
- Biểu đồ kết hợp:
  - Cột: AdGMV
  - Đường: ADO  
  giúp so sánh trực quan sự thay đổi về quy mô và giá trị giữa các tháng

Notebook: [01_overview.ipynb](notebooks/01_overview.ipynb)

---
### PHẦN 2: PHÂN TÍCH ĐỘNG LỰC TĂNG TRƯỞNG 

### Mục tiêu
Phân tích động lực tăng trưởng của từng ngành hàng LV1 theo tháng (MoM), xác định:
- Ngành hàng LV2 nào đóng góp chính vào tăng/giảm
- Các nhóm sản phẩm cụ thể tác động lớn đến kết quả
- Phân biệt rõ tăng trưởng **dương** và **âm** theo cả **ADO** và **AdGMV**

### Phương pháp phân tích

Phân tích được thực hiện từ cấp cao đến cấp thấp ( LV1 --> LV2 --> Sản phẩm), từ tổng quan đến chi tiết:

**Bước 1 – Cấp LV1**
- Tính mức tăng/giảm MoM của:
  - `ADO`
  - `AdGMV`
- Xác định LV1 đang:
  - Tăng trưởng dương
  - Tăng trưởng âm
  - Hoặc tăng trưởng lệch pha giữa đơn và doanh thu.

**Bước 2 – Cấp LV2**
- Với mỗi LV1:
  - Lấy **Top 3 LV2 tăng trưởng dương**
  - Lấy **Top 3 LV2 tăng trưởng âm**
- Tiêu chí:
  - `diff_ADO`
  - `diff_AdGMV`
- Đánh giá mức độ đóng góp của từng LV2 vào tổng biến động của LV1

**Bước 3 – Cấp sản phẩm**
- Với mỗi LV2 được chọn:
  - Phân tích các sản phẩm:
    - Có mức đóng góp tăng trưởng lớn và tăng/giảm mạnh nhất trong kỳ
- Mục tiêu:
  - Tập trung vào các sản phẩm thực sự tạo ra biến động
  - Tránh phân tích dàn trải, nhiễu insight

###  Chuẩn hoá & gom nhóm sản phẩm

Trong dữ liệu gốc:
- Mỗi dòng là một **tên sản phẩm duy nhất**
- Tuy nhiên, nhiều sản phẩm khác tên nhưng thực tế thuộc **cùng một nhóm sản phẩm**

**Ví dụ:**
- “Mũ Bảo Hiểm Nửa Đầu 1/2 Sơn Nhám Có Lỗ Thông Gió Freesize Cho Nam Nữ”
- “[Siêu Sale]Mũ bảo hiểm nửa đầu cao cấp cực đẹp và sang phù hợp cả nam và nữ giá rẻ ”  
→ Cùng thuộc nhóm **“mũ bảo hiểm nửa đầu”**

**Cách xử lý:**
- Làm sạch tên sản phẩm:
  - Loại bỏ từ gầy nhiễu (mô tả, quảng cáo, cảm tính)
  - Chuẩn hoá text
  - Giữ lại **5 từ khoá chính**
- Group lại dữ liệu theo **nhóm sản phẩm đã chuẩn hoá**
- Phân tích tăng trưởng dựa trên nhóm này thay vì tên sản phẩm thô

**Cách làm này giúp:**
- Giảm phân mảnh dữ liệu
- Phản ánh đúng hành vi tiêu dùng
- Nhận diện chính xác các nhóm sản phẩm tăng/giảm mạnh

Notebook: [03_growth_driver.ipynb](notebooks/03_growth_driver_.ipynb)

---

### Phần 3: Chất lượng tăng trưởng

- Phân tích thay đổi tỷ trọng qua các tháng:
  - ADO share
  - AdGMV share
- Phân nhóm LV2:
  - **Tỷ trọng lớn & tăng trưởng nhanh**  
    `diff_ado/gmv lớn + ado/gmv_share lớn`
  - **Tỷ trọng nhỏ & tăng trưởng nhanh**  
    `diff_ado/gmv lớn + ado/gmv_share nhỏ`
  - **Tỷ trọng lớn & tăng trưởng chậm/ suy giảm** 
    `diff_ado/gmv âm + ado/gmv_share lớn`

**Output**:
- Biểu đồ heatmap tỷ trọng theo tháng
- Kết hợp tỷ trọng và tăng trưởng để phân tích


Notebook: [04_quality_growth.ipynb](notebooks/04_quality_growth.ipynb)

---
### Phần 4: Xu hướng tăng trưởng 

- Phân tích xu hướng tăng/giảm của LV2:
  - Lv2 giảm liên tiếp ít nhất 2 tháng gần nhất
- Phân tích xu hướng sản phẩm theo 3 lớp:
  - **Lớp 1**: `diff_ado/gmv âm` liên tiếp ít nhất 2 tháng gần nhất
  - **Lớp 2**: Tổng mức giảm ADO/GMV lớn (`abs(sum(diff_ado/gmv))`)
  - **Lớp 3**: Sản phẩm có `max(share_ado/gmv)` lớn giữa các tháng

**Output**:
- Danh sách ngành hàng và sản phẩm rủi ro / tiềm năng.

Notebook: [05_trend.ipynb](notebooks/05_trend_.ipynb)

## 6. Cấu trúc repository
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
├── src/
│   ├── load_data.py
│   ├── metrics.py
│   └── charts.py
│
└── requirements.txt
```
## 7. Kết quả đạt được
- Giảm thời gian làm báo cáo từ ~40 phút xuống còn 10–15 phút
- Giảm sai sót so với thao tác thủ công
- Tạo framework phân tích có thể tái sử dụng cho các kỳ tiếp theo
