import 'package:flutter/material.dart';
import 'scan_history_service.dart';
import 'scan_history.dart';

class ScanHistoryPage extends StatelessWidget {
  const ScanHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final history = ScanHistoryService.getHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử quét"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Xóa tất cả",
            onPressed: () {
              // Xóa lịch sử
              ScanHistoryService.clearHistory();
              // Cập nhật lại UI
              (context as Element).reassemble();
            },
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(
        child: Text(
          "Chưa có dữ liệu",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.separated(
        itemCount: history.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final ScanHistory item = history[index];
          return ListTile(
            leading: const Icon(Icons.qr_code),
            title: Text(item.code),
            subtitle: Text(
              "${item.time.hour.toString().padLeft(2, '0')}:"
                  "${item.time.minute.toString().padLeft(2, '0')} "
                  "- ${item.time.day}/${item.time.month}/${item.time.year}",
            ),
          );
        },
      ),
    );
  }
}
