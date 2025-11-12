import 'package:flutter/material.dart';
import 'translator.dart';

void main() {
  runApp(const LughafyApp());
}

class LughafyApp extends StatelessWidget {
  const LughafyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lughafy',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const TranslatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
