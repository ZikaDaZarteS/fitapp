import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseDetailsDialog extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailsDialog({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(exercise.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Grupo Muscular: ${exercise.muscleGroup}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Descrição: ${exercise.description}'),
            const SizedBox(height: 16),
            Text(
              'Instruções:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(exercise.instructions),
            const SizedBox(height: 16),
            if (exercise.sets != null ||
                exercise.reps != null ||
                exercise.restTime != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuração:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  if (exercise.sets != null) Text('Séries: ${exercise.sets}'),
                  if (exercise.reps != null)
                    Text('Repetições: ${exercise.reps}'),
                  if (exercise.restTime != null)
                    Text('Descanso: ${exercise.restTime}s'),
                ],
              ),
            if (exercise.equipment != null) ...[
              const SizedBox(height: 16),
              Text(
                'Equipamento: ${exercise.equipment}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Dificuldade: ${exercise.difficulty}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
