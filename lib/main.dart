import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(const SmartScanApp());

class SmartScanApp extends StatelessWidget {
  const SmartScanApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Scan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const HomePage(),
    );
  }
}
