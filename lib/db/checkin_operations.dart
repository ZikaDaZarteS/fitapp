import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/checkin.dart';

class CheckinOperations {
  static Future<int> insertCheckin(Database db, Checkin checkin) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - salvando check-in no SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      final existingCheckins = prefs.getStringList('checkins') ?? [];
      existingCheckins.add(jsonEncode(checkin.toMap()));
      await prefs.setStringList('checkins', existingCheckins);
      return 1;
    }
    return await db.insert('checkins', checkin.toMap());
  }

  static Future<List<Checkin>> getCheckins(Database db, String userId) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - carregando check-ins do SharedPreferences');
      try {
        final prefs = await SharedPreferences.getInstance();
        final checkinsData = prefs.getStringList('checkins') ?? [];
        return checkinsData
            .map((data) => Checkin.fromMap(jsonDecode(data) as Map<String, dynamic>))
            .where((checkin) => checkin.userId == userId)
            .toList();
      } catch (e) {
        debugPrint('❌ Erro ao carregar check-ins: $e');
        return [];
      }
    }

    try {
      List<Map<String, dynamic>> maps = await db.query(
        'checkins',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'timestamp DESC',
      );
      return List.generate(maps.length, (i) => Checkin.fromMap(maps[i]));
    } catch (e) {
      debugPrint('❌ Erro ao buscar check-ins: $e');
      return [];
    }
  }

  static Future<int> getCheckinCount(Database db, String userId) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - contando check-ins');
      final checkins = await getCheckins(db, userId);
      return checkins.length;
    }

    try {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM checkins WHERE userId = ?',
        [userId],
      );
      return result.first['count'] as int;
    } catch (e) {
      debugPrint('❌ Erro ao contar check-ins: $e');
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>> getCheckinStats(Database db) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - retornando estatísticas simuladas');
      return [
        {'userId': 'user1', 'count': 5},
        {'userId': 'user2', 'count': 3},
      ];
    }

    try {
      return await db.rawQuery('''
        SELECT userId, COUNT(*) as count 
        FROM checkins 
        GROUP BY userId 
        ORDER BY count DESC
      ''');
    } catch (e) {
      debugPrint('❌ Erro ao buscar estatísticas de check-in: $e');
      return [];
    }
  }
}