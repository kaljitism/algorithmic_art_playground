import 'package:flutter/material.dart';
import 'package:generative_art_playground/rotating_triangular_blob_field.dart';

void main() {
  runApp(const MyAnimationApp());
}

class MyAnimationApp extends StatelessWidget {
  const MyAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animation App',
      theme: ThemeData(useMaterial3: true).copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RotatingTriangularBlobField(),
    );
  }
}
