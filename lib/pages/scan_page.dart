import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../widgets/scan_overlay.dart';
import 'result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _handled = false;
  final MobileScannerController _controller = MobileScannerController();

  void _onDetect(BarcodeCapture cap) {
    if (_handled) return;
    final raw = cap.barcodes.isNotEmpty ? cap.barcodes.first.rawValue : null;
    if (raw == null || raw.isEmpty) return;

    _handled = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultPage(content: raw)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _controller.switchCamera(),
            tooltip: 'Đổi camera',
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
            tooltip: 'Bật/tắt đèn',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          const ScanOverlay(), // khung ngắm
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.black54, borderRadius: BorderRadius.circular(12)),
              child: const Text(
                'Đưa mã QR/Barcode vào khung hình',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
