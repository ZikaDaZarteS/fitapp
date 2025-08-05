import 'package:flutter/material.dart';
import '../controllers/exercise_controller.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_details_dialog.dart';
import '../widgets/edit_exercise_dialog.dart';
import '../widgets/add_exercise_dialog.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';

class ExerciseManagementScreen extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  const ExerciseManagementScreen({super.key, required this.workoutPlan});

  @override
  State<ExerciseManagementScreen> createState() =>
      _ExerciseManagementScreenState();
}

class _ExerciseManagementScreenState extends State<ExerciseManagementScreen> with WidgetsBindingObserver {
  final ExerciseController _exerciseController = ExerciseController();
  List<Exercise> exercises = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadExercises();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadExercises();
    }
  }

  Future<void> loadExercises() async {
    try {
      setState(() {
        isLoading = true;
      });

      final loadedExercises = await _exerciseController.loadExercises(
        widget.workoutPlan,
      );

      setState(() {
        exercises = loadedExercises;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Erro ao carregar exercícios: $e');
      setState(() {
        exercises = [];
        isLoading = false;
      });
    }
  }

  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExerciseDialog(
          workoutTypes: widget.workoutPlan.workoutTypes,
          predefinedExercises: _exerciseController.predefinedExercises,
          onAddExercise: _addExerciseToWorkout,
        );
      },
    );
  }

  Future<void> _addExerciseToWorkout(Exercise exercise) async {
    await _exerciseController.addExerciseToWorkout(
      widget.workoutPlan,
      exercise,
      context,
    );
    await loadExercises();
  }

  Future<void> _removeExerciseFromWorkout(Exercise exercise) async {
    await _exerciseController.removeExerciseFromWorkout(
      widget.workoutPlan,
      exercise,
      context,
    );
    await loadExercises();
  }

  void _editExerciseSets(Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditExerciseDialog(
          title: 'Editar Séries - ${exercise.name}',
          label: 'Número de Séries',
          hint: 'Ex: 3',
          initialValue: exercise.sets?.toString() ?? '',
          onSave: (newSets) async {
            await _exerciseController.updateExerciseSets(exercise, newSets, context);
            await loadExercises();
          },
        );
      },
    );
  }

  void _editExerciseReps(Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditExerciseDialog(
          title: 'Editar Repetições - ${exercise.name}',
          label: 'Número de Repetições',
          hint: 'Ex: 12',
          initialValue: exercise.reps?.toString() ?? '',
          onSave: (newReps) async {
            await _exerciseController.updateExerciseReps(exercise, newReps, context);
            await loadExercises();
          },
        );
      },
    );
  }

  void _showExerciseDetails(Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExerciseDetailsDialog(exercise: exercise);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios - ${widget.workoutPlan.dayOfWeek}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddExerciseDialog,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : exercises.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum exercício adicionado',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toque no + para adicionar exercícios',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ExerciseCard(
                  exercise: exercise,
                  onEditSets: () => _editExerciseSets(exercise),
                  onEditReps: () => _editExerciseReps(exercise),
                  onShowDetails: () => _showExerciseDetails(exercise),
                  onRemove: () => _removeExerciseFromWorkout(exercise),
                );
              },
            ),
    );
  }
}
