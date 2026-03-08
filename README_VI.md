# Phân tích Tăng trưởng Ngành hàng E-commerce

🌐 Đọc bằng: [English](README.md) | **Tiếng Việt**

## Tổng quan dự án

**Tăng trưởng MoM ở topline là một tín hiệu yếu** khi một team phải review **hơn 20 ngành hàng nhỏ** trong thời gian ngắn. Chỉ số này cho biết **điều gì đã thay đổi**, nhưng không cho thấy **đâu là yếu tố thúc đẩy sự thay đổi, liệu tăng trưởng có lành mạnh về mặt cấu trúc hay không, hoặc nhóm nào cần được ưu tiên hành động tiếp theo**.

Dự án này xây dựng một **báo cáo chẩn đoán tăng trưởng ngành hàng cuối kỳ** phục vụ cho hoạt động review trong e-commerce. Bằng cách sử dụng **SQL** và **Python**, tôi phân tích hiệu suất từ **LV2 đến cấp độ sản phẩm** qua ba lớp: **Động lực tăng trưởng, Chất lượng tăng trưởng và Xu hướng tăng trưởng**. Kết quả đầu ra là một **báo cáo hỗ trợ ra quyết định** được thiết kế cho việc review ngành hàng nhanh, không chỉ dừng ở báo cáo mô tả.

---

## Bộ dữ liệu

Dự án sử dụng dữ liệu của **3 tháng gần nhất**, bao gồm:

- **2 ngành hàng LV1**
- **20+ ngành hàng LV2**
- khoảng **500.000 dòng dữ liệu ở cấp độ item**

Các KPI chính:

- **ADO**
- **GMV**

> **Lưu ý:** MoM là so sánh giữa tháng hiện tại và tháng trước đó.  
> **Trend** hiện được theo dõi dưới dạng **tín hiệu liên tiếp trong 2 tháng** trong phạm vi cửa sổ dữ liệu hiện có.

---

## Những gì tôi đã thực hiện

- Làm sạch và hợp nhất dữ liệu nhiều tháng bằng **SQL**
- Chuẩn hóa dữ liệu để phục vụ so sánh giữa các kỳ
- Xử lý **tên item** để nhóm các sản phẩm tương tự vào cùng một nhóm sản phẩm
- Phân rã tăng trưởng từ **LV2 xuống cấp độ sản phẩm**
- Đánh giá tăng trưởng theo ba khía cạnh: **động lực, chất lượng và xu hướng**
- Tổng hợp kết quả thành một **báo cáo review cuối kỳ** có thể tái sử dụng

---

## Khung phân tích

### 1. Động lực tăng trưởng

Xác định những **nhóm LV2** và **nhóm sản phẩm** đóng góp nhiều nhất vào tăng trưởng hoặc suy giảm của ngành hàng.

**Các chỉ số chính**
- **Diff**
- **MoM %**
- **Mức đóng góp vào tăng trưởng tổng**

Lớp phân tích này trả lời:
- nhóm nào đang thúc đẩy tăng trưởng
- nhóm nào đang kéo hiệu suất đi xuống
- liệu tăng trưởng có đang phụ thuộc quá nhiều vào một vài cụm lớn hay không

### 2. Chất lượng tăng trưởng

Chất lượng tăng trưởng không được xác định chỉ bằng việc tăng trưởng dương. Nó được đánh giá thông qua việc kết hợp:

- **Diff ADO / Diff GMV**
- **ADO Weight / GMV Weight**
- **mức thay đổi tỷ trọng theo LV2**

Cách tiếp cận này giúp phân biệt giữa:

- **Tỷ trọng lớn + Tăng trưởng** → động lực tăng trưởng cốt lõi  
- **Tỷ trọng nhỏ + Tăng trưởng** → cơ hội mới nổi  
- **Tỷ trọng lớn + Suy giảm** → nhóm rủi ro mang tính cấu trúc  

Đồng thời, nó cũng giúp làm rõ những trường hợp mà **tăng trưởng về sản lượng và tăng trưởng về giá trị diễn biến khác nhau**, từ đó phản ánh chất lượng tăng trưởng không đồng đều giữa các nhóm.

### 3. Xu hướng tăng trưởng

Theo dõi động lượng ngắn hạn và các tín hiệu cảnh báo sớm.

**Các trọng tâm theo dõi**
- nhóm tăng trưởng trong **2 tháng liên tiếp**
- nhóm suy giảm trong **2 tháng liên tiếp**
- nhóm có tỷ trọng lớn đang suy giảm mạnh

