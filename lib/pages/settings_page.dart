import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool vibrateOnScan = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Chế độ tối"),
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
              // TODO: cập nhật theme toàn app
            },
          ),
          SwitchListTile(
            title: const Text("Rung khi quét"),
            value: vibrateOnScan,
            onChanged: (val) {
              setState(() => vibrateOnScan = val);
              // TODO: lưu vào SharedPreferences
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Ngôn ngữ"),
            subtitle: const Text("Tiếng Việt"),
            onTap: () {
              // TODO: chọn ngôn ngữ
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Xoá lịch sử quét"),
            onTap: () {
              // TODO: gọi ScanHistoryService.clearHistory()
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Giới thiệu"),
            subtitle: const Text("Phiên bản 1.0.0"),
          ),
        ],
      ),
    );
  }
}
