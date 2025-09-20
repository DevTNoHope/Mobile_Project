import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const ScanShareApp());
}

class ScanShareApp extends StatelessWidget {
  const ScanShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan & Share QR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HomePage(),
    );
  }
}
