import 'package:flutter/material.dart';
import '../models/checkin.dart';
import '../models/rat_evolution.dart';
import '../widgets/dashboard_rat_section.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_navigation_card.dart';
import '../widgets/cycling_options_modal.dart';
import '../widgets/running_options_modal.dart';
import 'clubs_screen.dart';
import 'scoring_mode_screen.dart';
import 'rat_evolution_screen.dart';
import 'checkin_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  int _totalCheckins = 0;
  final int _userPoints = 450; // Pontos simulados do usuário
  late RatEvolution _currentEvolution;

  @override
  void initState() {
    super.initState();
    _currentEvolution = RatEvolution.getEvolutionStage(_userPoints);
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulando dados para demonstração
      final checkins = <Checkin>[];
      final totalCheckins = checkins.length;

      setState(() {
        _totalCheckins = totalCheckins;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _calculateActiveDays() {
    // Simulação de dias ativos
    return 15;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF667eea)),
            )
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Seção do Rato Atual
                    DashboardRatSection(
                      currentEvolution: _currentEvolution,
                      userPoints: _userPoints,
                    ),

                    const SizedBox(height: 30),

                    // Cards de estatísticas
                    Row(
                      children: [
                        Expanded(
                          child: DashboardStatCard(
                            title: 'Check-ins',
                            value: '$_totalCheckins',
                            icon: Icons.fitness_center,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DashboardStatCard(
                            title: 'Dias Ativos',
                            value: '${_calculateActiveDays()}',
                            icon: Icons.calendar_today,
                            color: const Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Botão de Check-in
                    _buildCheckinButton(),

                    const SizedBox(height: 30),

                    // Navegação Rápida
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Navegação Rápida',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children: [
                        DashboardNavigationCard(
                          title: 'Check-in',
                          description: 'Registre seu treino',
                          icon: Icons.fitness_center,
                          color: const Color(0xFF4CAF50),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckinScreen(),
                            ),
                          ),
                        ),
                        DashboardNavigationCard(
                          title: 'Clubes',
                          description: 'Explore a comunidade',
                          icon: Icons.group,
                          color: const Color(0xFF2196F3),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ClubsScreen(),
                            ),
                          ),
                        ),
                        DashboardNavigationCard(
                          title: 'Ciclismo',
                          description: 'Recursos para bike',
                          icon: Icons.directions_bike,
                          color: const Color(0xFF00BCD4),
                          onTap: () => CyclingOptionsModal.show(context),
                        ),
                        DashboardNavigationCard(
                          title: 'Corrida',
                          description: 'Recursos para corrida',
                          icon: Icons.directions_run,
                          color: const Color(0xFFE91E63),
                          onTap: () => RunningOptionsModal.show(context),
                        ),
                        DashboardNavigationCard(
                          title: 'Criar',
                          description: 'Grupo ou Desafio',
                          icon: Icons.add_circle,
                          color: const Color(0xFFFF9800),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ScoringModeScreen(),
                            ),
                          ),
                        ),
                        DashboardNavigationCard(
                          title: 'Evolução',
                          description: 'Veja seu rato',
                          icon: Icons.psychology,
                          color: const Color(0xFF9C27B0),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RatEvolutionScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }





  Widget _buildCheckinButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _performCheckin();
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Fazer Check-in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void _performCheckin() async {
    try {
      // Simulando inserção para demonstração
      await _loadDashboardData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Check-in realizado com sucesso! 🎉'),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao realizar check-in'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }








}
