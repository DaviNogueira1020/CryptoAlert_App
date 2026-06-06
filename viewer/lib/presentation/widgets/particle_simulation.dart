import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ─── Modelo de partícula ───────────────────────────────────────────────────────

class _Particle {
  static int _idCounter = 0;
  final int id = _idCounter++;

  double x, y, xLast, yLast;
  double xSpeed = 0, ySpeed = 0;
  int age = 0;
  int attractorIndex;
  final double hue;
  final double sat;
  final double lum;

  _Particle({
    required this.x,
    required this.y,
    required this.attractorIndex,
    required this.hue,
    required this.sat,
    required this.lum,
  })  : xLast = x,
        yLast = y;
}

// ─── Lógica da simulação ───────────────────────────────────────────────────────

class _SimulationState {
  static const int lifespan    = 800;
  static const int popPerBirth = 3;
  static const int maxPop      = 300;
  static const double triangleRad = 180;
  static const double k         = 0.8;
  static const double visc      = 0.4;
  static const double speedMult = 0.1;
  static const double zoom      = 1.1;

  final _rand = Random();
  final List<_Particle> particles = [];
  final List<Offset> grid = [Offset.zero, Offset.zero, Offset.zero];
  int stepCount = 0;
  int deathCount = 0;

  void step() {
    stepCount++;
    _rotateGrid();
    _maybeSpawn();
    _move();
  }

  void _rotateGrid() {
    double angle = stepCount / 800.0;
    const r = triangleRad;
    grid[0] = Offset(r * cos(angle), r * sin(angle));
    angle += 2 * pi / 3;
    grid[1] = Offset(r * cos(angle), r * sin(angle));
    angle += 2 * pi / 3;
    grid[2] = Offset(r * cos(angle), r * sin(angle));
  }

  void _maybeSpawn() {
    if ((particles.length + popPerBirth) < maxPop) {
      for (int i = 0; i < popPerBirth; i++) {
        final x = 300 * (2 * _rand.nextDouble() - 1);
        final y = 300 * (2 * _rand.nextDouble() - 1);
        particles.add(_Particle(
          x: x,
          y: y,
          attractorIndex: _rand.nextInt(3),
          hue: 230,
          sat: 100,
          lum: 30 + 20 * _rand.nextDouble(),
        ));
      }
    }
  }

  void _move() {
    final toRemove = <int>[];
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      p.xLast = p.x;
      p.yLast = p.y;

      final prob = pow(0.55 * sin(stepCount / 40.0).abs(), 3).toDouble();
      if (_rand.nextDouble() < prob) {
        p.attractorIndex = _rand.nextInt(3);
      }

      final spot = grid[p.attractorIndex];
      final dx = p.x - spot.dx;
      final dy = p.y - spot.dy;

      p.xSpeed += -k * dx;
      p.ySpeed += -k * dy;
      p.xSpeed *= visc;
      p.ySpeed *= visc;

      p.x += speedMult * p.xSpeed;
      p.y += speedMult * p.ySpeed;
      p.age++;

      if (p.age > lifespan) {
        toRemove.add(i);
        deathCount++;
      }
    }
    for (final i in toRemove.reversed) {
      particles.removeAt(i);
    }
  }

  Offset toCanvas(double x, double y, Size size) => Offset(
        size.width / 2 + x * zoom,
        size.height / 2 + y * zoom,
      );
}

// ─── Trail (snapshot por frame) ───────────────────────────────────────────────

class _Trail {
  final double x, y, xLast, yLast, hue, sat, lum;
  const _Trail(this.x, this.y, this.xLast, this.yLast, this.hue, this.sat, this.lum);
}

// ─── Painter ──────────────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final _SimulationState sim;
  final List<_Trail> trails;

  _ParticlePainter(this.sim, this.trails);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0x1A000000),
    );

    for (final t in trails) {
      final last = sim.toCanvas(t.xLast, t.yLast, size);
      final now  = sim.toCanvas(t.x, t.y, size);
      final dist = sqrt(t.x * t.x + t.y * t.y);
      final lineW = max(0.3, 2 - dist / 50);

      canvas.drawLine(
        last,
        now,
        Paint()
          ..color = HSLColor.fromAHSL(1.0, t.hue, t.sat / 100, t.lum / 100).toColor()
          ..strokeWidth = 1.5 * lineW
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}

// ─── Componente público ────────────────────────────────────────────────────────
//
// Uso:
//   ParticleCanvas()                        // ocupa todo o espaço disponível
//   ParticleCanvas(width: 400, height: 300) // tamanho fixo
//   ParticleCanvas(showHud: true)           // exibe contador alive/dead/step

class ParticleCanvas extends StatefulWidget {
  final double? width;
  final double? height;
  final bool showHud;

  const ParticleCanvas({
    super.key,
    this.width,
    this.height,
    this.showHud = false,
  });

  @override
  State<ParticleCanvas> createState() => _ParticleCanvasState();
}

class _ParticleCanvasState extends State<ParticleCanvas>
    with SingleTickerProviderStateMixin {
  final _sim = _SimulationState();
  late final Ticker _ticker;
  List<_Trail> _trails = [];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration _) {
    _sim.step();
    final newTrails = _sim.particles
        .map((p) => _Trail(p.x, p.y, p.xLast, p.yLast, p.hue, p.sat, p.lum))
        .toList();
    setState(() => _trails = newTrails);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvas = RepaintBoundary(
      child: CustomPaint(
        painter: _ParticlePainter(_sim, _trails),
        child: const SizedBox.expand(),
      ),
    );

    Widget content = widget.showHud
        ? Stack(children: [
            canvas,
            Positioned(
              left: 12,
              bottom: 12,
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alive: ${_sim.particles.length}'),
                    Text('Dead:  ${_sim.deathCount}'),
                    Text('Step:  ${_sim.stepCount}'),
                  ],
                ),
              ),
            ),
          ])
        : canvas;

    return ClipRect(
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child: content,
      ),
    );
  }
}
