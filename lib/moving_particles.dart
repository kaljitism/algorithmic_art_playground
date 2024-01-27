import 'dart:math';

import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Color color;
  double speed;
  double theta;
  double radius;

  Particle({
    required this.position,
    required this.color,
    required this.speed,
    required this.theta,
    required this.radius,
  });
}

class MovingParticles extends StatefulWidget {
  const MovingParticles({super.key});

  @override
  State<MovingParticles> createState() => _MovingParticlesState();
}

class _MovingParticlesState extends State<MovingParticles>
    with SingleTickerProviderStateMixin {
  late List<Particle> particles;

  final double maxSpeed = 3;
  final double maxTheta = 2 * pi;
  final double maxRadius = 10;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    particles = List<Particle>.generate(
      1000,
      (index) => Particle(
        position: const Offset(-1, -1),
        color: getRandomColor(),
        speed: Random().nextDouble() * maxSpeed,
        theta: Random().nextDouble() * maxTheta,
        radius: Random().nextDouble() * maxRadius,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 30,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  Color getRandomColor() {
    var a = Random().nextInt(255);
    var r = Random().nextInt(255);
    var g = Random().nextInt(255);
    var b = Random().nextInt(255);
    return Color.fromARGB(a, r, g, b);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: ParticlePainter(particles, _animationController.value),
        child: Container(),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(this.particles, this.animationValue);

  Offset polarToCartesian(double speed, double theta) =>
      Offset(speed * cos(theta), speed * sin(theta));

  List<Particle> particles;
  double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      var velocityMultiplier = 1 + 0.5 * sin(animationValue * 2 * pi);
      var velocity =
          polarToCartesian(particle.speed * velocityMultiplier, particle.theta);
      var dx = particle.position.dx + velocity.dx;
      var dy = particle.position.dy + velocity.dy;

      if (particle.position.dx < 0 || particle.position.dx > size.width) {
        dx = Random().nextDouble() * size.width;
      }
      if (particle.position.dy < 0 || particle.position.dy > size.height) {
        dy = Random().nextDouble() * size.height;
      }

      particle.position = Offset(dx, dy);
    }

    for (var particle in particles) {
      Paint paint = Paint()
        ..color = particle.color
        ..strokeWidth = 5
        ..style = PaintingStyle.fill;
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}
