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

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final List<Particle> particles = [];33159

  final Random random = Random();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 250; i++) {
      particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          dx: (random.nextDouble() - 0.5) * 0.0070,
          dy: (random.nextDouble() - 0.5) * 0.0070,
          radius: random.nextDouble() * 0.5 + 1,
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
    for (final p in particles) {
      p.x += p.dx;
      p.y += p.dy;

      if (p.x < 0 || p.x > 1) p.dx *= -1;
      if (p.y < 0 || p.y > 1) p.dy *= -1;
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
        painter: ParticlePainter(particles),
        size: Size.infinite,
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particle;

  ParticlePainter(this.particle);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particle.length; i++) {
      for (int j = i + 1; j < particle.length; j++) {
        final p1 = particle[i];
        final p2 = particle[j];

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

    for (final p in particle) {
      final center = Offset(p.x * size.width, p.y * size.height);

      final shadowPaint = Paint()
        ..color = const Color(0x337DF9FF);
      canvas.drawCircle(center, p.radius * 2.2, shadowPaint);

      final particlePaint = Paint()
        ..color = const Color(0xFFB8FFFF);
      canvas.drawCircle(center, p.radius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}