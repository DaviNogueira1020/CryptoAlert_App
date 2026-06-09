import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double dx;
  double dy;
  double radius;

  Particle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
  });
}

class SmokeParticle {
  double x;
  double y;
  double opacity;
  double radius;
  double dy;

  SmokeParticle({
    required this.x,
    required this.y,
    required this.opacity,
    required this.radius,
    required this.dy,
  });
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final List<Particle> particles = [];
  final List<SmokeParticle> smokeParticles = [];
  final random = Random();

  @override
  void initState() {
    super.initState();

    // Inicializa partículas
    for (int i = 0; i < 100; i++) {
      particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          dx: (random.nextDouble() - 0.5) * 0.00015,
          dy: (random.nextDouble() - 0.5) * 0.00015,
          radius: random.nextDouble() * 1.8 + 1,
        ),
      );
    }

    // Inicializa fumaça
    for (int i = 0; i < 20; i++) {
      smokeParticles.add(
        SmokeParticle(
          x: random.nextDouble(),
          y: random.nextDouble() * 0.8 + 0.2,
          opacity: random.nextDouble() * 0.5 + 0.2,
          radius: random.nextDouble() * 10 + 5,
          dy: -0.00005,
        ),
      );
    }

    controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )
      ..addListener(_updateParticles)
      ..forward();
  }

  void _updateParticles() {
    // Atualiza partículas normais
    for (final p in particles) {
      p.x += p.dx;
      p.y += p.dy;

      if (p.x < 0 || p.x > 1) {
        p.dx *= -1;
      }
      if (p.y < 0 || p.y > 1) {
        p.dy *= -1;
      }
    }

    // Atualiza fumaça
    for (final s in smokeParticles) {
      s.y += s.dy;
      s.opacity -= 0.0005;
      s.radius += 0.05;

      // Reinicia fumaça se desaparecer
      if (s.opacity <= 0 || s.y < 0) {
        s.x = random.nextDouble();
        s.y = 1.0;
        s.opacity = random.nextDouble() * 0.3 + 0.2;
        s.radius = random.nextDouble() * 5 + 2;
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: ParticlePainter(particles, smokeParticles),
        size: Size.infinite,
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final List<SmokeParticle> smokeParticles;

  ParticlePainter(this.particles, this.smokeParticles);

  @override
  void paint(Canvas canvas, Size size) {
    // Desenha linhas entre partículas
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];

        final dx = (p1.x - p2.x) * size.width;
        final dy = (p1.y - p2.y) * size.height;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 140) {
          final opacity = ((140 - distance) / 140).clamp(0.0, 1.0);
          final thickness = 0.3 + (opacity * 2.0);

          final linePaint = Paint()
            ..color = Color.lerp(
              Colors.transparent,
              const Color(0xFF7DF9FF),
              opacity,
            )!
            ..strokeWidth = thickness;

          canvas.drawLine(
            Offset(p1.x * size.width, p1.y * size.height),
            Offset(p2.x * size.width, p2.y * size.height),
            linePaint,
          );
        }
      }
    }

    // Desenha fumaça
    for (final s in smokeParticles) {
      final center = Offset(
        s.x * size.width,
        s.y * size.height,
      );

      final smokePaint = Paint()
        ..color = Colors.white.withOpacity(s.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center,
        s.radius,
        smokePaint,
      );
    }

    // Desenha partículas normais
    for (final p in particles) {
      final center = Offset(
        p.x * size.width,
        p.y * size.height,
      );

      final shadowPaint = Paint()
        ..color = const Color(0x337DF9FF);
      canvas.drawCircle(
        center,
        p.radius * 2.2,
        shadowPaint,
      );

      final particlePaint = Paint()
        ..color = const Color(0xFFB8FFFF);
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