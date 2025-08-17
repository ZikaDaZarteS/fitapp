import 'package:flutter/material.dart';
import '../screens/stopwatch_screen.dart';
import '../screens/gps_tracking_screen.dart';
import '../screens/pace_calculator_screen.dart';

class RunningOptionsModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_run,
                          color: Color(0xFFE91E63),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recursos para Corrida',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Ferramentas para corredores e caminhantes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildOptionCard(
                        context,
                        'Cronômetro',
                        'Tempo de corrida',
                        Icons.timer,
                        const Color(0xFF4CAF50),
                        () => _startStopwatch(context),
                      ),
                      _buildOptionCard(
                        context,
                        'Mapa GPS',
                        'Rastreie seu percurso',
                        Icons.map,
                        const Color(0xFF2196F3),
                        () => _showGPSTracking(context),
                      ),
                      _buildOptionCard(
                        context,
                        'Pace',
                        'Ritmo por km',
                        Icons.trending_up,
                        const Color(0xFFFF9800),
                        () => _showPaceCalculator(context),
                      ),
                      _buildOptionCard(
                        context,
                        'Intervalos',
                        'Treino intervalado',
                        Icons.repeat,
                        const Color(0xFF9C27B0),
                        () => _showIntervalTraining(context),
                      ),
                      _buildOptionCard(
                        context,
                        'Calorias',
                        'Gasto energético',
                        Icons.local_fire_department,
                        const Color(0xFFFF5722),
                        () => _showCalorieTracker(context),
                      ),
                      _buildOptionCard(
                        context,
                        'Metas',
                        'Objetivos de treino',
                        Icons.flag,
                        const Color(0xFF607D8B),
                        () => _showRunningGoals(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildOptionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _startStopwatch(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StopwatchScreen(activity: 'Corrida')),
    );
  }

  static void _showGPSTracking(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GPSTrackingScreen(activity: 'Corrida')),
    );
  }

  static void _showPaceCalculator(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaceCalculatorScreen()),
    );
  }

  static void _showIntervalTraining(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treino intervalado iniciado! 🔁'),
        backgroundColor: Color(0xFF9C27B0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _showCalorieTracker(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contador de calorias ativo! 🔥'),
        backgroundColor: Color(0xFFFF5722),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _showRunningGoals(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Metas de corrida configuradas! 🎯'),
        backgroundColor: Color(0xFF607D8B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}