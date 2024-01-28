import 'dart:math';

import 'package:flutter/material.dart';

class Particle {
  Offset? position;
  Color? color;
  double? speed;
  double? theta;
  double? radius;

  Particle({
    this.position,
    this.color,
    this.speed,
    this.theta,
    this.radius,
  });
}

class RotatingTriangularBlobField extends StatefulWidget {
  const RotatingTriangularBlobField({super.key});

  @override
  State<RotatingTriangularBlobField> createState() =>
      _RotatingTriangularBlobFieldState();
}

class _RotatingTriangularBlobFieldState
    extends State<RotatingTriangularBlobField> with TickerProviderStateMixin {
  late List<Particle> particles;

  final double maxSpeed = 3;
  final double maxTheta = 2 * pi;
  final double maxRadius = 10;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    particles = [];
    createBlobField();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_rotationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _rotationController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _rotationController.forward();
        }
      });

    _rotationController.forward();

    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 2),
    // );
    // _animation = Tween<double>(
    //   begin: 0,
    //   end: 30,
    // ).animate(_animationController)
    //   ..addListener(() {
    //     if (particles.isEmpty) {
    //       createBlobField();
    //     }
    //   })
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       _animationController.repeat();
    //     } else if (status == AnimationStatus.dismissed) {
    //       _animationController.forward();
    //     }
    //   });
    // _animationController.forward();
  }

  Offset polarToCartesian(double radius, double theta) {
    double x = radius * cos(theta);
    double y = radius * sin(theta);
    return Offset(x, y);
  }

  Color getRandomColor() {
    var r = Random().nextInt(255);
    var g = Random().nextInt(255);
    var b = Random().nextInt(255);
    return Color.fromARGB(255, r, g, b);
  }

  void createBlobField() {
    const size = Offset(410, 900);
    final offset = Offset(size.dx / 2, size.dy / 2);
    const blobCount = 3;
    final radius = size.dx / blobCount;
    const alpha = 0.2;
    blobField(
      offset: offset,
      blobCount: blobCount,
      radius: radius,
      alpha: alpha,
    );
  }

  void blobField({
    required Offset offset,
    required int blobCount,
    required double radius,
    required double alpha,
  }) {
    if (radius < 1) return;

    var theta = 0.0;
    var dTheta = 2 * pi / blobCount;
    for (var i = 0; i < blobCount; i++) {
      var position = polarToCartesian(radius, theta) + offset;
      particles.add(
        Particle()
          ..theta = theta
          ..position = position
          ..radius = radius / 4
          ..color = getRandomColor(),
      );
      theta += dTheta;
      var childOrbitalRadius = 0.5;
      blobField(
        offset: position,
        blobCount: blobCount,
        radius: radius * childOrbitalRadius,
        alpha: alpha * 1.5,
      );
    }
  }

  @override
  void dispose() {
    // _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateZ(_rotationAnimation.value),
                  child: SizedBox(
                    height: 900,
                    width: 900,
                    child: CustomPaint(
                      painter: ParticlePainter(particles),
                      child: Container(),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(this.particles);

  Offset polarToCartesian(double speed, double theta) =>
      Offset(speed * cos(theta), speed * sin(theta));

  List<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    // for (var particle in particles) {
    //   var velocityMultiplier = 1 + 0.5 * sin(animationValue * 2 * pi);
    //   var velocity = polarToCartesian(
    //       particle.speed! * velocityMultiplier, particle.theta!);
    //   var dx = particle.position!.dx + velocity.dx;
    //   var dy = particle.position!.dy + velocity.dy;
    //
    //   if (particle.position!.dx < 0 || particle.position!.dx > size.width) {
    //     dx = Random().nextDouble() * size.width;
    //   }
    //   if (particle.position!.dy < 0 || particle.position!.dy > size.height) {
    //     dy = Random().nextDouble() * size.height;
    //   }
    //
    //   particle.position = Offset(dx, dy);
    // }

    for (var particle in particles) {
      Paint paint = Paint()
        ..color = particle.color!
        ..style = PaintingStyle.fill;
      canvas.drawCircle(particle.position!, particle.radius!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
