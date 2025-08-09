import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/workout_plan.dart';

class WorkoutPlanOperations {
  // WorkoutPlan CRUD
  static Future<int> insertWorkoutPlan(Database db, WorkoutPlan plan) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - salvando plano no SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      final existingPlans = prefs.getStringList('workout_plans') ?? [];
      existingPlans.add(jsonEncode(plan.toMap()));
      await prefs.setStringList('workout_plans', existingPlans);
      return existingPlans.length;
    }
    return await db.insert('workout_plans', plan.toMap());
  }

  static Future<List<WorkoutPlan>> getWorkoutPlans(Database db) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - carregando planos do SharedPreferences');
      try {
        final prefs = await SharedPreferences.getInstance();
        final plansData = prefs.getStringList('workout_plans');
        
        if (plansData == null || plansData.isEmpty) {
          debugPrint('📋 Nenhum plano encontrado, inserindo planos padrão');
          await _insertDefaultWorkoutPlansWeb();
          return await getWorkoutPlans(db); // Recursão para carregar os planos padrão
        }
        
        final plans = plansData
            .map((data) => WorkoutPlan.fromMap(jsonDecode(data) as Map<String, dynamic>))
            .toList();
        
        debugPrint('✅ ${plans.length} planos carregados do SharedPreferences');
        return plans;
      } catch (e) {
        debugPrint('❌ Erro ao carregar planos: $e');
        return [];
      }
    }

    try {
      debugPrint('🔄 Buscando planos de treino no banco de dados');
      
      // Verificar se a tabela existe
      final tables = await db.query(
        'sqlite_master',
        where: 'type = ? AND name = ?',
        whereArgs: ['table', 'workout_plans'],
      );
      if (tables.isEmpty) {
        debugPrint('❌ Tabela workout_plans não existe');
        return [];
      }

      final List<Map<String, dynamic>> maps = await db.query('workout_plans');
      debugPrint('📊 Planos encontrados: ${maps.length}');
      
      final plans = List.generate(maps.length, (i) {
        debugPrint('  - ${maps[i]['dayOfWeek']}: ${maps[i]['workoutTypes']}');
        return WorkoutPlan.fromMap(maps[i]);
      });
      
      return plans;
    } catch (e) {
      debugPrint('❌ Erro ao buscar planos de treino: $e');
      return [];
    }
  }

  static Future<int> updateWorkoutPlan(Database db, int id, List<String> workoutTypes) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - atualizando plano no SharedPreferences');
      try {
        final prefs = await SharedPreferences.getInstance();
        final plansData = prefs.getStringList('workout_plans') ?? [];
        
        for (int i = 0; i < plansData.length; i++) {
          final planMap = jsonDecode(plansData[i]) as Map<String, dynamic>;
          if (planMap['id'] == id) {
            planMap['workoutTypes'] = workoutTypes.join(',');
            plansData[i] = jsonEncode(planMap);
            break;
          }
        }
        
        await prefs.setStringList('workout_plans', plansData);
        return 1;
      } catch (e) {
        debugPrint('❌ Erro ao atualizar plano: $e');
        return 0;
      }
    }

    try {
      return await db.update(
        'workout_plans',
        {'workoutTypes': workoutTypes.join(',')},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar plano de treino: $e');
      return 0;
    }
  }

  static Future<int> deleteWorkoutPlan(Database db, int id) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - removendo plano do SharedPreferences');
      try {
        final prefs = await SharedPreferences.getInstance();
        final plansData = prefs.getStringList('workout_plans') ?? [];
        
        plansData.removeWhere((data) {
          final planMap = jsonDecode(data) as Map<String, dynamic>;
          return planMap['id'] == id;
        });
        
        await prefs.setStringList('workout_plans', plansData);
        return 1;
      } catch (e) {
        debugPrint('❌ Erro ao remover plano: $e');
        return 0;
      }
    }
    return await db.delete('workout_plans', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> insertDefaultWorkoutPlans(Database db) async {
    if (kIsWeb) {
      await _insertDefaultWorkoutPlansWeb();
      return;
    }
    await _insertDefaultWorkoutPlansDb(db);
  }

  static Future<List<WorkoutPlan>> getWorkoutPlansWeb() async {
    debugPrint('🌐 Executando em modo web - carregando planos do SharedPreferences');
    try {
      final prefs = await SharedPreferences.getInstance();
      final plansData = prefs.getStringList('workout_plans');
      
      if (plansData == null || plansData.isEmpty) {
        debugPrint('📋 Nenhum plano encontrado, inserindo planos padrão');
        await _insertDefaultWorkoutPlansWeb();
        return await getWorkoutPlansWeb(); // Recursão para carregar os planos padrão
      }
      
      final plans = plansData
          .map((data) => WorkoutPlan.fromMap(jsonDecode(data) as Map<String, dynamic>))
          .toList();
      
      debugPrint('✅ ${plans.length} planos carregados do SharedPreferences');
      return plans;
    } catch (e) {
      debugPrint('❌ Erro ao carregar planos: $e');
      return [];
    }
  }

  static Future<void> _insertDefaultWorkoutPlansWeb() async {
    debugPrint('🌐 Inserindo planos de treino padrão no SharedPreferences');
    
    final defaultPlans = [
      {
        'id': 1,
        'dayOfWeek': 'Segunda-feira',
        'workoutTypes': 'Peito,Tríceps',
        'notes': 'Treino de peito e tríceps',
      },
      {
        'id': 2,
        'dayOfWeek': 'Terça-feira',
        'workoutTypes': 'Costas,Bíceps',
        'notes': 'Treino de costas e bíceps',
      },
      {
        'id': 3,
        'dayOfWeek': 'Quarta-feira',
        'workoutTypes': 'Perna',
        'notes': 'Treino de perna',
      },
      {
        'id': 4,
        'dayOfWeek': 'Quinta-feira',
        'workoutTypes': 'Ombro,Abdômen',
        'notes': 'Treino de ombro e abdômen',
      },
      {
        'id': 5,
        'dayOfWeek': 'Sexta-feira',
        'workoutTypes': 'Peito,Tríceps',
        'notes': 'Treino de peito e tríceps',
      },
      {
        'id': 6,
        'dayOfWeek': 'Sábado',
        'workoutTypes': 'Costas,Bíceps',
        'notes': 'Treino de costas e bíceps',
      },
      {
        'id': 7,
        'dayOfWeek': 'Domingo',
        'workoutTypes': 'Descanso',
        'notes': 'Dia de descanso',
      },
    ];

    final prefs = await SharedPreferences.getInstance();
    final plansData = defaultPlans.map((plan) => jsonEncode(plan)).toList();
    await prefs.setStringList('workout_plans', plansData);
    
    debugPrint('✅ Planos de treino padrão inseridos no SharedPreferences!');
  }

  static Future<void> _insertDefaultWorkoutPlansDb(Database db) async {
    debugPrint('📋 Inserindo planos de treino padrão no banco de dados...');
    
    final defaultPlans = [
      {
        'dayOfWeek': 'Segunda-feira',
        'workoutTypes': 'Peito,Tríceps',
        'notes': 'Treino de peito e tríceps',
      },
      {
        'dayOfWeek': 'Terça-feira',
        'workoutTypes': 'Costas,Bíceps',
        'notes': 'Treino de costas e bíceps',
      },
      {
        'dayOfWeek': 'Quarta-feira',
        'workoutTypes': 'Perna',
        'notes': 'Treino de perna',
      },
      {
        'dayOfWeek': 'Quinta-feira',
        'workoutTypes': 'Ombro,Abdômen',
        'notes': 'Treino de ombro e abdômen',
      },
      {
        'dayOfWeek': 'Sexta-feira',
        'workoutTypes': 'Peito,Tríceps',
        'notes': 'Treino de peito e tríceps',
      },
      {
        'dayOfWeek': 'Sábado',
        'workoutTypes': 'Costas,Bíceps',
        'notes': 'Treino de costas e bíceps',
      },
      {
        'dayOfWeek': 'Domingo',
        'workoutTypes': 'Descanso',
        'notes': 'Dia de descanso',
      },
    ];

    for (final plan in defaultPlans) {
      final id = await db.insert('workout_plans', plan);
      debugPrint('  ✅ Inserido: ${plan['dayOfWeek']} (ID: $id)');
    }
    debugPrint('✅ Planos de treino padrão inseridos com sucesso!');
  }
}