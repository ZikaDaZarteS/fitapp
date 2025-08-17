import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/rat_evolution.dart';
import 'dart:math' as math;

class Model3DViewer extends StatefulWidget {
  final RatEvolution evolution;
  final double size;
  final bool enableRotation;
  final bool enableZoom;
  final bool autoRotate;

  const Model3DViewer({
    super.key,
    required this.evolution,
    this.size = 200,
    this.enableRotation = true,
    this.enableZoom = true,
    this.autoRotate = true,
  });

  @override
  State<Model3DViewer> createState() => _Model3DViewerState();
}

class _Model3DViewerState extends State<Model3DViewer> {
  @override
  Widget build(BuildContext context) {
    // Se não há modelo 3D disponível, mostra a imagem padrão
    if (widget.evolution.modelPath == null) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(widget.evolution.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Para arquivos .glb, usa ModelViewer
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ModelViewer(
          backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          src: widget.evolution.modelPath!,
          alt: widget.evolution.description,
          ar: widget.enableRotation,
          autoRotate: widget.autoRotate,
          disableZoom: !widget.enableZoom,
          cameraControls: widget.enableRotation,
          environmentImage: null,
          cameraOrbit: '0deg 75deg 105%',
          minCameraOrbit: 'auto auto auto',
          maxCameraOrbit: 'auto auto auto',
          autoPlay: true,
          loading: Loading.eager,
          interactionPrompt: InteractionPrompt.none,
        ),
      ),
    );
  }
}

// Widget que simula um modelo 3D usando a imagem com efeitos avançados
class Enhanced3DViewer extends StatefulWidget {
  final RatEvolution evolution;
  final double size;
  final bool enableRotation;
  final bool autoRotate;

  const Enhanced3DViewer({
    super.key,
    required this.evolution,
    this.size = 200,
    this.enableRotation = true,
    this.autoRotate = true,
  });

  @override
  State<Enhanced3DViewer> createState() => _Enhanced3DViewerState();
}

class _Enhanced3DViewerState extends State<Enhanced3DViewer>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  double _userRotation = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _scaleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    if (widget.autoRotate) {
      _rotationController.repeat();
    }

    _scaleController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: RadialGradient(
          colors: [Colors.grey[200]!, Colors.grey[300]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onPanStart: widget.enableRotation
              ? (details) {
                  _isDragging = true;
                  if (widget.autoRotate) {
                    _rotationController.stop();
                  }
                }
              : null,
          onPanUpdate: widget.enableRotation
              ? (details) {
                  setState(() {
                    _userRotation += details.delta.dx * 0.01;
                  });
                }
              : null,
          onPanEnd: widget.enableRotation
              ? (details) {
                  _isDragging = false;
                  if (widget.autoRotate) {
                    _rotationController.repeat();
                  }
                }
              : null,
          child: AnimatedBuilder(
            animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
            builder: (context, child) {
              double rotation = _isDragging
                  ? _userRotation
                  : (widget.autoRotate
                        ? _rotationAnimation.value + _userRotation
                        : _userRotation);

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotation)
                  ..scale(_scaleAnimation.value),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('assets/models/minha_textura.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(math.sin(rotation) * 5, 0),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Widget alternativo para casos onde model_viewer_plus não funciona
class Fallback3DViewer extends StatefulWidget {
  final RatEvolution evolution;
  final double size;

  const Fallback3DViewer({super.key, required this.evolution, this.size = 200});

  @override
  State<Fallback3DViewer> createState() => _Fallback3DViewerState();
}

class _Fallback3DViewerState extends State<Fallback3DViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: RadialGradient(
          colors: [
            widget.evolution.color.withValues(alpha: 0.3),
            widget.evolution.color.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_rotationAnimation.value)
              ..rotateX(0.2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(widget.evolution.imagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.evolution.color.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
