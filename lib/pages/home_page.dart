import 'package:flutter/material.dart';
import 'generate_qr_page.dart';
import 'scan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan & Share QR')),
      body: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Quét mã'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanPage()),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code),
              label: const Text('Tạo QR từ link'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GenerateQRPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
