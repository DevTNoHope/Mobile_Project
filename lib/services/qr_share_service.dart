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
  static Future<void> shareQrPng(
      BuildContext context,
      String data, {
        int size = 600,
        String fileName = 'qr.png',
      }) async {
    final d = size.toDouble();

    // 1) Tạo painter QR (màu đen)
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
      // Nếu muốn QR màu trắng: dùng dataModuleStyle với color: Colors.white
      // dataModuleStyle: const QrDataModuleStyle(color: Colors.white),
    );

    // 2) Ghi vào canvas có nền trắng
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    // Nền trắng để không bị preview đen “nuốt” QR
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, d, d), bgPaint);

    // Vẽ QR lên canvas
    qrPainter.paint(canvas, Size(d, d));

    // 3) Xuất thành ui.Image và PNG bytes
    final uiImage = await recorder.endRecording().toImage(size, size);
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) throw Exception('Không thể tạo PNG');
    final pngBytes = byteData.buffer.asUint8List();

    // 4) Lưu file tạm và share
    final dir = await getTemporaryDirectory();
    final file = await File('${dir.path}/$fileName').create(recursive: true);
    await file.writeAsBytes(pngBytes);

    await Share.shareXFiles([XFile(file.path)], text: 'QR: $data');
  }
}
