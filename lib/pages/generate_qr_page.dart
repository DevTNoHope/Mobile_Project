import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/qr_share_service.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({super.key});

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  final _ctrl = TextEditingController(text: 'https://example.com');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = _ctrl.text.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Tạo QR từ đường dẫn')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _ctrl,
            decoration: const InputDecoration(
              labelText: 'Nhập URL hoặc nội dung',
              prefixIcon: Icon(Icons.link),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
              ),
              child: QrImageView(
                data: value.isEmpty ? ' ' : value,
                version: QrVersions.auto,
                size: 220,
                gapless: true,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Chia sẻ nội dung'),
            onPressed: value.isEmpty ? null : () => QRShareService.shareText(value),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.image),
            label: const Text('Chia sẻ ảnh QR (PNG)'),
            onPressed: value.isEmpty
                ? null
                : () => QRShareService.shareQrPng(context, value, size: 600),
          ),
          const SizedBox(height: 12),
          Text(
            'Gợi ý: Nhập bất kỳ chuỗi nào (URL, text, JSON). Bạn có thể chia sẻ chuỗi trực tiếp '
                'hoặc xuất ảnh PNG của mã QR để gửi cho người khác.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
