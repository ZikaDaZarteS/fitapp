import 'package:flutter/material.dart';
import '../models/rat_evolution.dart';
import 'rat_showcase_screen.dart';

class RatEvolutionScreen extends StatefulWidget {
  const RatEvolutionScreen({super.key});

  @override
  State<RatEvolutionScreen> createState() => _RatEvolutionScreenState();
}

class _RatEvolutionScreenState extends State<RatEvolutionScreen>
    with TickerProviderStateMixin {
  final int _userPoints = 450; // Pontos simulados do usuário
  late RatEvolution _currentEvolution;

  // Controllers para animações de evolução
  late AnimationController _evolutionController;
  late AnimationController _glowController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;

  // Animações
  late Animation<double> _evolutionAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  bool _isEvolving = false;

  @override
  void initState() {
    super.initState();
    _currentEvolution = RatEvolution.getEvolutionStage(_userPoints);

    // Inicializar controllers de animação
    _evolutionController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Configurar animações
    _evolutionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _evolutionController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // Listener para reiniciar animações
    _evolutionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isEvolving = false;
        });
        _glowController.reverse();
        _scaleController.reverse();
        _rotationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _evolutionController.dispose();
    _glowController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _triggerEvolutionAnimation() {
    setState(() {
      _isEvolving = true;
    });

    _evolutionController.forward();
    _glowController.forward();
    _scaleController.forward();
    _rotationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Evolução do Rato',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header com o rato atual
            _buildCurrentRatCard(),

            const SizedBox(height: 30),

            // Progresso da evolução
            _buildEvolutionProgress(),

            const SizedBox(height: 30),

            // Próximos estágios
            _buildNextStages(),

            const SizedBox(height: 30),

            // Estatísticas
            _buildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentRatCard() {
    return AnimatedBuilder(
      animation: _evolutionAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _currentEvolution.color.withValues(
                  alpha: 0.1 + (_glowAnimation.value * 0.2),
                ),
                _currentEvolution.color.withValues(
                  alpha: 0.05 + (_glowAnimation.value * 0.15),
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _currentEvolution.color.withValues(
                alpha: 0.3 + (_glowAnimation.value * 0.7),
              ),
              width: 2 + (_glowAnimation.value * 3),
            ),
            boxShadow: _isEvolving
                ? [
                    BoxShadow(
                      color: _currentEvolution.color.withValues(
                        alpha: 0.3 + (_glowAnimation.value * 0.7),
                      ),
                      spreadRadius: 5 + (_glowAnimation.value * 10),
                      blurRadius: 20 + (_glowAnimation.value * 30),
                      offset: const Offset(0, 0),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              // Imagem do Rato na Evolução
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 0.1,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.asset(
                        _currentEvolution.imagePath,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: const Icon(
                              Icons.error,
                              color: Colors.grey,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nome do estágio com animação
              AnimatedBuilder(
                animation: _evolutionAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_evolutionAnimation.value * 0.1),
                    child: Text(
                      _currentEvolution.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _currentEvolution.color,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // Descrição
              Text(
                _currentEvolution.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Pontos atuais
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _currentEvolution.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_userPoints pontos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão para ver em tela cheia
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RatShowcaseScreen(evolution: _currentEvolution),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _currentEvolution.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: _currentEvolution.color,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fullscreen,
                        color: _currentEvolution.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ver em 3D',
                        style: TextStyle(
                          color: _currentEvolution.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão de animação de evolução
              if (!_isEvolving)
                GestureDetector(
                  onTap: _triggerEvolutionAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _currentEvolution.color,
                          _currentEvolution.color.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: _currentEvolution.color.withValues(alpha: 0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Animar Evolução',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEvolutionProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: _currentEvolution.color, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Progresso da Evolução',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Barra de progresso
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_currentEvolution.getCurrentPointsInStage(_userPoints)} / ${_currentEvolution.getPointsToNextStage()}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '${(_currentEvolution.evolutionProgress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _currentEvolution.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _currentEvolution.evolutionProgress,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _currentEvolution.color,
                ),
                minHeight: 8,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Próximo estágio
          Row(
            children: [
              Icon(
                Icons.arrow_forward,
                color: _currentEvolution.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Próximo: ${_currentEvolution.getNextStageName()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _currentEvolution.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextStages() {
    const List<RatStage> allStages = RatStage.values;
    final int currentIndex = allStages.indexOf(_currentEvolution.stage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jornada de Evolução',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allStages.length,
            itemBuilder: (context, index) {
              final stage = allStages[index];
              final evolution = RatEvolution.getEvolutionStage(
                _getMinPointsForStage(stage),
              );
              final isCompleted = index <= currentIndex;
              final isCurrent = index == currentIndex;

              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? evolution.color.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isCurrent
                              ? evolution.color
                              : Colors.grey.withValues(alpha: 0.3),
                          width: isCurrent ? 3 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          evolution.imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.error,
                                color: Colors.grey,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      evolution.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? Colors.black87 : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estatísticas do Rato',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Ranking Global',
                  '#1,247',
                  Icons.leaderboard,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  'Grupos Ativos',
                  '3',
                  Icons.group,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Dias Consecutivos',
                  '15',
                  Icons.calendar_today,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  'Check-ins',
                  '127',
                  Icons.fitness_center,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int _getMinPointsForStage(RatStage stage) {
    switch (stage) {
      case RatStage.baby:
        return 0;
      case RatStage.young:
        return 100;
      case RatStage.adult:
        return 300;
      case RatStage.warrior:
        return 600;
      case RatStage.champion:
        return 1000;
      case RatStage.legend:
        return 1500;
      case RatStage.god:
        return 2500;
    }
  }
}
