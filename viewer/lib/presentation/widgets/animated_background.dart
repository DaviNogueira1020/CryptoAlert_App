import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/particle_background.dart';

/// Widget reutilizável para aplicar o fundo animado em qualquer tela.
class AnimatedBackground extends StatelessWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Stack(
        children: [
          const Positioned.fill(child: ParticleBackground()),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}