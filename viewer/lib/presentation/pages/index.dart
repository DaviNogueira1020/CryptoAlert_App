import 'package:flutter/material.dart';
import 'package:mobile/presentation/shell/main_shell.dart';

// index.dart - Redirecionamento para MainShell
class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainShell(initialIndex: 1);
  }
}
