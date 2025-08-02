import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/rat_evolution.dart';

class AnimatedRat3D extends StatefulWidget {
  final RatEvolution evolution;
  final double size;
  final bool isAnimating;

  const AnimatedRat3D({
    super.key,
    required this.evolution,
    this.size = 200,
    this.isAnimating = true,
  });

  @override
  State<AnimatedRat3D> createState() => _AnimatedRat3DState();
}

class _AnimatedRat3DState extends State<AnimatedRat3D>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late AnimationController _breathingController;
  late AnimationController _muscleController;
  late AnimationController _tailController;
  late AnimationController _poseController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _muscleAnimation;
  late Animation<double> _tailAnimation;
  late Animation<double> _poseAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador de rotação 3D
    _rotationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    // Controlador de pulo/bounce
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Controlador de respiração
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    // Controlador de músculos
    _muscleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Controlador da cauda
    _tailController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Controlador de pose
    _poseController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    // Animações
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _breathingAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _muscleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _muscleController, curve: Curves.easeInOut),
    );

    _tailAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _tailController, curve: Curves.easeInOut),
    );

    _poseAnimation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _poseController, curve: Curves.easeInOut),
    );

    if (widget.isAnimating) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _rotationController.repeat();
    _bounceController.repeat(reverse: true);
    _breathingController.repeat(reverse: true);
    _muscleController.repeat(reverse: true);
    _tailController.repeat(reverse: true);
    _poseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    _breathingController.dispose();
    _muscleController.dispose();
    _tailController.dispose();
    _poseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationAnimation,
        _bounceAnimation,
        _breathingAnimation,
        _muscleAnimation,
        _tailAnimation,
        _poseAnimation,
      ]),
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspectiva
            ..rotateY(_rotationAnimation.value)
            ..translate(0, -_bounceAnimation.value * 3, 0),
          alignment: Alignment.center,
          child: _buildAnatomicallyCorrectRat(),
        );
      },
    );
  }

  Widget _buildAnatomicallyCorrectRat() {
    return SizedBox(
      width: widget.size,
      height: widget.size * 2.5, // Proporção humana realista
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Corpo principal com anatomia correta
          _buildAnatomicallyCorrectBody(),

          // Cabeça de rato anatomicamente correta
          _buildAnatomicallyCorrectHead(),

          // Braços com músculos realistas
          _buildAnatomicallyCorrectArms(),

          // Pernas com músculos realistas
          _buildAnatomicallyCorrectLegs(),

          // Cauda realista
          _buildRealisticTail(),

          // Detalhes da evolução
          _buildEvolutionDetails(),
        ],
      ),
    );
  }

  Widget _buildAnatomicallyCorrectBody() {
    return Transform.scale(
      scale: _breathingAnimation.value,
      child: Positioned(
        top: widget.size * 0.45,
        child: Container(
          width: widget.size * 0.65,
          height: widget.size * 1.4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getSkinColor(),
                _getSkinColor().withValues(alpha: 0.95),
                _getSkinColor().withValues(alpha: 0.9),
                _getSkinColor().withValues(alpha: 0.85),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(widget.size * 0.325),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                spreadRadius: 4,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Peitorais anatomicamente corretos
              _buildAnatomicallyCorrectPectorals(),

              // Abdômen com definição realista
              _buildAnatomicallyCorrectAbs(),

              // Ombros anatomicamente corretos
              _buildAnatomicallyCorrectShoulders(),

              // Costas com músculos
              _buildAnatomicallyCorrectBack(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnatomicallyCorrectPectorals() {
    return Positioned(
      top: widget.size * 0.18,
      left: widget.size * 0.1,
      right: widget.size * 0.1,
      child: Container(
        height: widget.size * 0.4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getSkinColor().withValues(alpha: 0.98),
              _getSkinColor().withValues(alpha: 0.92),
              _getSkinColor().withValues(alpha: 0.88),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(widget.size * 0.18),
        ),
        child: Row(
          children: [
            // Peitoral esquerdo
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getSkinColor().withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(widget.size * 0.15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Detalhes musculares do peitoral
                    Positioned(
                      top: widget.size * 0.05,
                      left: widget.size * 0.02,
                      right: widget.size * 0.02,
                      child: Container(
                        height: widget.size * 0.08,
                        decoration: BoxDecoration(
                          color: _getSkinColor().withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(
                            widget.size * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Divisão central
            Container(
              width: 4,
              height: widget.size * 0.35,
              decoration: BoxDecoration(
                color: _getSkinColor().withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Peitoral direito
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getSkinColor().withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(widget.size * 0.15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Detalhes musculares do peitoral
                    Positioned(
                      top: widget.size * 0.05,
                      left: widget.size * 0.02,
                      right: widget.size * 0.02,
                      child: Container(
                        height: widget.size * 0.08,
                        decoration: BoxDecoration(
                          color: _getSkinColor().withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(
                            widget.size * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnatomicallyCorrectAbs() {
    return Positioned(
      top: widget.size * 0.62,
      left: widget.size * 0.15,
      right: widget.size * 0.15,
      child: Column(
        children: [
          // Linha 1
          _buildAbRowRealistic(),
          const SizedBox(height: 4),
          // Linha 2
          _buildAbRowRealistic(),
          const SizedBox(height: 4),
          // Linha 3
          _buildAbRowRealistic(),
          const SizedBox(height: 4),
          // Linha 4
          _buildAbRowRealistic(),
          const SizedBox(height: 4),
          // Linha 5
          _buildAbRowRealistic(),
          const SizedBox(height: 4),
          // Linha 6
          _buildAbRowRealistic(),
          const SizedBox(height: 4),
          // Linha 7
          _buildAbRowRealistic(),
          const SizedBox(height: 4),
          // Linha 8
          _buildAbRowRealistic(),
        ],
      ),
    );
  }

  Widget _buildAbRowRealistic() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: _getSkinColor().withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: _getSkinColor().withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: _getSkinColor().withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: _getSkinColor().withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnatomicallyCorrectShoulders() {
    return Positioned(
      top: widget.size * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Ombro esquerdo
          Transform.scale(
            scale: _muscleAnimation.value,
            child: Container(
              width: widget.size * 0.2,
              height: widget.size * 0.18,
              decoration: BoxDecoration(
                color: _getSkinColor().withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(widget.size * 0.09),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: widget.size * 0.25),
          // Ombro direito
          Transform.scale(
            scale: _muscleAnimation.value,
            child: Container(
              width: widget.size * 0.2,
              height: widget.size * 0.18,
              decoration: BoxDecoration(
                color: _getSkinColor().withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(widget.size * 0.09),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnatomicallyCorrectBack() {
    return Positioned(
      top: widget.size * 0.25,
      left: widget.size * 0.05,
      right: widget.size * 0.05,
      child: Container(
        height: widget.size * 0.6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getSkinColor().withValues(alpha: 0.9),
              _getSkinColor().withValues(alpha: 0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(widget.size * 0.3),
        ),
      ),
    );
  }

  Widget _buildAnatomicallyCorrectHead() {
    return Positioned(
      top: widget.size * 0.1,
      child: Container(
        width: widget.size * 0.45,
        height: widget.size * 0.35,
        decoration: BoxDecoration(
          color: _getSkinColor().withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(widget.size * 0.175),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Orelhas anatomicamente corretas
            _buildAnatomicallyCorrectEars(),

            // Olhos anatomicamente corretos
            _buildAnatomicallyCorrectEyes(),

            // Nariz anatomicamente correto
            _buildAnatomicallyCorrectNose(),

            // Boca anatomicamente correta
            _buildAnatomicallyCorrectMouth(),

            // Bigodes anatomicamente corretos
            _buildAnatomicallyCorrectWhiskers(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnatomicallyCorrectEars() {
    return Positioned(
      top: widget.size * 0.02,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Orelha esquerda
          Transform.rotate(
            angle: -0.5,
            child: Container(
              width: widget.size * 0.12,
              height: widget.size * 0.15,
              decoration: BoxDecoration(
                color: _getSkinColor().withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(widget.size * 0.06),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.pink.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(widget.size * 0.05),
                ),
              ),
            ),
          ),
          SizedBox(width: widget.size * 0.21),
          // Orelha direita
          Transform.rotate(
            angle: 0.5,
            child: Container(
              width: widget.size * 0.12,
              height: widget.size * 0.15,
              decoration: BoxDecoration(
                color: _getSkinColor().withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(widget.size * 0.06),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.pink.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(widget.size * 0.05),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnatomicallyCorrectEyes() {
    return Positioned(
      top: widget.size * 0.12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Olho esquerdo
          Container(
            width: widget.size * 0.1,
            height: widget.size * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.size * 0.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: widget.size * 0.05,
                height: widget.size * 0.05,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(widget.size * 0.025),
                ),
              ),
            ),
          ),
          SizedBox(width: widget.size * 0.15),
          // Olho direito
          Container(
            width: widget.size * 0.1,
            height: widget.size * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.size * 0.05),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: widget.size * 0.05,
                height: widget.size * 0.05,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(widget.size * 0.025),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnatomicallyCorrectNose() {
    return Positioned(
      top: widget.size * 0.22,
      left: widget.size * 0.175,
      child: Container(
        width: widget.size * 0.06,
        height: widget.size * 0.05,
        decoration: BoxDecoration(
          color: Colors.pink.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(widget.size * 0.025),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnatomicallyCorrectMouth() {
    return Positioned(
      top: widget.size * 0.26,
      left: widget.size * 0.15,
      child: Container(
        width: widget.size * 0.15,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildAnatomicallyCorrectWhiskers() {
    return Positioned(
      top: widget.size * 0.18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Bigodes esquerdos
          Column(
            children: [
              Container(
                width: widget.size * 0.12,
                height: 2,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Container(
                width: widget.size * 0.1,
                height: 2,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Container(
                width: widget.size * 0.08,
                height: 2,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Container(
                width: widget.size * 0.06,
                height: 2,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ],
          ),
          SizedBox(width: widget.size * 0.31),
          // Bigodes direitos
          Column(
            children: [
              Container(
                width: widget.size * 0.12,
                height: 2,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Container(
                width: widget.size * 0.1,
                height: 2,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Container(
                width: widget.size * 0.08,
                height: 2,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 4),
              Container(
                width: widget.size * 0.06,
                height: 2,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnatomicallyCorrectArms() {
    return Positioned(
      top: widget.size * 0.55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Braço esquerdo
          Transform.rotate(
            angle: _poseAnimation.value,
            child: Container(
              width: widget.size * 0.18,
              height: widget.size * 0.75,
              decoration: BoxDecoration(
                color: _getSkinColor().withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(widget.size * 0.09),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Bíceps
                  Container(
                    width: widget.size * 0.18,
                    height: widget.size * 0.25,
                    decoration: BoxDecoration(
                      color: _getSkinColor().withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(widget.size * 0.125),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  // Antebraço
                  Container(
                    width: widget.size * 0.15,
                    height: widget.size * 0.5,
                    decoration: BoxDecoration(
                      color: _getSkinColor().withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(widget.size * 0.075),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: widget.size * 0.29),
          // Braço direito
          Transform.rotate(
            angle: -_poseAnimation.value,
            child: Container(
              width: widget.size * 0.18,
              height: widget.size * 0.75,
              decoration: BoxDecoration(
                color: _getSkinColor().withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(widget.size * 0.09),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Bíceps
                  Container(
                    width: widget.size * 0.18,
                    height: widget.size * 0.25,
                    decoration: BoxDecoration(
                      color: _getSkinColor().withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(widget.size * 0.125),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  // Antebraço
                  Container(
                    width: widget.size * 0.15,
                    height: widget.size * 0.5,
                    decoration: BoxDecoration(
                      color: _getSkinColor().withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(widget.size * 0.075),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnatomicallyCorrectLegs() {
    return Positioned(
      bottom: widget.size * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Perna esquerda
          Container(
            width: widget.size * 0.22,
            height: widget.size * 0.85,
            decoration: BoxDecoration(
              color: _getSkinColor().withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(widget.size * 0.11),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Coxa
                Container(
                  width: widget.size * 0.22,
                  height: widget.size * 0.4,
                  decoration: BoxDecoration(
                    color: _getSkinColor().withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(widget.size * 0.11),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                // Panturrilha
                Container(
                  width: widget.size * 0.18,
                  height: widget.size * 0.45,
                  decoration: BoxDecoration(
                    color: _getSkinColor().withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(widget.size * 0.09),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: widget.size * 0.26),
          // Perna direita
          Container(
            width: widget.size * 0.22,
            height: widget.size * 0.85,
            decoration: BoxDecoration(
              color: _getSkinColor().withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(widget.size * 0.11),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Coxa
                Container(
                  width: widget.size * 0.22,
                  height: widget.size * 0.4,
                  decoration: BoxDecoration(
                    color: _getSkinColor().withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(widget.size * 0.11),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                // Panturrilha
                Container(
                  width: widget.size * 0.18,
                  height: widget.size * 0.45,
                  decoration: BoxDecoration(
                    color: _getSkinColor().withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(widget.size * 0.09),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealisticTail() {
    return Positioned(
      bottom: widget.size * 0.5,
      right: widget.size * 0.1,
      child: Transform.rotate(
        angle: _tailAnimation.value,
        child: Container(
          width: widget.size * 0.45,
          height: widget.size * 0.05,
          decoration: BoxDecoration(
            color: _getSkinColor().withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(widget.size * 0.025),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvolutionDetails() {
    // Adiciona detalhes específicos baseados no estágio de evolução
    switch (widget.evolution.stage) {
      case RatStage.baby:
        return _buildBabyDetails();
      case RatStage.young:
        return _buildYoungDetails();
      case RatStage.adult:
        return _buildAdultDetails();
      case RatStage.warrior:
        return _buildWarriorDetails();
      case RatStage.champion:
        return _buildChampionDetails();
      case RatStage.legend:
        return _buildLegendDetails();
      case RatStage.god:
        return _buildGodDetails();
    }
  }

  Widget _buildBabyDetails() {
    return Positioned(
      top: widget.size * 0.9,
      child: Container(
        width: widget.size * 0.14,
        height: widget.size * 0.14,
        decoration: BoxDecoration(
          color: Colors.yellow.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.child_care, color: Colors.orange, size: 28),
      ),
    );
  }

  Widget _buildYoungDetails() {
    return Positioned(
      top: widget.size * 0.9,
      child: Container(
        width: widget.size * 0.16,
        height: widget.size * 0.16,
        decoration: BoxDecoration(
          color: Colors.brown.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.sports_gymnastics,
          color: Colors.brown,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildAdultDetails() {
    return Positioned(
      top: widget.size * 0.9,
      child: Container(
        width: widget.size * 0.18,
        height: widget.size * 0.18,
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.fitness_center, color: Colors.blue, size: 36),
      ),
    );
  }

  Widget _buildWarriorDetails() {
    return Positioned(
      top: widget.size * 0.9,
      child: Container(
        width: widget.size * 0.2,
        height: widget.size * 0.2,
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.sports_martial_arts,
          color: Colors.orange,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildChampionDetails() {
    return Positioned(
      top: widget.size * 0.9,
      child: Container(
        width: widget.size * 0.22,
        height: widget.size * 0.22,
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.emoji_events, color: Colors.purple, size: 44),
      ),
    );
  }

  Widget _buildLegendDetails() {
    return Positioned(
      top: widget.size * 0.9,
      child: Container(
        width: widget.size * 0.24,
        height: widget.size * 0.24,
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.auto_awesome, color: Colors.amber, size: 48),
      ),
    );
  }

  Widget _buildGodDetails() {
    return Positioned(
      top: widget.size * 0.9,
      child: Container(
        width: widget.size * 0.26,
        height: widget.size * 0.26,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.psychology, color: Colors.red, size: 52),
      ),
    );
  }

  Color _getSkinColor() {
    // Cor da pele baseada no estágio de evolução
    switch (widget.evolution.stage) {
      case RatStage.baby:
        return Colors.grey.shade300;
      case RatStage.young:
        return Colors.grey.shade400;
      case RatStage.adult:
        return Colors.grey.shade500;
      case RatStage.warrior:
        return Colors.grey.shade600;
      case RatStage.champion:
        return Colors.grey.shade700;
      case RatStage.legend:
        return Colors.grey.shade800;
      case RatStage.god:
        return Colors.grey.shade900;
    }
  }
}
