import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:fitapp/db/database_helper.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _rankingData = [];

  @override
  void initState() {
    super.initState();
    _loadRankingData();
  }

  Future<void> _loadRankingData() async {
    try {
      // Simular dados de ranking para web
      if (kIsWeb) {
        _rankingData = [
          {'name': 'João Silva', 'checkins': 15, 'position': 1},
          {'name': 'Maria Santos', 'checkins': 12, 'position': 2},
          {'name': 'Pedro Costa', 'checkins': 10, 'position': 3},
          {'name': 'Ana Oliveira', 'checkins': 8, 'position': 4},
          {'name': 'Carlos Lima', 'checkins': 6, 'position': 5},
        ];
      } else {
        // Buscar dados reais do banco
        final users = await _dbHelper.getUsers();
        final rankingData = <Map<String, dynamic>>[];

        for (int i = 0; i < users.length; i++) {
          final user = users[i];
          final checkinCount = await _dbHelper.getCheckinCount(
            user.id?.toString() ?? 'unknown',
          );
          rankingData.add({
            'name': user.name,
            'checkins': checkinCount,
            'position': i + 1,
          });
        }

        rankingData.sort(
          (a, b) => (b['checkins'] as int).compareTo(a['checkins'] as int),
        );
        for (int i = 0; i < rankingData.length; i++) {
          rankingData[i]['position'] = i + 1;
        }

        _rankingData = rankingData;
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar ranking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Ranking'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header do ranking
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 48),
                SizedBox(height: 8),
                Text(
                  'Ranking de Check-ins',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Top 5 Usuários',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Lista do ranking
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _rankingData.length,
              itemBuilder: (context, index) {
                final user = _rankingData[index];
                final position = user['position'] as int;
                final name = user['name'] as String;
                final checkins = user['checkins'] as int;

                Color medalColor;
                IconData medalIcon;

                switch (position) {
                  case 1:
                    medalColor = Colors.amber;
                    medalIcon = Icons.looks_one;
                    break;
                  case 2:
                    medalColor = Colors.grey;
                    medalIcon = Icons.looks_two;
                    break;
                  case 3:
                    medalColor = Colors.brown;
                    medalIcon = Icons.looks_3;
                    break;
                  default:
                    medalColor = Colors.grey.shade400;
                    medalIcon = Icons.circle;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: medalColor,
                      child: Icon(medalIcon, color: Colors.white),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '$checkins check-ins',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#$position',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
