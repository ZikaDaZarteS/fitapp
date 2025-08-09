import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/exercise.dart';

class ExerciseOperations {
  // Armazenamento temporário para exercícios no modo web
  static final Map<int, List<Exercise>> _webExercises = {};

  // Exercise CRUD
  static Future<List<Exercise>> getExercisesForWorkoutPlan(Database db, int workoutPlanId) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - carregando exercícios do armazenamento temporário');
      
      // Carregar exercícios do SharedPreferences
      await _loadExercisesFromStorage();
      
      debugPrint('📋 Buscando exercícios para WorkoutPlan ID: $workoutPlanId');
      debugPrint('🗂️ Exercícios disponíveis: ${_webExercises.keys.toList()}');
      
      for (var key in _webExercises.keys) {
        debugPrint('  - WorkoutPlan $key: ${_webExercises[key]?.length ?? 0} exercícios');
      }
      
      // Se não existem exercícios para este plano, retorna lista vazia
      if (!_webExercises.containsKey(workoutPlanId)) {
        debugPrint('📋 Nenhum exercício encontrado para WorkoutPlan ID: $workoutPlanId');
        return [];
      }
      
      final exercises = _webExercises[workoutPlanId] ?? [];
      debugPrint('✅ Exercícios encontrados: ${exercises.length}');
      for (var exercise in exercises) {
        debugPrint('  - ${exercise.name}');
      }
      return exercises;
    }

    try {
      debugPrint('🔄 Buscando exercícios para WorkoutPlan ID: $workoutPlanId');

      // Verificar se a tabela existe
      final tables = await db.query(
        'sqlite_master',
        where: 'type = ? AND name = ?',
        whereArgs: ['table', 'exercises'],
      );
      if (tables.isEmpty) {
        debugPrint('❌ Tabela exercises não existe');
        return [];
      }

      debugPrint('✅ Tabela exercises encontrada');

      final List<Map<String, dynamic>> maps = await db.query(
        'exercises',
        where: 'workoutPlanId = ?',
        whereArgs: [workoutPlanId],
      );

      debugPrint('📊 Exercícios encontrados: ${maps.length}');
      for (var map in maps) {
        debugPrint('  - ${map['name']} (ID: ${map['id']})');
      }

      final exercises = List.generate(
        maps.length,
        (i) => Exercise.fromMap(maps[i]),
      );
      debugPrint('✅ Exercícios convertidos: ${exercises.length}');

      return exercises;
    } catch (e) {
      debugPrint('❌ Erro ao buscar exercícios: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  static Future<int> addExerciseToWorkoutPlan(Database db, int workoutPlanId, Exercise exercise) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - adicionando exercício ao armazenamento temporário');

      // Carregar exercícios existentes primeiro
      await _loadExercisesFromStorage();

      // Inicializa a lista se não existir
      if (!_webExercises.containsKey(workoutPlanId)) {
        _webExercises[workoutPlanId] = [];
      }

      // Gerar um ID único para o exercício se não tiver
      int newId;
      if (exercise.id != null) {
        newId = exercise.id!;
        // Verificar se o ID já existe neste plano específico
        while (_webExercises[workoutPlanId]!.any((e) => e.id == newId)) {
          newId = DateTime.now().millisecondsSinceEpoch + (newId % 1000);
        }
      } else {
        // Gerar um novo ID baseado no timestamp + um número aleatório
        newId = DateTime.now().millisecondsSinceEpoch;
        // Verificar se o ID já existe em qualquer plano
        bool idExists = false;
        do {
          idExists = false;
          for (var planExercises in _webExercises.values) {
            if (planExercises.any((e) => e.id == newId)) {
              idExists = true;
              newId = DateTime.now().millisecondsSinceEpoch + (newId % 10000);
              break;
            }
          }
        } while (idExists);
      }

      // Criar uma cópia do exercício com o ID único
      final exerciseWithId = exercise.copyWith(id: newId);

      // Adiciona o exercício à lista
      _webExercises[workoutPlanId]!.add(exerciseWithId);

      debugPrint('✅ Exercício "${exerciseWithId.name}" adicionado ao WorkoutPlan ID: $workoutPlanId com ID: $newId');
      debugPrint('📊 Total de exercícios no plano: ${_webExercises[workoutPlanId]!.length}');

      // Salvar no SharedPreferences
      await _saveExercisesToStorage();

      return newId;
    }

    try {
      debugPrint('🔄 Adicionando exercício ao banco de dados');
      debugPrint('📋 WorkoutPlan ID: $workoutPlanId');
      debugPrint('💪 Exercise: ${exercise.name}');

      final exerciseMap = exercise.toMap();
      exerciseMap['workoutPlanId'] = workoutPlanId;

      debugPrint('📝 Exercise Map: $exerciseMap');

      final result = await db.insert('exercises', exerciseMap);
      debugPrint('✅ Exercício inserido com ID: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Erro ao adicionar exercício: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
      return 0;
    }
  }

  static Future<int> removeExerciseFromWorkoutPlan(Database db, int workoutPlanId, int exerciseId) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - removendo exercício do armazenamento temporário');

      if (_webExercises.containsKey(workoutPlanId)) {
        _webExercises[workoutPlanId]!.removeWhere((exercise) => exercise.id == exerciseId);
        debugPrint('✅ Exercício removido do WorkoutPlan ID: $workoutPlanId');
        
        // Salvar no SharedPreferences
        await _saveExercisesToStorage();
      }

      return 1;
    }

    try {
      debugPrint('🔄 Removendo exercício do banco de dados');
      debugPrint('📋 WorkoutPlan ID: $workoutPlanId');
      debugPrint('💪 Exercise ID: $exerciseId');

      final result = await db.delete(
        'exercises',
        where: 'workoutPlanId = ? AND id = ?',
        whereArgs: [workoutPlanId, exerciseId],
      );
      debugPrint('✅ Exercício removido. Linhas afetadas: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Erro ao remover exercício: $e');
      return 0;
    }
  }

  static Future<int> updateExercise(Database db, Exercise exercise) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - atualizando exercício no armazenamento temporário');
      // Implementar lógica de atualização para web se necessário
      return 1;
    }

    try {
      return await db.update(
        'exercises',
        exercise.toMap(),
        where: 'id = ?',
        whereArgs: [exercise.id],
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar exercício: $e');
      return 0;
    }
  }

  // Métodos auxiliares para armazenamento web
  static Future<void> _saveExercisesToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> exercisesData = {};
      
      for (var entry in _webExercises.entries) {
        exercisesData[entry.key.toString()] = entry.value.map((e) => e.toMap()).toList();
      }
      
      await prefs.setString('web_exercises', jsonEncode(exercisesData));
      debugPrint('💾 Exercícios salvos no SharedPreferences');
    } catch (e) {
      debugPrint('❌ Erro ao salvar exercícios: $e');
    }
  }

  static Future<void> _loadExercisesFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final exercisesJson = prefs.getString('web_exercises');
      
      if (exercisesJson != null) {
        final Map<String, dynamic> exercisesData = jsonDecode(exercisesJson);
        _webExercises.clear();
        
        for (var entry in exercisesData.entries) {
          final workoutPlanId = int.parse(entry.key);
          final exercisesList = (entry.value as List)
              .map((e) => Exercise.fromMap(e as Map<String, dynamic>))
              .toList();
          _webExercises[workoutPlanId] = exercisesList;
        }
        
        debugPrint('📂 Exercícios carregados do SharedPreferences');
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar exercícios: $e');
    }
  }
}