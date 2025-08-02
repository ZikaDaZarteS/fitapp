import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

// Conditional import for dart:io

import 'package:path_provider/path_provider.dart';

import '../models/workout.dart';
import '../models/exercise.dart';
import '../models/checkin.dart';
import '../models/workout_plan.dart';
import '../models/user.dart' as app_user;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - retornando banco simulado');
      return await openDatabase(
        'in_memory_db',
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - retornando banco simulado');
      return await openDatabase(
        'in_memory_db',
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }

    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "fit_app.db");
      return await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      debugPrint('❌ Erro ao inicializar banco: $e');
      return await openDatabase(
        'in_memory_db',
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    if (kIsWeb) {
      debugPrint(
        '🌐 Executando em modo web - pulando criação de tabelas SQLite',
      );
      return;
    }

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firestoreId TEXT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        height INTEGER,
        weight REAL,
        age INTEGER,
        checkedIn INTEGER DEFAULT 0,
        goal TEXT,
        level TEXT,
        time TEXT,
        equipments TEXT,
        lastCheckIn TEXT,
        gender TEXT,
        experience TEXT,
        medicalRestrictions TEXT,
        exercisePreferences TEXT,
        frequency TEXT,
        customGoal TEXT,
        acceptTerms INTEGER,
        profilePhotoPath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firestoreId TEXT,
        title TEXT NOT NULL,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE checkins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        note TEXT,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE friends (
        userId INTEGER,
        friendId INTEGER,
        PRIMARY KEY (userId, friendId)
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dayOfWeek TEXT NOT NULL,
        workoutTypes TEXT NOT NULL,
        notes TEXT
      )
    ''');
    await _insertDefaultWorkoutPlans(db);
  }

  /// Função para migração do banco de dados
  /// Adiciona colunas que podem estar faltando na tabela checkins
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - pulando migração SQLite');
      return;
    }

    debugPrint(
      '🔄 Migrando banco de dados de versão $oldVersion para $newVersion',
    );

    if (oldVersion < 2) {
      // Verificar se a coluna 'note' existe na tabela checkins
      try {
        await db.execute('ALTER TABLE checkins ADD COLUMN note TEXT');
        debugPrint('✅ Coluna "note" adicionada à tabela checkins');
      } catch (e) {
        debugPrint('ℹ️ Coluna "note" já existe na tabela checkins: $e');
      }

      // Verificar se a coluna 'imagePath' existe na tabela checkins
      try {
        await db.execute('ALTER TABLE checkins ADD COLUMN imagePath TEXT');
        debugPrint('✅ Coluna "imagePath" adicionada à tabela checkins');
      } catch (e) {
        debugPrint('ℹ️ Coluna "imagePath" já existe na tabela checkins: $e');
      }
    }
  }

  // Workout CRUD
  Future<int> insertWorkout(Workout workout) async {
    var dbClient = await db;
    return await dbClient.insert('workouts', workout.toMap());
  }

  Future<List<Workout>> getWorkouts() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('workouts');
    return maps.map((m) => Workout.fromMap(m)).toList();
  }

  Future<int> deleteWorkout(int id) async {
    var dbClient = await db;
    return await dbClient.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateWorkout(Workout workout) async {
    var dbClient = await db;
    return await dbClient.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  // Exercise CRUD
  Future<int> insertExercise(Exercise exercise) async {
    var dbClient = await db;
    return await dbClient.insert('exercises', exercise.toMap());
  }

  Future<List<Exercise>> getExercises(int workoutId) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      'exercises',
      where: 'workoutId = ?',
      whereArgs: [workoutId],
    );
    return maps.map((m) => Exercise.fromMap(m)).toList();
  }

  Future<int> deleteExercise(int id) async {
    var dbClient = await db;
    return await dbClient.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateExercise(Exercise exercise) async {
    var dbClient = await db;
    return await dbClient.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  // User CRUD
  Future<int> upsertUser(app_user.User user) async {
    var dbClient = await db;
    return await dbClient.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<app_user.User?> getUser() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('users');
    if (maps.isNotEmpty) {
      return app_user.User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<app_user.User>> getUsers() async {
    try {
      if (kIsWeb) {
        debugPrint('🌐 Executando em modo web - retornando usuários simulados');
        return [
          app_user.User(
            id: '1',
            name: 'João Silva',
            email: 'joao@email.com',
            height: 175.0,
            weight: 70.0,
            age: 25,
          ),
          app_user.User(
            id: '2',
            name: 'Maria Santos',
            email: 'maria@email.com',
            height: 165.0,
            weight: 60.0,
            age: 28,
          ),
          app_user.User(
            id: '3',
            name: 'Pedro Costa',
            email: 'pedro@email.com',
            height: 180.0,
            weight: 75.0,
            age: 30,
          ),
          app_user.User(
            id: '4',
            name: 'Ana Oliveira',
            email: 'ana@email.com',
            height: 160.0,
            weight: 55.0,
            age: 22,
          ),
          app_user.User(
            id: '5',
            name: 'Carlos Lima',
            email: 'carlos@email.com',
            height: 178.0,
            weight: 72.0,
            age: 27,
          ),
        ];
      }
      var dbClient = await db;
      List<Map<String, dynamic>> maps = await dbClient.query('users');
      return maps.map((m) => app_user.User.fromMap(m)).toList();
    } catch (e) {
      debugPrint('❌ Erro ao buscar usuários: $e');
      return [];
    }
  }

  Future<int> updateCheckIn(DateTime checkIn) async {
    var dbClient = await db;
    List<Map<String, dynamic>> existing = await dbClient.query('users');
    if (existing.isEmpty) return 0;

    int userId = existing.first['id'];

    await dbClient.update(
      'users',
      {'lastCheckIn': checkIn.toIso8601String(), 'checkedIn': 1},
      where: 'id = ?',
      whereArgs: [userId],
    );

    return await dbClient.insert('checkins', {
      'userId': userId,
      'date': checkIn.toIso8601String(),
    });
  }

  Future<int> resetCheckIn() async {
    var dbClient = await db;
    return await dbClient.update('users', {'checkedIn': 0});
  }

  // Checkin
  static final List<Checkin> _webCheckins = [];

  Future<int> insertCheckin(Checkin checkin) async {
    if (kIsWeb) {
      _webCheckins.insert(0, checkin);
      return 1;
    }

    var dbClient = await db;
    return await dbClient.insert('checkins', checkin.toMap());
  }

  Future<List<Checkin>> getCheckins(String userId) async {
    if (kIsWeb) {
      return _webCheckins.where((c) => c.userId == userId).toList();
    }

    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      'checkins',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => Checkin.fromMap(m)).toList();
  }

  Future<int> getCheckinCount(String userId) async {
    if (kIsWeb) {
      return _webCheckins.where((c) => c.userId == userId).length;
    }

    var dbClient = await db;
    final result = await dbClient.rawQuery(
      'SELECT COUNT(*) FROM checkins WHERE userId = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getCheckinStats() async {
    var dbClient = await db;
    final result = await dbClient.rawQuery('''
      SELECT 
        strftime('%Y-%m-%d', timestamp) as date,
        COUNT(*) as count
      FROM checkins 
      GROUP BY strftime('%Y-%m-%d', timestamp)
      ORDER BY date DESC
      LIMIT 30
    ''');
    return result;
  }

  // Friends
  Future<void> addFriend(int userId, int friendId) async {
    var dbClient = await db;
    await dbClient.insert('friends', {'userId': userId, 'friendId': friendId});
  }

  Future<List<int>> getFriends(int userId) async {
    var dbClient = await db;
    final result = await dbClient.query(
      'friends',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.map((r) => r['friendId'] as int).toList();
  }

  Future<List<Map<String, dynamic>>> getFriendRanking(int userId) async {
    var dbClient = await db;

    final friendIds = await getFriends(userId);
    if (friendIds.isEmpty) return [];

    final placeholders = List.filled(friendIds.length, '?').join(',');
    final result = await dbClient.rawQuery('''
      SELECT u.name, COUNT(c.id) AS totalCheckins
      FROM users u
      LEFT JOIN checkins c ON u.id = c.userId
      WHERE u.id IN ($placeholders)
      GROUP BY u.id
      ORDER BY totalCheckins DESC
    ''', friendIds);

    return result;
  }

  // WorkoutPlan CRUD
  Future<int> insertWorkoutPlan(WorkoutPlan plan) async {
    var dbClient = await db;
    return await dbClient.insert('workout_plans', plan.toMap());
  }

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    try {
      if (kIsWeb) {
        debugPrint('🌐 Executando em modo web - retornando planos padrão');
        return _getDefaultWorkoutPlans();
      }

      var dbClient = await db;
      List<Map<String, dynamic>> maps = await dbClient.query('workout_plans');
      debugPrint('📋 Buscando planos de treino: ${maps.length} encontrados');
      final plans = maps.map((m) => WorkoutPlan.fromMap(m)).toList();
      for (var plan in plans) {
        debugPrint('  - ${plan.dayOfWeek}: ${plan.workoutTypes.join(', ')}');
      }
      return plans;
    } catch (e) {
      debugPrint('❌ Erro ao buscar planos de treino: $e');
      return _getDefaultWorkoutPlans();
    }
  }

  List<WorkoutPlan> _getDefaultWorkoutPlans() {
    return [
      WorkoutPlan(
        dayOfWeek: 'Segunda-feira',
        workoutTypes: ['Peito', 'Tríceps'],
        notes: 'Treino de peito e tríceps',
      ),
      WorkoutPlan(
        dayOfWeek: 'Terça-feira',
        workoutTypes: ['Costas', 'Bíceps'],
        notes: 'Treino de costas e bíceps',
      ),
      WorkoutPlan(
        dayOfWeek: 'Quarta-feira',
        workoutTypes: ['Perna'],
        notes: 'Treino de perna',
      ),
      WorkoutPlan(
        dayOfWeek: 'Quinta-feira',
        workoutTypes: ['Ombro', 'Abdômen'],
        notes: 'Treino de ombro e abdômen',
      ),
      WorkoutPlan(
        dayOfWeek: 'Sexta-feira',
        workoutTypes: ['Peito', 'Tríceps'],
        notes: 'Treino de peito e tríceps',
      ),
      WorkoutPlan(
        dayOfWeek: 'Sábado',
        workoutTypes: ['Costas', 'Bíceps'],
        notes: 'Treino de costas e bíceps',
      ),
      WorkoutPlan(
        dayOfWeek: 'Domingo',
        workoutTypes: ['Descanso'],
        notes: 'Dia de descanso',
      ),
    ];
  }

  Future<int> updateWorkoutPlan(int id, List<String> workoutTypes) async {
    try {
      if (kIsWeb) {
        debugPrint('🌐 Executando em modo web - atualização simulada');
        return 1;
      }
      var dbClient = await db;
      return await dbClient.update(
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

  Future<int> deleteWorkoutPlan(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'workout_plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> _insertDefaultWorkoutPlans(Database db) async {
    debugPrint('📝 Inserindo planos de treino padrão...');
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
