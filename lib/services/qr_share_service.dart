import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRShareService {
  /// Chia sẻ chuỗi văn bản (nhanh gọn)
  static Future<void> shareText(String text) async {
    await Share.share(text);
  }

  /// Render QR ra PNG và chia sẻ dưới dạng file
  static Future<void> shareQrPng(BuildContext context, String data, {int size = 600}) async {
    try {
      // Render QR sang ui.Image
      final qrPainter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: true,
      );
      final uiImage = await qrPainter.toImage(size as double);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Không thể tạo PNG');

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Lưu file tạm
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(pngBytes, flush: true);

      // Chia sẻ
      await Share.shareXFiles([XFile(file.path)], text: 'Mã QR');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi chia sẻ ảnh QR: $e')),
        );
      }
    }
  }
}
