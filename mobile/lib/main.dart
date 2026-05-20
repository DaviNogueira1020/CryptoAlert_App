import 'package:flutter/material.dart';
import 'package:mobile/presentation/pages/index.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Index(), // só isso
    );
  }
}