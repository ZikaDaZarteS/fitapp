import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutScreen({super.key, required this.workout});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final dbHelper = DatabaseHelper();
  List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<void> refreshList() async {
    exercises = await dbHelper.getExercises(widget.workout.id!);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> addExercise() async {
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController setsCtrl = TextEditingController();
    TextEditingController repsCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Novo Exercício'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: setsCtrl,
              decoration: const InputDecoration(labelText: 'Séries'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: repsCtrl,
              decoration: const InputDecoration(labelText: 'Repetições'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                await dbHelper.insertExercise(
                  Exercise(
                    name: nameCtrl.text,
                    muscleGroup: 'Geral',
                    description: 'Exercício personalizado',
                    instructions: 'Execute conforme orientação do instrutor',
                    sets: int.tryParse(setsCtrl.text) ?? 0,
                    reps: int.tryParse(repsCtrl.text) ?? 0,
                  ),
                );
                await refreshList();
              }
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> editExercise(Exercise exercise) async {
    TextEditingController nameCtrl = TextEditingController(text: exercise.name);
    TextEditingController setsCtrl = TextEditingController(
      text: exercise.sets.toString(),
    );
    TextEditingController repsCtrl = TextEditingController(
      text: exercise.reps.toString(),
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Exercício'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: setsCtrl,
              decoration: const InputDecoration(labelText: 'Séries'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: repsCtrl,
              decoration: const InputDecoration(labelText: 'Repetições'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                await dbHelper.updateExercise(
                  Exercise(
                    id: exercise.id,
                    name: nameCtrl.text,
                    muscleGroup: exercise.muscleGroup,
                    description: exercise.description,
                    instructions: exercise.instructions,
                    sets: int.tryParse(setsCtrl.text) ?? 0,
                    reps: int.tryParse(repsCtrl.text) ?? 0,
                  ),
                );
                await refreshList();
              }
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteExercise(int id) async {
    await dbHelper.deleteExercise(id);
    await refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.workout.title)),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (_, index) {
          var ex = exercises[index];
          return ListTile(
            title: Text('${ex.name} (${ex.sets}x${ex.reps})'),
            onTap: () => editExercise(ex),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteExercise(ex.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}
