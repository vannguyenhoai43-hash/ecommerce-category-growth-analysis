# 📊 Báo cáo nhanh hiệu quả ngành hàng (MoM)

## 1. Giới thiệu dự án

Dự án này xây dựng một **framework báo cáo nhanh hiệu quả ngành hàng theo tháng (Month-over-Month)**,  
nhằm hỗ trợ phân tích và trả lời nhanh các câu hỏi kinh doanh chính ngay khi có dữ liệu tháng mới.

Framework được thiết kế theo hướng:
- Xử lý dữ liệu thô và tổng hợp bằng **SQL**
- Phân tích, tính toán chỉ số và trực quan hóa bằng **Python (Google Colab)**
- Có thể tái sử dụng cho nhiều tháng bằng cách nhập dữ liệu mới

---

## 2. Mục tiêu & câu hỏi kinh doanh

Dự án tập trung trả lời các câu hỏi:

- Ngành hàng đang **tăng trưởng hay suy giảm**?
- Tăng trưởng đến từ **số lượng đơn (ADO)** hay **giá trị (AdGMV)**?
- Động lực tăng trưởng đến từ **nhóm ngành nhỏ (LV2)** hay **sản phẩm cụ thể** nào?
- Tăng trưởng có **bền vững** hay chỉ phụ thuộc vào một số nhóm nhỏ?
- Ngành/sản phẩm nào đang có **xu hướng suy giảm liên tục** và cần theo dõi?

---

## 3. Phạm vi dữ liệu & chỉ số

### Cấp độ phân tích
- **Level 1 (LV1)**: Ngành hàng chính  
- **Level 2 (LV2)**: Ngành hàng chi tiết  
- **Sản phẩm (Item)**

### Chỉ số chính
- **ADO**: Số lượng đơn hàng ngày
- **AdGMV**: Giá trị doanh thu hàng ngày
- **MoM Growth**: Tăng trưởng tháng so với tháng trước
- **diff_ADO / diff_AdGMV**: Chênh lệch tuyệt đối
- **contrib_ADO / contrib_AdGMV**: Mức độ đóng góp vào tăng trưởng chung
- **share_ADO / share_AdGMV**: Tỷ trọng cơ cấu

---

## 4. Nội dung phân tích

### Phần 1: Tổng quan ngành hàng (MoM)

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
---

## 📊 PHẦN 2: PHÂN TÍCH ĐỘNG LỰC TĂNG TRƯỞNG (GROWTH DRIVER ANALYSIS)

### 🎯 Mục tiêu
Phân tích động lực tăng trưởng của từng ngành hàng (LV1) theo tháng (MoM), xác định:
- Ngành hàng con (LV2) nào đóng góp chính vào tăng/giảm
- Các nhóm sản phẩm cụ thể tác động lớn đến kết quả
- Phân biệt rõ tăng trưởng **dương** và **âm** theo cả **volume (ADO)** và **value (AdGMV)**

---

### 🧠 Phương pháp phân tích

Phân tích được thực hiện theo hướng **top-down**, từ tổng quan đến chi tiết:

**Bước 1 – Cấp LV1**
- Tính mức tăng/giảm MoM của:
  - `ADO`
  - `AdGMV`
- Xác định LV1 đang:
  - Tăng trưởng dương
  - Tăng trưởng âm
  - Hoặc tăng trưởng lệch pha giữa volume và value

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
    - Có mức đóng góp tăng trưởng lớn
    - Hoặc giảm mạnh nhất trong kỳ
- Mục tiêu:
  - Tập trung vào các sản phẩm thực sự tạo ra biến động
  - Tránh phân tích dàn trải, nhiễu insight

---

### 🧹 Chuẩn hoá & gom nhóm sản phẩm

Trong dữ liệu gốc:
- Mỗi dòng là một **tên sản phẩm duy nhất**
- Tuy nhiên, nhiều sản phẩm khác tên nhưng thực tế thuộc **cùng một nhóm sản phẩm**

**Ví dụ:**
- “mũ bảo hiểm 3/4 siêu đẹp”
- “mũ bảo hiểm 3/4 bền màu sắc”  
→ Cùng thuộc nhóm **“mũ bảo hiểm 3/4”**

**Cách xử lý:**
- Làm sạch tên sản phẩm:
  - Loại bỏ từ noise (mô tả, quảng cáo, cảm tính)
  - Chuẩn hoá text
  - Giữ lại **5 từ khoá chính**
- Group lại dữ liệu theo **nhóm sản phẩm đã chuẩn hoá**
- Phân tích tăng trưởng dựa trên nhóm này thay vì tên sản phẩm thô

➡️ Cách làm này giúp:
- Giảm phân mảnh dữ liệu
- Phản ánh đúng hành vi tiêu dùng
- Nhận diện chính xác các nhóm sản phẩm tăng/giảm mạnh

---

### 📈 Kết quả phân tích (ví dụ: Automotive)

#### 2.1. Các LV2 đóng góp tăng trưởng dương
- **ADO (Volume):**
  - Tăng trưởng chủ yếu đến từ các LV2:
    - Helmets
    - Interior Accessories
    - Exterior Accessories
- **AdGMV (Value):**
  - Động lực tăng trưởng tập trung ở:
    - Bike / E-bike
    - Interior Accessories
    - Exterior Accessories

Biểu đồ `ADO Diff` và `GMV Diff` cho thấy:
- Một số LV2 đóng góp vượt 100% tổng tăng trưởng
- Tăng trưởng thực tế bị bù trừ bởi các nhóm giảm

---

#### 2.2. Các LV2 tăng trưởng âm
- Các LV2 suy giảm chính:
  - Motorbike Accessories
  - Motorbike Spare Parts
  - Automotive Oils & Lubes
- Nhóm này chiếm tỷ trọng lớn trong tổng mức giảm MoM

Phân tích xu hướng 3 tháng cho thấy:
- Một số LV2 có xu hướng:
  - Giảm liên tục
  - Hoặc phục hồi yếu sau khi giảm

---

### 💡 Insight chính
- Tăng trưởng của LV1 không đến từ toàn bộ LV2, mà tập trung vào một số ngành con cụ thể
- Có sự lệch pha giữa tăng trưởng volume (ADO) và value (AdGMV)
- Việc chuẩn hoá và gom nhóm sản phẩm giúp:
  - Nâng cao chất lượng insight
---

### Phần 3: Chất lượng tăng trưởng

- Phân tích thay đổi cơ cấu:
  - ADO share
  - AdGMV share
- Phân nhóm LV2:
  - **Quy mô lớn & tăng trưởng tốt**  
    `diff_ADO lớn + ado_share lớn`
  - **Tăng trưởng cao nhưng base nhỏ**  
    `diff_ADO lớn + ado_share nhỏ`
  - **Suy giảm nhanh**  
    `% growth âm mạnh MoM`

**Output**:
- Scatter plot (quy mô vs tăng trưởng)
- Bảng phân nhóm LV2

---

### Phần 4: Xu hướng tăng trưởng (3 tháng)

- Phân tích xu hướng tăng/giảm của LV2
- Phân tích xu hướng sản phẩm theo 3 lớp:
  - **Lớp 1**: `diff_ADO < 0` liên tiếp ≥ 2 tháng gần nhất
  - **Lớp 2**: Tổng mức giảm ADO lớn (`abs(sum(diff_ADO))`)
  - **Lớp 3**: Sản phẩm có `max(share_ADO)` lớn

**Output**:
- Line chart xu hướng
- Danh sách sản phẩm rủi ro / cơ hội

---

## 5. Cấu trúc repository