Lớp phân tích này được sử dụng như một **tín hiệu cảnh báo sớm** cho hoạt động review cuối kỳ.

---

## Logic nhóm sản phẩm

Tên item gốc thường không nhất quán, khiến phân tích ở cấp độ sản phẩm bị phân mảnh và nhiễu.

Để cải thiện điều này, tôi xây dựng một **logic nhóm sản phẩm dựa trên từ khóa** bằng cách:

- chuẩn hóa văn bản
- loại bỏ từ gây nhiễu
- trích xuất từ khóa cốt lõi
- nhóm item theo mẫu từ khóa chi phối

Cách làm này giúp:

- giảm nhiễu trong phân tích
- tránh đếm trùng các sản phẩm tương tự
- làm rõ những nhóm sản phẩm thực sự đang thúc đẩy tăng trưởng ngành hàng

Bước này giúp phân tích tiến gần hơn tới **động lực gốc ở cấp độ sản phẩm**, thay vì chỉ dừng lại ở biến động cấp ngành hàng.

---

## Các insight chính

- Trong **tháng 9**, cả **Vehicle Essentials** và **Home & Technical Supplies** đều tăng trưởng, nhưng cấu trúc phía sau mức tăng đó lại rất khác nhau.

- **Vehicle Essentials** cho thấy **mức độ tập trung tăng trưởng cao**. Tăng trưởng ADO của ngành này chủ yếu đến từ **Safety Gear, In-car Utilities và Vehicle Add-ons**, đóng góp **123,4%** tổng tăng trưởng ADO. Ở GMV, **Personal Mobility, In-car Utilities và Vehicle Add-ons** đóng góp **272,8%** tổng tăng trưởng GMV. Điều này cho thấy **topline tăng trưởng dương nhưng đi kèm rủi ro phụ thuộc cao**.

- **Home & Technical Supplies** cũng tăng trưởng, nhưng với **cấu trúc đóng góp cân bằng hơn**. Tăng trưởng GMV của ngành này chủ yếu đến từ **Construction Materials, Manual Tools và Support Supplies**, đóng góp **81,9%** tổng tăng trưởng, cho thấy một **hồ sơ tăng trưởng ổn định hơn**.

- Chất lượng tăng trưởng trở nên hữu ích hơn cho việc hành động khi quy mô được đưa vào xem xét. Ở **Vehicle Essentials**, **Safety Gear** và **In-car Utilities** là những nhóm tăng trưởng đáng chú ý với tỷ trọng lớn, trong khi **Riding Accessories** và **Repair Components** vẫn có quy mô lớn nhưng đang suy giảm. Ở **Home & Technical Supplies**, **Support Supplies** và **Manual Tools** nổi bật là các nhóm tăng trưởng mạnh, trong khi **Heavy-duty Equipment** là một nhóm có tỷ trọng lớn nhưng đang suy giảm.

- Những nhóm nhỏ hơn như **Mechanical Parts, Vehicle Add-ons, Personal Mobility** và **Construction Materials** tăng trưởng mạnh dù có tỷ trọng thấp hơn, vì vậy phù hợp hơn để được xem là **nhóm cần theo dõi** thay vì ngay lập tức coi là động lực tăng trưởng cốt lõi.

> **Kết luận chính:** những ngành hàng có mức tăng trưởng topline tương tự nhau vẫn có thể có **mức độ tập trung tăng trưởng, chất lượng tăng trưởng và hồ sơ rủi ro** rất khác nhau — từ đó dẫn đến các ưu tiên hành động khác nhau.

---

## Phạm vi & Hạn chế

Dự án này được thiết kế cho mục tiêu **chẩn đoán nhanh vào cuối kỳ**, không nhằm phục vụ dự báo dài hạn hay phân tích nguyên nhân gốc rễ một cách đầy đủ.

Vì cửa sổ dữ liệu hiện tại chỉ bao gồm **3 tháng**, lớp **xu hướng** nên được hiểu là một **tín hiệu sớm**, chứ chưa phải kết luận dài hạn. Khung phân tích này được xây dựng để hỗ trợ việc ưu tiên hành động, và có thể trở nên mạnh hơn khi được bổ sung thêm dữ liệu lịch sử.

---

## Đầu ra bàn giao

- **Pipeline SQL** cho làm sạch và hợp nhất dữ liệu
- **Colab notebooks** cho từng mô-đun phân tích
- **Biểu đồ** phục vụ review ngành hàng nhanh
- **Báo cáo chẩn đoán tăng trưởng ngành hàng cuối kỳ**

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
