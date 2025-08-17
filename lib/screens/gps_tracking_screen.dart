import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GPSTrackingScreen extends StatefulWidget {
  final String activity;
  
  const GPSTrackingScreen({super.key, required this.activity});

  @override
  State<GPSTrackingScreen> createState() => _GPSTrackingScreenState();
}

class _GPSTrackingScreenState extends State<GPSTrackingScreen> {
  bool _isTracking = false;
  double _distance = 0.0;
  double _speed = 0.0;
  String _duration = '00:00:00';
  late Stopwatch _stopwatch;
  late Timer _timer;
  final List<Map<String, double>> _routePoints = [];
  double _currentLat = -23.5505;
  double _currentLng = -46.6333;
  String _currentStreet = 'Av. Paulista';
  String _currentNeighborhood = 'Bela Vista';
  final List<String> _streets = [
    'Av. Paulista',
    'Rua Augusta',
    'Rua Oscar Freire',
    'Av. Faria Lima',
    'Rua da Consolação',
    'Av. Rebouças',
    'Rua Haddock Lobo',
    'Av. Brigadeiro Luís Antônio'
  ];
  final List<String> _neighborhoods = [
    'Bela Vista',
    'Jardins',
    'Consolação',
    'Itaim Bibi',
    'Vila Madalena',
    'Pinheiros'
  ];
  
  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTracking);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTracking(Timer timer) {
    if (_isTracking) {
      setState(() {
        // Simular movimento GPS
        _currentLat += (Random().nextDouble() - 0.5) * 0.001;
        _currentLng += (Random().nextDouble() - 0.5) * 0.001;
        
        // Simular mudança de rua ocasionalmente
        if (Random().nextInt(10) == 0) {
          _currentStreet = _streets[Random().nextInt(_streets.length)];
        }
        if (Random().nextInt(15) == 0) {
          _currentNeighborhood = _neighborhoods[Random().nextInt(_neighborhoods.length)];
        }
        
        _routePoints.add({
          'lat': _currentLat,
          'lng': _currentLng,
        });
        
        // Simular distância e velocidade
        _distance += Random().nextDouble() * 0.05; // km
        _speed = widget.activity == 'Ciclismo' 
            ? 15 + Random().nextDouble() * 10 // 15-25 km/h
            : 8 + Random().nextDouble() * 4;  // 8-12 km/h
        
        _duration = _formatDuration(_stopwatch.elapsed);
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _startStopTracking() {
    setState(() {
      if (_isTracking) {
        _stopwatch.stop();
        _isTracking = false;
      } else {
        _stopwatch.start();
        _isTracking = true;
        if (_routePoints.isEmpty) {
          _routePoints.add({
            'lat': _currentLat,
            'lng': _currentLng,
          });
        }
      }
    });
  }

  void _resetTracking() {
    setState(() {
      _stopwatch.reset();
      _isTracking = false;
      _distance = 0.0;
      _speed = 0.0;
      _duration = '00:00:00';
      _routePoints.clear();
      _currentLat = -23.5505;
      _currentLng = -46.6333;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color activityColor = widget.activity == 'Ciclismo' 
        ? const Color(0xFF00BCD4) 
        : const Color(0xFFE91E63);
    
    IconData activityIcon = widget.activity == 'Ciclismo' 
        ? Icons.directions_bike 
        : Icons.directions_run;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('GPS Tracking - ${widget.activity}'),
        backgroundColor: activityColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Centralizando no local atual 📍'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Mapa simulado
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    // Fundo do mapa
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.green[100]!,
                            Colors.green[200]!,
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: MapPainter(_routePoints, activityColor),
                        size: Size.infinite,
                      ),
                    ),
                    
                    // Indicador de posição atual
                    if (_isTracking)
                      Positioned(
                        top: 50,
                        right: 50,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: activityColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.gps_fixed,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Rastreando',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    
                    // Informações de localização atual
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on, color: activityColor, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Localização Atual',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentStreet,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _currentNeighborhood,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lat: ${_currentLat.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text(
                              'Lng: ${_currentLng.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Overlay com informações
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.straighten, color: activityColor),
                                Text(
                                  '${_distance.toStringAsFixed(2)} km',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Distância', style: TextStyle(fontSize: 10)),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.speed, color: activityColor),
                                Text(
                                  '${_speed.toStringAsFixed(1)} km/h',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Velocidade', style: TextStyle(fontSize: 10)),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer, color: activityColor),
                                Text(
                                  _duration,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Tempo', style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Estatísticas detalhadas
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(activityIcon, color: activityColor, size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sessão de ${widget.activity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isTracking ? 'Em andamento' : 'Pausado',
                        style: TextStyle(
                          color: _isTracking ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_routePoints.length > 1)
                        Text(
                          '${_routePoints.length} pontos registrados',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Botões de controle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetTracking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text('Reset'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _startStopTracking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTracking ? Colors.red : activityColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isTracking ? Icons.pause : Icons.play_arrow),
                        const SizedBox(width: 8),
                        Text(_isTracking ? 'Pausar Tracking' : 'Iniciar Tracking'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final List<Map<String, double>> routePoints;
  final Color routeColor;
  
  MapPainter(this.routePoints, this.routeColor);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar grid do mapa
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    
    for (int i = 0; i <= 10; i++) {
      double x = (size.width / 10) * i;
      double y = (size.height / 10) * i;
      
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    
    // Desenhar rota
    if (routePoints.length > 1) {
      final routePaint = Paint()
        ..color = routeColor
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      
      final path = Path();
      
      for (int i = 0; i < routePoints.length; i++) {
        double x = (i / routePoints.length) * size.width;
        double y = size.height * 0.3 + (sin(i * 0.1) * 50) + (cos(i * 0.05) * 30);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      canvas.drawPath(path, routePaint);
      
      // Desenhar ponto atual
      if (routePoints.isNotEmpty) {
        double currentX = ((routePoints.length - 1) / routePoints.length) * size.width;
        double currentY = size.height * 0.3 + (sin((routePoints.length - 1) * 0.1) * 50) + (cos((routePoints.length - 1) * 0.05) * 30);
        
        final currentPointPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        
        final currentPointBorderPaint = Paint()
          ..color = routeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        
        canvas.drawCircle(Offset(currentX, currentY), 8, currentPointPaint);
        canvas.drawCircle(Offset(currentX, currentY), 8, currentPointBorderPaint);
      }
    }
    
    // Desenhar pontos de interesse simulados
    final poiPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 4, poiPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 4, poiPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.8), 4, poiPaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}