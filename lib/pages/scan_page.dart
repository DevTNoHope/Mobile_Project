import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/barcode_image_service.dart';
import '../services/product_api.dart';
import '../widgets/scan_overlay.dart';
import 'product_result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  DateTime? _lastDetectAt;
  final MobileScannerController _controller = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.all], // QR, EAN-13, UPC-A, ...
  );

  bool _handling = false;
  TorchState _torch = TorchState.off; // tự quản lý icon đèn

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture cap) async {
    if (_handling) return;
    _handling = true;
    _lastDetectAt = DateTime.now(); // <-- đánh dấu đã detect
    final raw = cap.barcodes.isNotEmpty ? cap.barcodes.first.rawValue : null;
    if (raw == null || raw.isEmpty) {
      _handling = false;
      return;
    }

    final code = raw.trim();
    final isNumericBarcode = RegExp(r'^\d{8,14}$').hasMatch(code);

    if (!mounted) return;

    if (isNumericBarcode) {
      final prod = await ProductApi.fetchByBarcode(code);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductResultPage(barcode: code, product: prod)),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductResultPage(barcode: '—', product: null, rawContent: code),
        ),
      );
    }

    _handling = false; // cho phép detect tiếp sau khi quay lại
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller.toggleTorch();
      setState(() {
        if (_torch == TorchState.unavailable) return;
        _torch = (_torch == TorchState.on) ? TorchState.off : TorchState.on; // coi auto như off
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _torch = TorchState.unavailable);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thiết bị không hỗ trợ đèn flash')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    // Dùng ML Kit để đọc ảnh tĩnh (ổn định hơn analyzeImage của mobile_scanner)
    final svc = BarcodeImageService();
    try {
      final code = await svc.scanFile(File(picked.path));
      if (!mounted) return;

      if (code == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy mã trong ảnh đã chọn')),
        );
        return;
      }

      // Tái sử dụng flow hiện có
      final isNumericBarcode = RegExp(r'^\d{8,14}$').hasMatch(code);
      if (isNumericBarcode) {
        final prod = await ProductApi.fetchByBarcode(code);
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductResultPage(barcode: code, product: prod),
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductResultPage(
              barcode: '—',
              product: null,
              rawContent: code,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi phân tích ảnh: $e')),
      );
    } finally {
      await svc.dispose();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã'),
        actions: [
          IconButton(
            onPressed: () => _controller.switchCamera(),
            icon: const Icon(Icons.cameraswitch),
            tooltip: 'Đổi camera',
          ),
          IconButton(
            onPressed: _torch == TorchState.unavailable ? null : _toggleTorch,
            icon: Icon(_torch == TorchState.on ? Icons.flash_on : Icons.flash_off),
            tooltip: _torch == TorchState.unavailable ? 'Đèn không khả dụng' : 'Bật/tắt đèn',
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          // phủ kính ngắm
          ScanOverlay(
            onPickImage: _pickImage,
            onToggleTorch: _toggleTorch,
            onSwitchCamera: () => _controller.switchCamera(),
            isTorchOn: _torch == TorchState.on,
            isTorchAvailable: _torch != TorchState.unavailable,
            hintText: 'Đưa mã QR/Barcode vào khung hình',
          ),
        ],
      ),

    );
  }
}
