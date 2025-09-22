// Chỉ dùng cho ảnh tĩnh (gallery)
import 'dart:io';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class BarcodeImageService {
  final BarcodeScanner _scanner =
  BarcodeScanner(formats: [BarcodeFormat.all]);

  Future<String?> scanFile(File file) async {
    final input = InputImage.fromFile(file);
    final result = await _scanner.processImage(input);
    if (result.isEmpty) return null;
    // Lấy barcode đầu tiên có rawValue
    for (final b in result) {
      final v = b.rawValue;
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  Future<void> dispose() async => _scanner.close();
}
