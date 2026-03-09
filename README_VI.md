# Phân tích Nhanh Tăng trưởng Ngành hàng E-commerce 

🌐 Đọc bằng: [English](README.md) | **Tiếng Việt**

## Tổng quan dự án

Khi phải đánh giá **hơn 17 ngành hàng nhỏ** trong thời gian ngắn, **tăng trưởng MoM tổng thể** thường không đủ để phản ánh đầy đủ chất lượng tăng trưởng. Chỉ số này cho biết **điều gì đã thay đổi**, nhưng không cho thấy **đâu là yếu tố thúc đẩy thay đổi, liệu tăng trưởng có lành mạnh về mặt cấu trúc hay không, và nhóm nào cần được ưu tiên hành động tiếp theo**.

Dự án này xây dựng một **báo cáo phân tích tăng trưởng ngành hàng vào cuối kỳ** phục vụ cho hoạt động review trong e-commerce. Bằng việc sử dụng **SQL** và **Python**, tôi phân tích hiệu suất từ **LV2 đến cấp độ sản phẩm** qua ba lớp: **Động lực tăng trưởng, Chất lượng tăng trưởng và Xu hướng tăng trưởng**. Kết quả đầu ra là một **báo cáo hỗ trợ ra quyết định** được thiết kế cho nhu cầu review ngành hàng nhanh, thay vì chỉ dừng lại ở báo cáo mô tả.

---

## Bộ dữ liệu

Dự án sử dụng dữ liệu của **3 tháng gần nhất**, bao gồm:
- **3 tháng dữ liệu**
- **2 ngành hàng LV1**
- **17 ngành hàng LV2**
- Hơn **500.000 dòng dữ liệu ở cấp độ item**

Các KPI chính:

- **ADO**
- **GMV**

> **Lưu ý:** MoM là so sánh giữa tháng hiện tại và tháng liền trước.  
> **Trend** hiện được theo dõi dưới dạng **tín hiệu liên tiếp trong 2 tháng** trong phạm vi cửa sổ dữ liệu hiện có.

---

## Những gì tôi đã thực hiện

- Làm sạch và hợp nhất dữ liệu nhiều tháng bằng **SQL**
- Chuẩn hóa dữ liệu để phục vụ so sánh giữa các kỳ
- Xử lý **tên item** nhằm nhóm các sản phẩm tương đồng vào cùng một nhóm sản phẩm
- Phân rã tăng trưởng từ **LV2 xuống cấp độ sản phẩm**
- Đánh giá tăng trưởng theo ba khía cạnh: **động lực, chất lượng và xu hướng**
- Tổng hợp kết quả thành một **báo cáo review cuối kỳ** có thể tái sử dụng

---

## Cấu trúc phân tích:

### 1. Động lực tăng trưởng

Xác định những **nhóm LV2** và **nhóm sản phẩm** đóng góp lớn nhất vào tăng trưởng hoặc suy giảm của ngành hàng.

**Các chỉ số chính**
- **Diff**
- **MoM %**
- **Mức đóng góp vào tăng trưởng tổng**

Lớp phân tích này giúp trả lời:
- nhóm nào đang thúc đẩy tăng trưởng
- nhóm nào đang kéo giảm hiệu suất
- liệu tăng trưởng có đang phụ thuộc quá mức vào một vài cụm lớn hay không

Chi tiết: [growth_driver](notebooks/03_growth_driver.ipynb)

### 2. Chất lượng tăng trưởng

Chất lượng tăng trưởng không được xác định chỉ bởi tăng trưởng dương. Thay vào đó, nó được đánh giá thông qua việc kết hợp:

- **Diff ADO / Diff GMV**
- **ADO Weight / GMV Weight**
- **mức thay đổi tỷ trọng theo LV2**

Cách tiếp cận này giúp phân biệt:

- **Tỷ trọng lớn + Tăng trưởng** → tăng trưởng cốt lõi  
- **Tỷ trọng nhỏ + Tăng trưởng** → cơ hội tăng trưởng mới nổi  
- **Tỷ trọng lớn + Suy giảm** → nhóm rủi ro mang tính cấu trúc  

Đồng thời, lớp này cũng giúp nhận diện những trường hợp mà **tăng trưởng về sản lượng và tăng trưởng về giá trị diễn biến khác chiều**, qua đó phản ánh sự không đồng đều về chất lượng tăng trưởng giữa các nhóm.

Chi tiết: [quality_growth](notebooks/04_quality_growth.ipynb)

### 3. Xu hướng tăng trưởng

Theo dõi động lượng ngắn hạn và các tín hiệu cảnh báo sớm.

**Các trọng tâm theo dõi**
- nhóm tăng trưởng trong **2 tháng liên tiếp**
- nhóm suy giảm trong **2 tháng liên tiếp**
- nhóm có tỷ trọng lớn nhưng ghi nhận mức suy giảm đáng kể

Lớp phân tích này được sử dụng như một **tín hiệu cảnh báo sớm** cho hoạt động review cuối kỳ.

Chi tiết: [trend](notebooks/05_trend.ipynb)

---

## Logic nhóm sản phẩm

Tên item thô thường thiếu tính nhất quán, khiến phân tích ở cấp độ sản phẩm dễ bị phân mảnh và nhiễu.

