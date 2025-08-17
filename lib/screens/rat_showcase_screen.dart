import 'package:flutter/material.dart';
import '../models/rat_evolution.dart';
import '../widgets/model_3d_viewer.dart';

class RatShowcaseScreen extends StatefulWidget {
  final RatEvolution evolution;

  const RatShowcaseScreen({super.key, required this.evolution});

  @override
  State<RatShowcaseScreen> createState() => _RatShowcaseScreenState();
}

class _RatShowcaseScreenState extends State<RatShowcaseScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  bool _isAnimating = true;
  double _ratSize = 300;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.evolution.color.withValues(alpha: 0.1),
                  Colors.black,
                  widget.evolution.color.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, _backgroundAnimation.value, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Área principal do rato
                  Expanded(child: _buildRatArea()),

                  // Controles
                  _buildControls(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.evolution.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.evolution.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isAnimating = !_isAnimating;
              });
            },
            icon: Icon(
              _isAnimating ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatArea() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Model 3D sem o círculo branco
          SizedBox(
            width: _ratSize,
            height: _ratSize,
            child: Model3DViewer(
              evolution: widget.evolution,
              size: _ratSize,
              enableRotation: true,
              enableZoom: true,
              autoRotate: _isAnimating,
            ),
          ),

          const SizedBox(height: 40),

          // Informações do estágio
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.evolution.color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Características do ${widget.evolution.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCharacteristic('Força', _getStrengthLevel()),
                _buildCharacteristic('Resistência', _getResistanceLevel()),
                _buildCharacteristic('Velocidade', _getSpeedLevel()),
                _buildCharacteristic('Inteligência', _getIntelligenceLevel()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacteristic(String name, double level) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: level,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.evolution.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(level * 100).toInt()}%',
            style: TextStyle(
              color: widget.evolution.color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  double _getStrengthLevel() {
    switch (widget.evolution.stage) {
      case RatStage.baby:
        return 0.2;
      case RatStage.young:
        return 0.4;
      case RatStage.adult:
        return 0.6;
      case RatStage.warrior:
        return 0.8;
      case RatStage.champion:
        return 0.9;
      case RatStage.legend:
        return 0.95;
      case RatStage.god:
        return 1.0;
    }
  }

  double _getResistanceLevel() {
    switch (widget.evolution.stage) {
      case RatStage.baby:
        return 0.1;
      case RatStage.young:
        return 0.3;
      case RatStage.adult:
        return 0.5;
      case RatStage.warrior:
        return 0.7;
      case RatStage.champion:
        return 0.85;
      case RatStage.legend:
        return 0.95;
      case RatStage.god:
        return 1.0;
    }
  }

  double _getSpeedLevel() {
    switch (widget.evolution.stage) {
      case RatStage.baby:
        return 0.3;
      case RatStage.young:
        return 0.5;
      case RatStage.adult:
        return 0.7;
      case RatStage.warrior:
        return 0.8;
      case RatStage.champion:
        return 0.9;
      case RatStage.legend:
        return 0.95;
      case RatStage.god:
        return 1.0;
    }
  }

  double _getIntelligenceLevel() {
    switch (widget.evolution.stage) {
      case RatStage.baby:
        return 0.1;
      case RatStage.young:
        return 0.2;
      case RatStage.adult:
        return 0.4;
      case RatStage.warrior:
        return 0.6;
      case RatStage.champion:
        return 0.8;
      case RatStage.legend:
        return 0.9;
      case RatStage.god:
        return 1.0;
    }
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Controle de tamanho
          Row(
            children: [
              const Text(
                'Tamanho:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: _ratSize,
                  min: 150,
                  max: 400,
                  divisions: 10,
                  activeColor: widget.evolution.color,
                  inactiveColor: Colors.grey.withValues(alpha: 0.3),
                  onChanged: (value) {
                    setState(() {
                      _ratSize = value;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Botões de ação
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton('Girar', Icons.rotate_right, () {
                // Ação de girar
              }),
              _buildActionButton('Pular', Icons.keyboard_arrow_up, () {
                // Ação de pular
              }),
              _buildActionButton('Especial', Icons.star, () {
                // Ação especial
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: widget.evolution.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: widget.evolution.color, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: widget.evolution.color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: widget.evolution.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
