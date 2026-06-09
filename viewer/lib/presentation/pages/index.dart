import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),

      body: SafeArea(
        child: Column(
          children: [
            const Header(
              background: Colors.transparent,
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF0B0F1A),

                child: const Center(
                  child: Text(
                    'Conteúdo da tela',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),

            const Footer(
              initialBottonClicked: 1,
            ),
          ],
        ),
      ),
    );
  }
}