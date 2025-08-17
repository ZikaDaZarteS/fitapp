import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaceCalculatorScreen extends StatefulWidget {
  const PaceCalculatorScreen({super.key});

  @override
  State<PaceCalculatorScreen> createState() => _PaceCalculatorScreenState();
}

class _PaceCalculatorScreenState extends State<PaceCalculatorScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  
  String _paceResult = '--:--';
  String _speedResult = '0.0';
  String _projectedTimes = '';
  
  @override
  void dispose() {
    _distanceController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _calculatePace() {
    try {
      double distance = double.parse(_distanceController.text.isEmpty ? '0' : _distanceController.text);
      int hours = int.parse(_hoursController.text.isEmpty ? '0' : _hoursController.text);
      int minutes = int.parse(_minutesController.text.isEmpty ? '0' : _minutesController.text);
      int seconds = int.parse(_secondsController.text.isEmpty ? '0' : _secondsController.text);
      
      if (distance <= 0) {
        setState(() {
          _paceResult = '--:--';
          _speedResult = '0.0';
          _projectedTimes = '';
        });
        return;
      }
      
      int totalSeconds = hours * 3600 + minutes * 60 + seconds;
      
      if (totalSeconds <= 0) {
        setState(() {
          _paceResult = '--:--';
          _speedResult = '0.0';
          _projectedTimes = '';
        });
        return;
      }
      
      // Calcular pace (tempo por km)
      double paceInSeconds = totalSeconds / distance;
      int paceMinutes = (paceInSeconds / 60).floor();
      int paceSeconds = (paceInSeconds % 60).round();
      
      // Calcular velocidade (km/h)
      double speed = distance / (totalSeconds / 3600);
      
      setState(() {
        _paceResult = '${paceMinutes.toString().padLeft(2, '0')}:${paceSeconds.toString().padLeft(2, '0')}';
        _speedResult = speed.toStringAsFixed(1);
        _projectedTimes = _calculateProjectedTimes(paceInSeconds);
      });
      
    } catch (e) {
      setState(() {
        _paceResult = '--:--';
        _speedResult = '0.0';
        _projectedTimes = '';
      });
    }
  }
  
  String _calculateProjectedTimes(double paceInSeconds) {
    List<double> distances = [1, 5, 10, 21.0975, 42.195]; // 1km, 5km, 10km, meia maratona, maratona
    List<String> labels = ['1km', '5km', '10km', 'Meia Maratona', 'Maratona'];
    
    List<String> projections = [];
    
    for (int i = 0; i < distances.length; i++) {
      double totalTime = distances[i] * paceInSeconds;
      int hours = (totalTime / 3600).floor();
      int minutes = ((totalTime % 3600) / 60).floor();
      int seconds = (totalTime % 60).round();
      
      String timeStr;
      if (hours > 0) {
        timeStr = '${hours}h${minutes.toString().padLeft(2, '0')}m${seconds.toString().padLeft(2, '0')}s';
      } else {
        timeStr = '${minutes}m${seconds.toString().padLeft(2, '0')}s';
      }
      
      projections.add('${labels[i]}: $timeStr');
    }
    
    return projections.join('\n');
  }
  
  void _clearAll() {
    setState(() {
      _distanceController.clear();
      _hoursController.clear();
      _minutesController.clear();
      _secondsController.clear();
      _paceResult = '--:--';
      _speedResult = '0.0';
      _projectedTimes = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color runningColor = Color(0xFFE91E63);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Calculadora de Pace'),
        backgroundColor: runningColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearAll,
            tooltip: 'Limpar tudo',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: runningColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Calculadora de Pace',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Calcule seu ritmo de corrida',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Entrada de dados
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.straighten, color: runningColor),
                      SizedBox(width: 8),
                      Text(
                        'Distância Percorrida',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _distanceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Ex: 5.0',
                      suffixText: 'km',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: runningColor),
                      ),
                    ),
                    onChanged: (_) => _calculatePace(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  const Row(
                    children: [
                      Icon(Icons.timer, color: runningColor),
                      SizedBox(width: 8),
                      Text(
                        'Tempo Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _hoursController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: InputDecoration(
                            hintText: '0',
                            suffixText: 'h',
                            border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                             ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: runningColor),
                            ),
                          ),
                          onChanged: (_) => _calculatePace(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _minutesController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: InputDecoration(
                            hintText: '0',
                            suffixText: 'min',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: runningColor),
                            ),
                          ),
                          onChanged: (_) => _calculatePace(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _secondsController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          decoration: InputDecoration(
                            hintText: '0',
                            suffixText: 'seg',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: runningColor),
                            ),
                          ),
                          onChanged: (_) => _calculatePace(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Resultados
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                     children: [
                       Icon(Icons.analytics, color: runningColor),
                       SizedBox(width: 8),
                       Text(
                         'Resultados',
                         style: TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   ),
                  const SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: runningColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.speed, color: runningColor, size: 30),
                              const SizedBox(height: 8),
                              Text(
                                _paceResult,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: runningColor,
                                ),
                              ),
                              const Text(
                                 'min/km',
                                 style: TextStyle(
                                   fontSize: 12,
                                   color: Colors.grey,
                                 ),
                               ),
                               const Text(
                                 'Pace',
                                 style: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w500,
                                 ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.trending_up, color: Colors.orange, size: 30),
                              const SizedBox(height: 8),
                              Text(
                                _speedResult,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const Text(
                                'km/h',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text(
                                'Velocidade',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Projeções
            if (_projectedTimes.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                       children: [
                         Icon(Icons.flag, color: runningColor),
                         SizedBox(width: 8),
                         Text(
                           'Tempos Projetados',
                           style: TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                    const SizedBox(height: 16),
                    Text(
                      _projectedTimes,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}