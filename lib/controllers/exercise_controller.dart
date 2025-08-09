import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../db/database_helper.dart';
import '../data/predefined_exercises.dart';

class ExerciseController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Lista de exercícios pré-definidos organizados por grupo muscular
  Map<String, List<Exercise>> get predefinedExercises {
    final Map<String, List<Exercise>> exercisesByGroup = {};

    // Organizar exercícios por grupo muscular
    for (final exercise in PredefinedExercises.exercises) {
      if (!exercisesByGroup.containsKey(exercise.muscleGroup)) {
        exercisesByGroup[exercise.muscleGroup] = [];
      }
      exercisesByGroup[exercise.muscleGroup]!.add(exercise);
    }

    return exercisesByGroup;
  }

  Future<List<Exercise>> loadExercises(WorkoutPlan workoutPlan) async {
    try {
      // Carregar exercícios do banco de dados para este plano de treino
      if (workoutPlan.id == null) {
        debugPrint('❌ ID do plano de treino é nulo');
        return [];
      }
      final exercises = await _dbHelper.getExercisesForWorkoutPlan(
        workoutPlan.id!,
      );
      return exercises;
    } catch (e) {
      debugPrint('❌ Erro ao carregar exercícios: $e');
      return [];
    }
  }

  Future<void> addExerciseToWorkout(
    WorkoutPlan workoutPlan,
    Exercise exercise,
    BuildContext context,
  ) async {
    try {
      // Adicionar exercício ao plano de treino
      if (workoutPlan.id == null) {
        throw Exception('ID do plano de treino é nulo');
      }
      await _dbHelper.addExerciseToWorkoutPlan(workoutPlan.id!, exercise);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercício adicionado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erro ao adicionar exercício: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar exercício: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> removeExerciseFromWorkout(
    WorkoutPlan workoutPlan,
    Exercise exercise,
    BuildContext context,
  ) async {
    try {
      // Remover exercício do plano de treino
      if (workoutPlan.id == null || exercise.id == null) {
        throw Exception('ID do plano de treino ou exercício é nulo');
      }
      await _dbHelper.removeExerciseFromWorkoutPlan(
        workoutPlan.id!,
        exercise.id!,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercício removido com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erro ao remover exercício: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao remover exercício: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> updateExerciseSets(
    Exercise exercise,
    int newSets,
    BuildContext context,
  ) async {
    try {
      if (newSets <= 0) {
        throw Exception('Número de séries inválido');
      }

      final updatedExercise = Exercise(
        id: exercise.id,
        name: exercise.name,
        description: exercise.description,
        muscleGroup: exercise.muscleGroup,
        difficulty: exercise.difficulty,
        equipment: exercise.equipment,
        instructions: exercise.instructions,
        imageUrl: exercise.imageUrl,
        sets: newSets,
        reps: exercise.reps,
        restTime: exercise.restTime,
      );

      await _dbHelper.updateExercise(updatedExercise);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Séries atualizadas com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erro ao atualizar séries: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar séries: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> updateExerciseReps(
    Exercise exercise,
    int newReps,
    BuildContext context,
  ) async {
    try {
      if (newReps <= 0) {
        throw Exception('Número de repetições inválido');
      }

      final updatedExercise = Exercise(
        id: exercise.id,
        name: exercise.name,
        description: exercise.description,
        muscleGroup: exercise.muscleGroup,
        difficulty: exercise.difficulty,
        equipment: exercise.equipment,
        instructions: exercise.instructions,
        imageUrl: exercise.imageUrl,
        sets: exercise.sets,
        reps: newReps,
        restTime: exercise.restTime,
      );

      await _dbHelper.updateExercise(updatedExercise);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Repetições atualizadas com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erro ao atualizar repetições: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar repetições: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
