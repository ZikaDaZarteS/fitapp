import 'package:flutter/material.dart';
import '../models/exercise.dart';

class AddExerciseDialog extends StatelessWidget {
  final List<String> workoutTypes;
  final Map<String, List<Exercise>> predefinedExercises;
  final Function(Exercise) onAddExercise;

  const AddExerciseDialog({
    super.key,
    required this.workoutTypes,
    required this.predefinedExercises,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Exercício'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: workoutTypes.length,
          itemBuilder: (context, index) {
            final muscleGroup = workoutTypes[index];
            final exercisesForGroup = predefinedExercises[muscleGroup] ?? [];

            return ExpansionTile(
              title: Text(muscleGroup),
              children: exercisesForGroup.map((exercise) {
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(exercise.description),
                  trailing: const Icon(Icons.add),
                  onTap: () {
                    Navigator.pop(context);
                    onAddExercise(exercise);
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
