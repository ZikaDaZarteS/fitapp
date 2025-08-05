import 'package:flutter/material.dart';
import '../models/workout.dart' as model_workout;
import '../models/workout_plan.dart';
import '../screens/workout_detail_screen.dart' as screen_workout_detail;
import '../screens/exercise_management_screen.dart';
import '../db/database_helper.dart';
import '../db/firestore_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  final firestoreHelper = FirestoreHelper();

  List<WorkoutPlan> workoutPlans = [];
  List<model_workout.Workout> workouts = [];
  String searchTerm = '';
  String? selectedCategory;
  final categories = ['Todos', 'Força', 'Cardio', 'Flexibilidade'];

  @override
  void initState() {
    super.initState();
    loadWorkoutPlans();
    syncWorkouts();
  }

  Future<void> syncWorkouts() async {
    // Baixar do Firestore e sincronizar localmente
    firestoreHelper.getWorkouts().listen((cloudWorkouts) async {
      for (var workout in cloudWorkouts) {
        await dbHelper.insertWorkout(workout); // insere ou ignora duplicatas
      }
      if (mounted) loadWorkouts();
    });
  }

  Future<void> loadWorkoutPlans() async {
    try {
      final loaded = await dbHelper.getWorkoutPlans();
      debugPrint('📋 WorkoutPlans carregados: ${loaded.length}');
      for (var plan in loaded) {
        debugPrint('  - ${plan.dayOfWeek}: ${plan.workoutTypes.join(', ')}');
      }
      if (!mounted) return;
      setState(() {
        workoutPlans = loaded;
      });
    } catch (e) {
      debugPrint('❌ Erro ao carregar WorkoutPlans: $e');
    }
  }

  Future<void> loadWorkouts() async {
    final loaded = await dbHelper.getWorkouts();
    if (!mounted) return;
    setState(() {
      workouts = loaded;
    });
  }

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

  Future<void> deleteWorkout(model_workout.Workout workout) async {
    if (workout.id != null) await dbHelper.deleteWorkout(workout.id!);
    if (workout.firestoreId != null) {
      await firestoreHelper.deleteWorkout(workout.firestoreId!);
    }
    await loadWorkouts();
  }

  void showDeleteConfirmation(model_workout.Workout workout) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir o treino "${workout.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteWorkout(workout);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Treino "${workout.title}" deletado')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditWorkoutDialog(WorkoutPlan plan) {
    final List<String> workoutTypes = List.from(plan.workoutTypes);
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
        return AlertDialog(
          title: Text('Editar Treinos para ${plan.dayOfWeek}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableTypes.map((type) {
                final isSelected = workoutTypes.contains(type);
                return CheckboxListTile(
                  title: Text(type),
                  value: isSelected,
                  onChanged: (bool? newValue) {
                    setState(() {
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
                // Atualizar o plano no banco de dados
                if (plan.id != null) {
                  dbHelper.updateWorkoutPlan(plan.id!, workoutTypes);
                  if (mounted) loadWorkoutPlans();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const screen_workout_detail.WorkoutDetailScreen(
                    workout: null,
                  ),
                ),
              );
              if (result is model_workout.Workout) {
                await firestoreHelper.addWorkout(result);
                await dbHelper.insertWorkout(result);
                if (mounted) loadWorkouts();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadWorkoutPlans,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: workoutPlans.length,
          itemBuilder: (context, index) {
            final plan = workoutPlans[index];
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
                          _getWorkoutIcon(plan.workoutTypes.first),
                          color: Colors.black,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          plan.dayOfWeek,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExerciseManagementScreen(workoutPlan: plan),
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
                      children: plan.workoutTypes.map((type) {
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
                    if (plan.notes != null && plan.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        plan.notes!,
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
      ),
    );
  }
}
