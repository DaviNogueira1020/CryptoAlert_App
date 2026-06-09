import 'dart:math';
import 'package:flutter/material.dart';

/// Classe que representa uma partícula no fundo animado.
class Particle {
  double x;       // Posição horizontal (0.0 a 1.0)
  double y;       // Posição vertical (0.0 a 1.0)
  double dx;      // Velocidade horizontal
  double dy;      // Velocidade vertical
  double radius;  // Raio da partícula

  Particle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
  });
}

/// Classe que representa uma partícula de fumaça.
class SmokeParticle {
  double x;         // Posição horizontal (0.0 a 1.0)
  double y;         // Posição vertical (0.0 a 1.0)
  double opacity;   // Opacidade (0.0 a 1.0)
  double radius;    // Raio da fumaça
  double dy;        // Velocidade vertical (subida)

  SmokeParticle({
    required this.x,
    required this.y,
    required this.opacity,
    required this.radius,
    required this.dy,
  });
}

/// Widget que exibe o fundo animado com partículas e fumaça.
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final List<Particle> particles = [];      // Lista de partículas
  final List<SmokeParticle> smokeParticles = []; // Lista de fumaça
  final Random random = Random();          // Gerador de números aleatórios

  @override
  void initState() {
    super.initState();

    // Inicializa 100 partículas
    for (int i = 0; i < 100; i++) {
      particles.add(
        Particle(
          x: random.nextDouble(),                     // Posição X aleatória
          y: random.nextDouble(),                     // Posição Y aleatória
          dx: (random.nextDouble() - 0.5) * 0.00015, // Velocidade X aleatória
          dy: (random.nextDouble() - 0.5) * 0.00015, // Velocidade Y aleatória
          radius: random.nextDouble() * 1.8 + 1,     // Raio entre 1.0 e 2.8
        ),
      );
    }

    // Inicializa 20 partículas de fumaça
    for (int i = 0; i < 20; i++) {
      smokeParticles.add(
        SmokeParticle(
          x: random.nextDouble(),                     // Posição X aleatória
          y: random.nextDouble() * 0.8 + 0.2,        // Posição Y (mais embaixo)
          opacity: random.nextDouble() * 0.5 + 0.2, // Opacidade entre 0.2 e 0.7
          radius: random.nextDouble() * 10 + 5,      // Raio entre 5 e 15
          dy: -0.00005,                              // Velocidade de subida (negativo = sobe)
        ),
      );
    }

    // Configura o AnimationController para atualizar as partículas
    controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), // Duração longas para loop contínuo
    )
      ..addListener(_updateParticles) // Chama _updateParticles a cada frame
      ..forward(); // Inicia a animação
  }

  /// Atualiza a posição das partículas e da fumaça
  void _updateParticles() {
    // Atualiza partículas normais
    for (final p in particles) {
      p.x += p.dx; // Move na horizontal
      p.y += p.dy; // Move na vertical

      // Inverte a direção se bater nas bordas
      if (p.x < 0 || p.x > 1) p.dx *= -1;
      if (p.y < 0 || p.y > 1) p.dy *= -1;
    }

    // Atualiza fumaça
    for (final s in smokeParticles) {
      s.y += s.dy;        // Move a fumaça para cima
      s.opacity -= 0.0005; // Reduz a opacidade (desvanece)
      s.radius += 0.05;   // Aumenta o raio (expande)

      // Reinicia a fumaça se ela desaparecer ou sair da tela
      if (s.opacity <= 0 || s.y < 0) {
        s.x = random.nextDouble();
        s.y = 1.0; // Reinicia embaixo
        s.opacity = random.nextDouble() * 0.3 + 0.2;
        s.radius = random.nextDouble() * 5 + 2;
      }
    }

    setState(() {}); // Atualiza a tela
  }

  @override
  void dispose() {
    controller.dispose(); // Libera o AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      // Ignora toques na tela (para não atrapalhar a interação com os widgets acima)
      child: CustomPaint(
        painter: ParticlePainter(particles, smokeParticles),
        size: Size.infinite, // Ocupa todo o espaço disponível
      ),
    );
  }
}

/// Classe responsável por desenhar as partículas e a fumaça no Canvas.
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final List<SmokeParticle> smokeParticles;

  ParticlePainter(this.particles, this.smokeParticles);

  @override
  void paint(Canvas canvas, Size size) {
    // --- Desenha linhas entre partículas próximas ---
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];

        // Calcula a distância entre as partículas
        final dx = (p1.x - p2.x) * size.width;
        final dy = (p1.y - p2.y) * size.height;
        final distance = sqrt(dx * dx + dy * dy);

        // Desenha linha se a distância for menor que 140
        if (distance < 140) {
          final opacity = ((140 - distance) / 140).clamp(0.0, 1.0); // Opacidade baseada na distância
          final thickness = 0.3 + (opacity * 2.0); // Espessura da linha

          final linePaint = Paint()
            ..color = Color.lerp(
              Colors.transparent,
              const Color(0xFF7DF9FF), // Cor ciano clara
              opacity,
            )!
            ..strokeWidth = thickness;

          // Desenha a linha entre as partículas
          canvas.drawLine(
            Offset(p1.x * size.width, p1.y * size.height),
            Offset(p2.x * size.width, p2.y * size.height),
            linePaint,
          );
        }
      }
    }

    // --- Desenha a fumaça ---
    for (final s in smokeParticles) {
      final center = Offset(
        s.x * size.width,
        s.y * size.height,
      );

      final smokePaint = Paint()
        ..color = Colors.white.withOpacity(s.opacity) // Cor branca com opacidade dinâmica
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center,
        s.radius,
        smokePaint,
      );
    }

    // --- Desenha as partículas ---
    for (final p in particles) {
      final center = Offset(
        p.x * size.width,
        p.y * size.height,
      );

      // Desenha o "glow" (sombra) da partícula
      final shadowPaint = Paint()
        ..color = const Color(0x337DF9FF); // Cor ciano com opacidade baixa
      canvas.drawCircle(
        center,
        p.radius * 2.2, // Raio maior para o glow
        shadowPaint,
      );

      // Desenha a partícula em si
      final particlePaint = Paint()
        ..color = const Color(0xFFB8FFFF); // Cor ciano claro
      canvas.drawCircle(
        center,
        p.radius,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// Fim do codigo de animação de partículas e fumaça