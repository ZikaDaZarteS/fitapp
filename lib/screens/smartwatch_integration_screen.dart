import 'package:flutter/material.dart';
import 'package:health/health.dart';

class SmartwatchIntegrationScreen extends StatefulWidget {
  const SmartwatchIntegrationScreen({super.key});

  @override
  State<SmartwatchIntegrationScreen> createState() =>
      _SmartwatchIntegrationScreenState();
}

class _SmartwatchIntegrationScreenState
    extends State<SmartwatchIntegrationScreen> {
  bool _authorized = false;
  int _steps = 0;
  double _heartRate = 0;
  bool _loading = false;

  final HealthFactory _health = HealthFactory();

  Future<void> _connect() async {
    setState(() => _loading = true);
    final types = [HealthDataType.STEPS, HealthDataType.HEART_RATE];
    final permissions = [HealthDataAccess.READ, HealthDataAccess.READ];
    bool? authorized = await _health.requestAuthorization(
      types,
      permissions: permissions,
    );
    if (authorized == true) {
      await _fetchData();
    }
    setState(() {
      _authorized = authorized;
      _loading = false;
    });
  }

  Future<void> _fetchData() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    int steps = 0;
    double heartRate = 0;
    try {
      final stepsData = await _health.getHealthDataFromTypes(midnight, now, [
        HealthDataType.STEPS,
      ]);
      if (stepsData.isNotEmpty) {
        steps = stepsData.map((e) => e.value as int).fold(0, (a, b) => a + b);
      }
      final hrData = await _health.getHealthDataFromTypes(midnight, now, [
        HealthDataType.HEART_RATE,
      ]);
      if (hrData.isNotEmpty) {
        heartRate =
            hrData
                .map((e) => (e.value as num).toDouble())
                .fold(0.0, (a, b) => a + b) /
            hrData.length;
      }
    } catch (e) {
      // ignore
    }
    setState(() {
      _steps = steps;
      _heartRate = heartRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Integração com Smartwatch')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.watch,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                _authorized
                    ? 'Conectado ao Google Fit/Apple Health'
                    : 'Não conectado',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              if (_authorized) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Passos hoje:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '$_steps',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Batimentos médios:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              _heartRate > 0
                                  ? _heartRate.toStringAsFixed(1)
                                  : '-',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: Icon(_authorized ? Icons.link_off : Icons.link),
                      label: Text(_authorized ? 'Desconectar' : 'Conectar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _authorized
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _authorized
                          ? () => setState(() => _authorized = false)
                          : _connect,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
