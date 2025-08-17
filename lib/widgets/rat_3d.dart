import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Rat3DWidget extends StatelessWidget {
  const Rat3DWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Cube(
      onSceneCreated: (Scene scene) {
        final model = Object(fileName: 'assets/models/meu_modelo.glb');
        scene.world.add(model);
        scene.camera.zoom = 10;
      },
    );
  }
}