Để cải thiện điều này, tôi xây dựng một **logic nhóm sản phẩm dựa trên từ khóa** thông qua các bước:

- chuẩn hóa văn bản
- loại bỏ các từ gây nhiễu
- trích xuất từ khóa cốt lõi
- nhóm item theo mẫu từ khóa chi phối

Cách làm này giúp:

- giảm nhiễu trong phân tích
- tránh đếm trùng các sản phẩm tương tự
- làm rõ những nhóm sản phẩm thực sự đang thúc đẩy tăng trưởng ngành hàng

Bước này giúp đưa phân tích tiến gần hơn tới **động lực gốc ở cấp độ sản phẩm**, thay vì chỉ dừng lại ở biến động cấp ngành hàng.

Chi tiết: [product_keyword](notebooks/02_product_keyword.ipynb)

---

## Các phát hiện chính

- Trong **tháng 9**, cả **Vehicle Essentials** và **Home & Technical Supplies** đều tăng trưởng, nhưng cấu trúc phía sau tăng trưởng của hai ngành này lại rất khác nhau.

![Ảnh](image/overview_chart.png)

- **Vehicle Essentials** cho thấy **mức độ tập trung tăng trưởng cao**. Tăng trưởng ADO của ngành này chủ yếu đến từ **Safety Gear, In-car Utilities và Vehicle Add-ons**, đóng góp **123,4%** tổng tăng trưởng ADO. Ở GMV, **Personal Mobility, In-car Utilities và Vehicle Add-ons** đóng góp **272,8%** tổng tăng trưởng GMV. Điều này cho thấy **tăng trưởng tổng thể tích cực nhưng đi kèm rủi ro phụ thuộc cao**.

![Ảnh](image/vehical_diff.png)

- **Home & Technical Supplies** cũng tăng trưởng, nhưng với **cấu trúc đóng góp cân bằng hơn**. Tăng trưởng GMV của ngành này chủ yếu đến từ **Construction Materials, Manual Tools và Support Supplies**, đóng góp **81,9%** tổng tăng trưởng, qua đó cho thấy một **hồ sơ tăng trưởng ổn định hơn**.

![Ảnh](image/home_diff.png)

- Chất lượng tăng trưởng trở nên hữu ích hơn cho việc ra quyết định khi được đặt trong tương quan với quy mô. Ở **Vehicle Essentials**, **Safety Gear** và **In-car Utilities** là những nhóm tăng trưởng đáng chú ý với tỷ trọng lớn, trong khi **Riding Accessories** và **Repair Components** vẫn có quy mô lớn nhưng đang suy giảm. Ở **Home & Technical Supplies**, **Support Supplies** và **Manual Tools** nổi bật là các nhóm tăng trưởng mạnh, trong khi **Heavy-duty Equipment** là một nhóm có tỷ trọng lớn nhưng đang suy giảm.

- Những nhóm nhỏ hơn như **Mechanical Parts, Vehicle Add-ons, Personal Mobility** và **Construction Materials** tăng trưởng mạnh dù có tỷ trọng thấp hơn, vì vậy phù hợp hơn để được xem là **nhóm cần theo dõi** thay vì ngay lập tức coi là động lực tăng trưởng cốt lõi.

> **Kết luận chính:** những ngành hàng có mức tăng trưởng tổng thể tương tự nhau vẫn có thể có **mức độ tập trung tăng trưởng, chất lượng tăng trưởng và hồ sơ rủi ro** rất khác nhau — từ đó dẫn đến các ưu tiên hành động khác nhau.

---

## Phạm vi và hạn chế

Dự án này được thiết kế cho mục tiêu **phân tích nhanh vào cuối kỳ**, không nhằm phục vụ dự báo dài hạn hay phân tích nguyên nhân gốc rễ một cách toàn diện.

Do cửa sổ dữ liệu hiện tại chỉ bao gồm **3 tháng**, lớp **xu hướng** nên được hiểu là một **tín hiệu sớm**, chứ chưa phải kết luận dài hạn. Khung phân tích này được xây dựng để hỗ trợ việc ưu tiên hành động, và có thể trở nên mạnh hơn khi được bổ sung thêm dữ liệu lịch sử.

---

## Đầu ra bàn giao

- **Pipeline SQL** cho làm sạch và hợp nhất dữ liệu
- **Colab notebooks** cho từng mô-đun phân tích
- **Biểu đồ** phục vụ review ngành hàng nhanh
- **Báo cáo phân tích tăng trưởng ngành hàng cuối kỳ**

---

## Cấu trúc repository

```text
ecommerce-category-growth-analysis/
├── README.md
├── sql/
│   └── cat_pfm_pipeline.sql
├── notebooks/
│   ├── 01_overview.ipynb
│   ├── 02_product_keyword.ipynb
│   ├── 03_growth_driver.ipynb
│   ├── 04_quality_growth.ipynb
│   ├── 05_trend.ipynb
│   └── cat_quick_report.ipynb
├── src/
│   ├── load_data.py
│   ├── metrics.py
│   └── charts.py
└── report_cat.html
```
---
## 10.Báo cáo đầu ra 
Đây là phiên bản báo cáo tổng hợp cuối cùng sau quá trình xử lý và phân tích dữ liệu

[BÁO CÁO CHI TIẾT](https://vannguyenhoai43-hash.github.io/ecommerce-category-growth-analysis/report_cat.html)
