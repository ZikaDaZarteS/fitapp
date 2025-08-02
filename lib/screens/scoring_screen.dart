import 'package:flutter/material.dart';

class ScoringScreen extends StatefulWidget {
  final String challengeName;
  final bool isChallenge;

  const ScoringScreen({
    super.key,
    required this.challengeName,
    required this.isChallenge,
  });

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  String _selectedScoringMode = 'pontos';

  final List<Map<String, dynamic>> _scoringModes = [
    {
      'id': 'pontos',
      'title': 'Sistema de Pontos',
      'description':
          'Ganhe pontos baseado na intensidade e duração dos treinos',
      'icon': Icons.stars,
      'color': Colors.orange,
    },
    {
      'id': 'calorias',
      'title': 'Calorias Queimadas',
      'description': 'Competição baseada no total de calorias queimadas',
      'icon': Icons.local_fire_department,
      'color': Colors.red,
    },
    {
      'id': 'tempo',
      'title': 'Tempo de Treino',
      'description': 'Competição baseada no tempo total de exercícios',
      'icon': Icons.timer,
      'color': Colors.blue,
    },
    {
      'id': 'frequencia',
      'title': 'Frequência',
      'description': 'Competição baseada na consistência dos treinos',
      'icon': Icons.calendar_today,
      'color': Colors.green,
    },
  ];

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
          'Sistema de Pontuação',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.1),
                    Colors.purple.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.isChallenge ? 'Desafio' : 'Grupo'}: ${widget.challengeName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Escolha como os participantes serão pontuados',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Modos de pontuação
            const Text(
              'Modos de Pontuação',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ..._scoringModes.map((mode) => _buildScoringModeCard(mode)),

            const SizedBox(height: 30),

            // Botão de confirmar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmScoringMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirmar Sistema de Pontuação',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoringModeCard(Map<String, dynamic> mode) {
    final isSelected = _selectedScoringMode == mode['id'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedScoringMode = mode['id'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? mode['color']
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? mode['color'].withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              spreadRadius: isSelected ? 2 : 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mode['color'].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(mode['icon'], color: mode['color'], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? mode['color'] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mode['description'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: mode['color'], size: 24),
          ],
        ),
      ),
    );
  }

  void _confirmScoringMode() {
    // Simular configuração do sistema de pontuação
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sistema de pontuação configurado para ${widget.challengeName}!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Voltar para o dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
