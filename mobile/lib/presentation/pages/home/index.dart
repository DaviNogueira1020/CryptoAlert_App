import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/rodape.dart';

void main() {
  runApp(const Index());
}

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Column(
          children: [
            const Header(),

            Expanded(
              child: Container(
                color: const Color(0xFF0B0F1A),
                child: const Center(
                  child: Text(
                    "Conteúdo da tela",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            const Rodape(initialBottonClicked: 1),
          ],
        ),
      ),
    );
  }
}
