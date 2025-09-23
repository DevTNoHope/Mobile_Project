import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hướng dẫn sử dụng")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            "📌 Cách sử dụng Smart Scan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          Text(
            "1. Quét mã:\n"
                "- Chọn nút 'Quét mã' để mở camera.\n"
                "- Đưa mã QR hoặc Barcode vào khung hình để quét.\n"
                "- Ứng dụng sẽ tự động hiển thị thông tin sản phẩm.",
          ),
          SizedBox(height: 12),

          Text(
            "2. Quét ảnh có sẵn:\n"
                "- Chọn 'Ảnh có sẵn' để chọn ảnh từ thư viện.\n"
                "- Ứng dụng sẽ phân tích ảnh và nhận diện mã.",
          ),
          SizedBox(height: 12),

          Text(
            "3. Lịch sử:\n"
                "- Chọn 'Lịch sử' để xem lại các mã đã quét.\n"
                "- Bấm vào một mục trong lịch sử để mở lại thông tin sản phẩm.",
          ),
          SizedBox(height: 12),

          Text(
            "4. Tạo mã QR:\n"
                "- Vào 'Tạo QR' để nhập nội dung và tạo mã QR.\n"
                "- Bạn có thể chia sẻ mã QR này cho người khác.",
          ),
          SizedBox(height: 12),

          Text(
            "5. Cài đặt:\n"
                "- Vào 'Cài đặt' để thay đổi giao diện, bật/tắt rung khi quét "
                "và xóa lịch sử quét.",
          ),
          SizedBox(height: 12),

          Text(
            "✅ Mẹo:\n"
                "- Đảm bảo camera rõ nét để quét nhanh hơn.\n"
                "- Nếu quét ban đêm, bật đèn flash để cải thiện độ chính xác.",
          ),
        ],
      ),
    );
  }
}
