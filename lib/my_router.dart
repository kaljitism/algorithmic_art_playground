import 'package:flutter/material.dart';
import 'package:generative_art_playground/blob_field.dart';
import 'package:generative_art_playground/fading_object.dart';
import 'package:generative_art_playground/moving_particles.dart';
import 'package:generative_art_playground/rotating_triangular_blob_field.dart';

class MyRouter extends StatefulWidget {
  const MyRouter({super.key});

  @override
  State<MyRouter> createState() => _MyRouterState();
}

class _MyRouterState extends State<MyRouter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Generative Art',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FadingShape(),
                ),
              );
            },
            title: const Text('Fading Shape'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MovingParticles(),
                ),
              );
            },
            title: const Text('Moving Particles'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RotatingTriangularBlobField(),
                ),
              );
            },
            title: const Text('Rotating Triangular Blob Field'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BlobField(),
                ),
              );
            },
            title: const Text('Blob Field'),
          ),
        ],
      ),
    );
  }
}
