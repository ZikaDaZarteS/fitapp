import 'package:flutter/material.dart';
import '../models/rat_evolution.dart';
import '../widgets/enhanced_3d_viewer.dart';

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
                  _buildHeader(),
                  Expanded(child: _buildRatArea()),
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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Enhanced3DViewer(
                    evolution: widget.evolution,
                    size: MediaQuery.of(context).size.width - 40,
                    enableRotation: true,
                    enableZoom: true,
                    autoRotate: _isAnimating,
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: widget.evolution.color.withValues(
                        alpha: 0.8,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FullScreen3DViewer(
                                  evolution: widget.evolution,
                                ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoBox(),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
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
    return const SizedBox.shrink(); // Remove completamente os controles
  }
}

// Novo widget para fullscreen
class FullScreen3DViewer extends StatelessWidget {
  final RatEvolution evolution;

  const FullScreen3DViewer({super.key, required this.evolution});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: Enhanced3DViewer(
              evolution: evolution,
              size:
                  screenSize.width > screenSize.height
                      ? screenSize.width
                      : screenSize.height,
              enableRotation: true,
              enableZoom: true,
              autoRotate: true,
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
