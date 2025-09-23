import 'product.dart';
import '../services/product_api.dart';

class ScanHistory {
  final String code;
  final DateTime time;
  final Product? product;   // 🔹 Lưu luôn sản phẩm
  final String? rawContent; // 🔹 Lưu khi không phải mã vạch chuẩn

  ScanHistory({
    required this.code,
    required this.time,
    this.product,
    this.rawContent,
  });
}
