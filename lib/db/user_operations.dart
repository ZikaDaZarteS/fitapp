import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart' as app_user;

class UserOperations {
  // User CRUD
  static Future<int> upsertUser(Database db, app_user.User user) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - salvando usuário no SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toMap()));
      return 1;
    }
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> clearUser(Database db) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - removendo usuário do SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      return 1;
    }
    return await db.delete('users');
  }

  static Future<app_user.User?> getUser(Database db) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - carregando usuário do SharedPreferences');
      try {
        final prefs = await SharedPreferences.getInstance();
        final userData = prefs.getString('user_data');
        if (userData != null) {
          final userMap = jsonDecode(userData) as Map<String, dynamic>;
          return app_user.User.fromMap(userMap);
        }
        return null;
      } catch (e) {
        debugPrint('❌ Erro ao carregar usuário do SharedPreferences: $e');
        return null;
      }
    }

    try {
      List<Map<String, dynamic>> maps = await db.query('users');
      if (maps.isNotEmpty) {
        return app_user.User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao buscar usuário: $e');
      return null;
    }
  }

  static Future<int> updateUser(Database db, app_user.User user) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - atualizando usuário no SharedPreferences');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toMap()));
      return 1;
    }

    try {
      return await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar usuário: $e');
      return 0;
    }
  }

  static Future<int> updateUserName(Database db, String name) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - atualizando nome do usuário');
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        userMap['name'] = name;
        await prefs.setString('user_data', jsonEncode(userMap));
      }
      return 1;
    }

    try {
      return await db.update(
        'users',
        {'name': name},
        where: 'id IS NOT NULL',
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar nome do usuário: $e');
      return 0;
    }
  }

  static Future<int> updateUserEmail(Database db, String email) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - atualizando email do usuário');
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        userMap['email'] = email;
        await prefs.setString('user_data', jsonEncode(userMap));
      }
      return 1;
    }

    try {
      return await db.update(
        'users',
        {'email': email},
        where: 'id IS NOT NULL',
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar email do usuário: $e');
      return 0;
    }
  }

  static Future<List<app_user.User>> getUsers(Database db) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - retornando lista de usuários simulada');
      final user = await getUser(db);
      return user != null ? [user] : [];
    }

    try {
      List<Map<String, dynamic>> maps = await db.query('users');
      return List.generate(maps.length, (i) {
        return app_user.User.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrint('❌ Erro ao buscar usuários: $e');
      return [];
    }
  }

  static Future<int> updateCheckIn(Database db, DateTime checkIn) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - atualizando check-in');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_checkin', checkIn.toIso8601String());
      await prefs.setBool('checked_in', true);
      return 1;
    }

    try {
      return await db.update(
        'users',
        {
          'lastCheckIn': checkIn.toIso8601String(),
          'checkedIn': 1,
        },
        where: 'id IS NOT NULL',
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar check-in: $e');
      return 0;
    }
  }

  static Future<int> resetCheckIn(Database db) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - resetando check-in');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('checked_in', false);
      return 1;
    }
    return await db.update('users', {'checkedIn': 0});
  }
}