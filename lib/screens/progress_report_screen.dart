import 'package:flutter/material.dart';
import 'package:fitapp/db/database_helper.dart';
import 'package:fitapp/models/checkin.dart';
import 'package:intl/intl.dart';
import 'dart:io'; // Added for File

class ProgressReportScreen extends StatefulWidget {
  const ProgressReportScreen({super.key});

  @override
  State<ProgressReportScreen> createState() => _ProgressReportScreenState();
}

class _ProgressReportScreenState extends State<ProgressReportScreen> {
  final db = DatabaseHelper();
  List<Checkin> _checkins = [];
  List<Map<String, dynamic>> _stats = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Para exemplo, pega o primeiro usuário
    final user = await db.getUser();
    if (user == null) {
      setState(() => _loading = false);
      return;
    }
    final checkins = await db.getCheckins(user.id ?? '');
    final stats = await db.getCheckinStats();
    setState(() {
      _checkins = checkins;
      _stats = stats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios de Progresso')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _checkins.isEmpty
          ? const Center(child: Text('Nenhum check-in encontrado.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummary(),
                  const SizedBox(height: 24),
                  _buildChart(),
                  const SizedBox(height: 24),
                  const Text(
                    'Últimos Check-ins',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._checkins.take(10).map(_buildCheckinTile),
                ],
              ),
            ),
    );
  }

  Widget _buildSummary() {
    final total = _checkins.length;
    final last = _checkins.isNotEmpty ? _checkins.first.timestamp : null;
    final days = _stats.length;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('Check-ins', total.toString()),
            _buildSummaryItem('Dias ativos', days.toString()),
            _buildSummaryItem(
              'Último',
              last != null ? DateFormat('dd/MM').format(last) : '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildChart() {
    // Gráfico simples de barras usando Container (pode trocar por charts_flutter)
    if (_stats.isEmpty) return const SizedBox();
    final max = _stats
        .map((e) => e['count'] as int)
        .fold(0, (a, b) => a > b ? a : b);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequência (últimos 30 dias)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _stats.reversed.map((e) {
                  final count = e['count'] as int;
                  final date = e['date'] as String;
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: max > 0 ? 80 * (count / max) : 0,
                          width: 8,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd').format(DateTime.parse(date)),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckinTile(Checkin c) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: c.imagePath != null
            ? Image.file(
                File(c.imagePath!),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.fitness_center, size: 32),
        title: Text(DateFormat('dd/MM/yyyy – HH:mm').format(c.timestamp)),
        subtitle: Text(c.note),
      ),
    );
  }
}
