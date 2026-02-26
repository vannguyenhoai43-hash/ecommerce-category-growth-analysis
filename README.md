# Báo cáo nhanh hiệu quả ngành hàng (MoM)

## 1. GIỚI THIỆU DỰ ÁN

Dự án này xây dựng một **framework báo cáo nhanh hiệu quả ngành hàng theo tháng (Month-over-Month)**,  
nhằm hỗ trợ phân tích và trả lời nhanh các câu hỏi kinh doanh chính ngay khi có dữ liệu tháng mới.

Framework được thiết kế theo hướng:
- Xử lý dữ liệu thô và tổng hợp dữ liệu nhiều tháng bằng **SQL**
- Phân tích, tính toán chỉ số và trực quan hóa bằng **Python (Google Colab)**
- Có thể tái sử dụng cho nhiều tháng sau khi nhập dữ liệu mới

---

## 2.TECH STACK
- SQL (Data cleaning & aggregation)
- Google Colab (Pandas, Numpy, Matplotlib)
  
---

## 3. MỤC TIÊU VÀ CÂU HỎI KINH DOANH

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

---

## 4. PHẠM VI DỮ LIỆU VÀ CÁC CHỈ SỐ

### Dữ liệu
- Danh mục ngành hàng đã được chuẩn hoá và tái cấu trúc cho mục đích phân tích, không phản ánh hệ thống phân loại gốc của nền tảng.
Trọng tâm dự án là phương pháp phân tích và tư duy dữ liệu.

### Cấp độ phân tích
- **Level 1 (LV1)**: Ngành hàng cấp 1  
- **Level 2 (LV2)**: Ngành hàng cấp 2 
- **Items**        : Sản phẩm

### Chỉ số chính
- **ADO**: Số lượng đơn hàng ngày
- **AdGMV**: Giá trị doanh thu hàng ngày
- Các chỉ số khác được tính toán theo cùng công thức cho cả ADO và AdGMV:

  - **Tăng trưởng tuyệt đối** = Kỳ hiện tại − Kỳ trước
  
  - **Tăng trưởng MoM (%)** = Tăng trưởng tuyệt đối / Kỳ trước
  
  - **Mức độ đóng góp** = Tăng trưởng của danh mục / Tổng tăng trưởng
  
  - **Tỷ trọng (Share)** = Giá trị danh mục / Tổng giá trị

---

## 5. NỘI DUNG PHÂN TÍCH

### PHẦN 1: TỔNG QUAN NGÀNH HÀNG

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

Chi tiết: [01_overview.ipynb](notebooks/01_overview.ipynb)

---

### PHẦN 2: CHUẨN HÓA VÀ GOM NHÓM SẢN PHẨM

Trong dữ liệu gốc:
- Mỗi dòng là một **tên sản phẩm duy nhất**
- Tuy nhiên, nhiều sản phẩm khác tên nhưng thực tế thuộc **cùng một nhóm sản phẩm**

**Ví dụ:**
- “Mũ Bảo Hiểm Nửa Đầu 1/2 Sơn Nhám Có Lỗ Thông Gió Freesize Cho Nam Nữ”
- “[Siêu Sale]Mũ bảo hiểm nửa đầu cao cấp cực đẹp và sang phù hợp cả nam và nữ giá rẻ ”  
→ Cùng thuộc nhóm **“mũ bảo hiểm nửa đầu”**

**Cách xử lý:**
- Làm sạch tên sản phẩm:
  - Loại bỏ từ gây nhiễu (mô tả, quảng cáo, cảm tính)
  - Chuẩn hoá text
  - Giữ lại **5 từ khoá chính**
- Group lại dữ liệu theo **nhóm sản phẩm đã chuẩn hoá**
- Phân tích tăng trưởng dựa trên nhóm này thay vì tên sản phẩm thô

**Mục tiêu:**
- Giảm phân mảnh dữ liệu
- Phản ánh đúng hành vi tiêu dùng
- Nhận diện chính xác các nhóm sản phẩm tăng/giảm mạnh

Notebook: [02_product_keyword.ipynb](notebooks/02_product_keyword.ipynb)

---

### PHẦN 3: PHÂN TÍCH ĐỘNG LỰC TĂNG TRƯỞNG

### Mục tiêu
Phân tích động lực tăng trưởng của từng ngành hàng LV1 theo tháng (MoM), xác định:
- Ngành hàng LV2 nào đóng góp chính vào tăng/giảm
- Các nhóm sản phẩm cụ thể tác động lớn đến kết quả

### Phương pháp phân tích

Phân tích được thực hiện từ cấp cao đến cấp thấp ( LV2 --> Sản phẩm), từ tổng quan đến chi tiết:

**Bước 1 – Cấp LV2**
- Với mỗi LV1:
  - Lấy **Top 3 LV2 tăng trưởng dương**
  - Lấy **Top 3 LV2 tăng trưởng âm**
- Chỉ số:
  - `diff_ADO`
  - `diff_AdGMV`
- Đánh giá mức độ đóng góp của từng LV2 vào tổng biến động của LV1

**Bước 2 – Cấp sản phẩm**
- Với mỗi LV2 được chọn:
  - Phân tích các sản phẩm:
    - Có mức đóng góp tăng trưởng lớn và tăng/giảm mạnh nhất trong kỳ
- Mục tiêu:
  - Tập trung vào các sản phẩm thực sự tạo ra biến động
  - Chỉ ra được các sản phẩm ảnh hưởng vào tăng trưởng của ngành hàng

Notebook: [03_growth_driver.ipynb](notebooks/03_growth_driver_.ipynb)

---

### PHẦN 4: CHẤT LƯỢNG TĂNG TRƯỞNG

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
### Phần 5: XU HƯỚNG TĂNG TRƯỞNG

- Phân tích xu hướng tăng/giảm của LV2:
  - Lv2 giảm liên tiếp ít nhất 2 tháng gần nhất
- Phân tích xu hướng sản phẩm theo 3 lớp:
  - **Lớp 1**: `diff_ado/gmv âm` liên tiếp ít nhất 2 tháng gần nhất
  - **Lớp 2**: Tổng mức giảm ADO/GMV lớn (`abs(sum(diff_ado/gmv))`)
  - **Lớp 3**: Sản phẩm có `max(share_ado/gmv)` lớn giữa các tháng

**Output**:
- Danh sách ngành hàng và sản phẩm rủi ro / tiềm năng.

Notebook: [05_trend.ipynb](notebooks/05_trend_.ipynb)

## 6. CẤU TRÚC REPOSITORY
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
## Báo cáo đầu ra 
Đây là phiên bản báo cáo tổng hợp cuối cùng sau quá trình xử lý và phân tích dữ liệu.

[link]  
(https://vannguyenhoai43-hash.github.io/ecommerce-category-growth-analysis/)
## 7. KẾT QUẢ ĐẠT ĐƯỢC
- Giảm thời gian làm báo cáo từ ~40 phút xuống còn 10–15 phút
- Giảm sai sót so với thao tác thủ công
- Tạo framework phân tích có thể tái sử dụng cho các kỳ tiếp theo
