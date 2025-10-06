import 'package:flutter/material.dart';

class ContributeProductPage extends StatelessWidget {
  const ContributeProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final border = const OutlineInputBorder();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đóng góp sản phẩm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thông tin sản phẩm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // Tên sản phẩm
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    hintText: 'Ví dụ: Sữa rửa mặt ABC',
                    border: border,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Thương hiệu
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Thương hiệu',
                    hintText: 'Ví dụ: ABC',
                    border: border,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Danh mục
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Danh mục',
                    border: border,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Chọn danh mục'),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Barcode + nút quét
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Mã vạch / QR',
                          hintText: 'Ví dụ: 8938505…',
                          border: border,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: null, // chưa có logic
                        icon: const Icon(Icons.qr_code_scanner,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Giá
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Giá tham khảo (VND)',
                    hintText: 'Ví dụ: 125000',
                    border: border,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Mô tả
                TextField(
                  minLines: 4,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Mô tả chi tiết',
                    hintText: 'Nhập thông tin chi tiết, mô tả, ghi chú...',
                    border: border,
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Ảnh sản phẩm
                const Text(
                  "Ảnh sản phẩm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: null, // chưa có logic
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Chọn ảnh'),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: null, // chưa có logic
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Chụp ảnh'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Khung ảnh minh họa
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    3,
                        (index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: const Center(
                        child: Icon(Icons.image_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Nút gửi
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: null, // chưa có logic
                    icon: const Icon(Icons.send),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Gửi đóng góp',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xfff5f6fa),
    );
  }
}