import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/workout.dart';

class WorkoutOperations {
  // Workout CRUD
  static Future<int> insertWorkout(Database db, Workout workout) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - salvando treino no SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      final existingWorkouts = prefs.getStringList('workouts') ?? [];
      existingWorkouts.add(jsonEncode(workout.toMap()));
      await prefs.setStringList('workouts', existingWorkouts);
      return existingWorkouts.length;
    }
    return await db.insert('workouts', workout.toMap());
  }

  static Future<List<Workout>> getWorkouts(Database db) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - retornando treinos simulados');
      return []; // Retorna lista vazia no modo web por enquanto
    }

    try {
      List<Map<String, dynamic>> maps = await db.query('workouts');
      return maps.map((m) => Workout.fromMap(m)).toList();
    } catch (e) {
      debugPrint('❌ Erro ao buscar treinos: $e');
      return [];
    }
  }

  static Future<int> deleteWorkout(Database db, int id) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - removendo treino do SharedPreferences');
      try {
        final prefs = await SharedPreferences.getInstance();
        final workoutsData = prefs.getStringList('workouts') ?? [];
        
        workoutsData.removeWhere((data) {
          final workoutMap = jsonDecode(data) as Map<String, dynamic>;
          return workoutMap['id'] == id;
        });
        
        await prefs.setStringList('workouts', workoutsData);
        return 1;
      } catch (e) {
        debugPrint('❌ Erro ao remover treino: $e');
        return 0;
      }
    }
    return await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateWorkout(Database db, Workout workout) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - atualizando treino no SharedPreferences');
      try {
        final prefs = await SharedPreferences.getInstance();
        final workoutsData = prefs.getStringList('workouts') ?? [];
        
        for (int i = 0; i < workoutsData.length; i++) {
          final workoutMap = jsonDecode(workoutsData[i]) as Map<String, dynamic>;
          if (workoutMap['id'] == workout.id) {
            workoutsData[i] = jsonEncode(workout.toMap());
            break;
          }
        }
        
        await prefs.setStringList('workouts', workoutsData);
        return 1;
      } catch (e) {
        debugPrint('❌ Erro ao atualizar treino: $e');
        return 0;
      }
    }

    try {
      return await db.update(
        'workouts',
        workout.toMap(),
        where: 'id = ?',
        whereArgs: [workout.id],
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar treino: $e');
      return 0;
    }
  }

  // Friends operations
  static Future<void> addFriend(Database db, int userId, int friendId) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - adicionando amigo ao SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      final friends = prefs.getStringList('friends_$userId') ?? [];
      if (!friends.contains(friendId.toString())) {
        friends.add(friendId.toString());
        await prefs.setStringList('friends_$userId', friends);
      }
      return;
    }
    await db.insert('friends', {'userId': userId, 'friendId': friendId});
  }

  static Future<List<int>> getFriends(Database db, int userId) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - carregando amigos do SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      final friends = prefs.getStringList('friends_$userId') ?? [];
      return friends.map((f) => int.parse(f)).toList();
    }

    try {
      List<Map<String, dynamic>> maps = await db.query(
        'friends',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      return maps.map((m) => m['friendId'] as int).toList();
    } catch (e) {
      debugPrint('❌ Erro ao buscar amigos: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getFriendRanking(Database db, int userId) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - retornando ranking simulado');
      return [
        {'friendId': 1, 'name': 'Amigo 1', 'checkins': 10},
        {'friendId': 2, 'name': 'Amigo 2', 'checkins': 8},
      ];
    }

    try {
      return await db.rawQuery('''
        SELECT f.friendId, u.name, COUNT(c.id) as checkins
        FROM friends f
        LEFT JOIN users u ON f.friendId = u.id
        LEFT JOIN checkins c ON f.friendId = c.userId
        WHERE f.userId = ?
        GROUP BY f.friendId, u.name
        ORDER BY checkins DESC
      ''', [userId]);
    } catch (e) {
      debugPrint('❌ Erro ao buscar ranking de amigos: $e');
      return [];
    }
  }
}