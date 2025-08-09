import 'package:flutter/material.dart';

class HomeScreenStatic extends StatefulWidget {
  const HomeScreenStatic({super.key});

  @override
  State<HomeScreenStatic> createState() => _HomeScreenStaticState();
}

class _HomeScreenStaticState extends State<HomeScreenStatic> {
  // Dados estáticos para teste
  final List<Map<String, dynamic>> workoutPlans = [
    {
      'dayOfWeek': 'Segunda-feira',
      'workoutTypes': ['Peito', 'Tríceps'],
      'notes': 'Treino de empurrar'
    },
    {
      'dayOfWeek': 'Terça-feira',
      'workoutTypes': ['Costas', 'Bíceps'],
      'notes': 'Treino de puxar'
    },
    {
      'dayOfWeek': 'Quarta-feira',
      'workoutTypes': ['Perna'],
      'notes': 'Treino de pernas'
    },
    {
      'dayOfWeek': 'Quinta-feira',
      'workoutTypes': ['Ombro', 'Abdômen'],
      'notes': 'Treino de ombros'
    },
    {
      'dayOfWeek': 'Sexta-feira',
      'workoutTypes': ['Peito', 'Tríceps'],
      'notes': 'Treino de empurrar'
    },
    {
      'dayOfWeek': 'Sábado',
      'workoutTypes': ['Costas', 'Bíceps'],
      'notes': 'Treino de puxar'
    },
    {
      'dayOfWeek': 'Domingo',
      'workoutTypes': ['Descanso'],
      'notes': 'Dia de descanso'
    },
  ];

  IconData _getWorkoutIcon(String workoutType) {
    switch (workoutType.toLowerCase()) {
      case 'peito':
        return Icons.fitness_center;
      case 'costas':
        return Icons.accessibility_new;
      case 'bíceps':
        return Icons.fitness_center;
      case 'tríceps':
        return Icons.fitness_center;
      case 'perna':
        return Icons.directions_run;
      case 'ombro':
        return Icons.accessibility_new;
      case 'abdômen':
        return Icons.fitness_center;
      case 'descanso':
        return Icons.bedtime;
      default:
        return Icons.fitness_center;
    }
  }

  void _showEditWorkoutDialog(Map<String, dynamic> plan) {
    final List<String> workoutTypes = List<String>.from(plan['workoutTypes']);
    final List<String> availableTypes = [
      'Peito',
      'Costas',
      'Bíceps',
      'Tríceps',
      'Perna',
      'Ombro',
      'Abdômen',
      'Descanso',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Editar Treinos para ${plan['dayOfWeek']}'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: availableTypes.map((type) {
                    final isSelected = workoutTypes.contains(type);
                    return CheckboxListTile(
                      title: Text(type),
                      value: isSelected,
                      onChanged: (bool? newValue) {
                        setDialogState(() {
                          if (newValue!) {
                            workoutTypes.add(type);
                          } else {
                            workoutTypes.remove(type);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Atualizar os dados localmente
                    setState(() {
                      plan['workoutTypes'] = workoutTypes;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Treino atualizado!')),
                    );
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'MEUS TREINOS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: workoutPlans.length,
        itemBuilder: (context, index) {
          final plan = workoutPlans[index];
          final workoutTypes = List<String>.from(plan['workoutTypes']);
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getWorkoutIcon(workoutTypes.first),
                        color: Colors.black,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        plan['dayOfWeek'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.fitness_center,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Abrir exercícios para ${plan['dayOfWeek']}'),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: () {
                          _showEditWorkoutDialog(plan);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: workoutTypes.map((type) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (plan['notes'] != null && plan['notes']!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      plan['notes']!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}