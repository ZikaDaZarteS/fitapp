import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - retornando banco simulado');
      return await openDatabase(
        'in_memory_db',
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }

    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "fit_app.db");
      return await openDatabase(
        path,
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      debugPrint('❌ Erro ao inicializar banco: $e');
      return await openDatabase(
        'in_memory_db',
        version: 3,
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
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        height REAL,
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

    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workoutPlanId INTEGER NOT NULL,
        name TEXT NOT NULL,
        muscleGroup TEXT NOT NULL,
        description TEXT NOT NULL,
        instructions TEXT NOT NULL,
        imageUrl TEXT,
        videoUrl TEXT,
        sets INTEGER,
        reps INTEGER,
        restTime INTEGER,
        equipment TEXT,
        difficulty TEXT DEFAULT 'Intermediário',
        FOREIGN KEY (workoutPlanId) REFERENCES workout_plans (id) ON DELETE CASCADE
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

    if (oldVersion < 3) {
      // Recriar tabela users com nova estrutura
      try {
        await db.execute('DROP TABLE IF EXISTS users');
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            height REAL,
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
        debugPrint('✅ Tabela users recriada com nova estrutura');
      } catch (e) {
        debugPrint('❌ Erro ao recriar tabela users: $e');
      }
    }
  }

  // Workout CRUD
  Future<int> insertWorkout(Workout workout) async {
    var dbClient = await db;
    return await dbClient.insert('workouts', workout.toMap());
  }

  Future<List<Workout>> getWorkouts() async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - retornando treinos simulados');
      return []; // Retorna lista vazia no modo web por enquanto
    }

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
    if (kIsWeb) {
      debugPrint(
        '🌐 Executando em modo web - atualizando exercício no armazenamento temporário',
      );

      // Procurar o exercício em todos os planos de treino
      for (var workoutPlanId in _webExercises.keys) {
        final exercises = _webExercises[workoutPlanId]!;
        final index = exercises.indexWhere((e) => e.id == exercise.id);
        if (index != -1) {
          exercises[index] = exercise;
          debugPrint(
            '✅ Exercício "${exercise.name}" atualizado no WorkoutPlan ID: $workoutPlanId',
          );

          // Salvar no SharedPreferences
          await _saveExercisesToStorage();

          return 1;
        }
      }

      debugPrint('❌ Exercício não encontrado para atualização');
      return 0;
    }

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

  Future<int> clearUser() async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - limpando dados do usuário');
      return 1; // Simula sucesso no modo web
    }

    var dbClient = await db;
    return await dbClient.delete('users');
  }

  // Armazenamento temporário para exercícios no modo web
  static final Map<int, List<Exercise>> _webExercises = {};

  // Método para salvar exercícios no SharedPreferences
  Future<void> _saveExercisesToStorage() async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final Map<String, dynamic> data = {};

        _webExercises.forEach((workoutPlanId, exercises) {
          data[workoutPlanId.toString()] = exercises
              .map((e) => e.toMap())
              .toList();
        });

        final jsonString = jsonEncode(data);
        await prefs.setString('web_exercises', jsonString);
        debugPrint('💾 Exercícios salvos no SharedPreferences: $jsonString');
      } catch (e) {
        debugPrint('❌ Erro ao salvar exercícios: $e');
      }
    }
  }

  // Método para carregar exercícios do SharedPreferences
  Future<void> _loadExercisesFromStorage() async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final String? dataString = prefs.getString('web_exercises');

        if (dataString != null) {
          debugPrint(
            '📂 Carregando exercícios do SharedPreferences: $dataString',
          );
          final Map<String, dynamic> data = jsonDecode(dataString);

          _webExercises.clear();
          data.forEach((workoutPlanIdStr, exercisesList) {
            final workoutPlanId = int.parse(workoutPlanIdStr);
            final exercises = (exercisesList as List)
                .map((e) => Exercise.fromMap(e as Map<String, dynamic>))
                .toList();
            _webExercises[workoutPlanId] = exercises;
          });

          debugPrint('✅ Exercícios carregados: ${_webExercises.length} planos');
        }
      } catch (e) {
        debugPrint('❌ Erro ao carregar exercícios: $e');
      }
    }
  }

  // Métodos para gerenciar exercícios
  Future<List<Exercise>> getExercisesForWorkoutPlan(int workoutPlanId) async {
    if (kIsWeb) {
      debugPrint(
        '🌐 Executando em modo web - retornando exercícios do armazenamento temporário',
      );

      // Carregar dados salvos se necessário
      if (_webExercises.isEmpty) {
        await _loadExercisesFromStorage();
      }

      // Se não existem exercícios para este plano, retorna lista vazia
      if (!_webExercises.containsKey(workoutPlanId)) {
        debugPrint(
          '📋 Nenhum exercício encontrado para WorkoutPlan ID: $workoutPlanId',
        );
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

      var dbClient = await db;

      // Verificar se a tabela existe
      final tables = await dbClient.query(
        'sqlite_master',
        where: 'type = ? AND name = ?',
        whereArgs: ['table', 'exercises'],
      );
      if (tables.isEmpty) {
        debugPrint('❌ Tabela exercises não existe');
        return [];
      }

      debugPrint('✅ Tabela exercises encontrada');

      final List<Map<String, dynamic>> maps = await dbClient.query(
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

  Future<int> addExerciseToWorkoutPlan(
    int workoutPlanId,
    Exercise exercise,
  ) async {
    if (kIsWeb) {
      debugPrint(
        '🌐 Executando em modo web - adicionando exercício ao armazenamento temporário',
      );

      // Inicializa a lista se não existir
      if (!_webExercises.containsKey(workoutPlanId)) {
        _webExercises[workoutPlanId] = [];
      }

      // Adiciona o exercício à lista
      _webExercises[workoutPlanId]!.add(exercise);

      debugPrint(
        '✅ Exercício "${exercise.name}" adicionado ao WorkoutPlan ID: $workoutPlanId',
      );
      debugPrint(
        '📊 Total de exercícios no plano: ${_webExercises[workoutPlanId]!.length}',
      );

      // Salvar no SharedPreferences
      await _saveExercisesToStorage();

      return 1;
    }

    try {
      debugPrint('🔄 Adicionando exercício ao banco de dados');
      debugPrint('📋 WorkoutPlan ID: $workoutPlanId');
      debugPrint('💪 Exercise: ${exercise.name}');

      var dbClient = await db;
      final exerciseMap = exercise.toMap();
      exerciseMap['workoutPlanId'] = workoutPlanId;

      debugPrint('📝 Exercise Map: $exerciseMap');

      final result = await dbClient.insert('exercises', exerciseMap);
      debugPrint('✅ Exercício adicionado com ID: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Erro ao adicionar exercício: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
      return 0;
    }
  }

  Future<int> removeExerciseFromWorkoutPlan(
    int workoutPlanId,
    int exerciseId,
  ) async {
    if (kIsWeb) {
      debugPrint(
        '🌐 Executando em modo web - removendo exercício do armazenamento temporário',
      );

      if (!_webExercises.containsKey(workoutPlanId)) {
        debugPrint(
          '❌ Nenhum exercício encontrado para WorkoutPlan ID: $workoutPlanId',
        );
        return 0;
      }

      final exercises = _webExercises[workoutPlanId]!;
      if (exerciseId > 0 && exerciseId <= exercises.length) {
        final removedExercise = exercises.removeAt(exerciseId - 1);
        debugPrint(
          '✅ Exercício "${removedExercise.name}" removido do WorkoutPlan ID: $workoutPlanId',
        );
        debugPrint('📊 Total de exercícios no plano: ${exercises.length}');

        // Salvar no SharedPreferences
        await _saveExercisesToStorage();

        return 1;
      } else {
        debugPrint('❌ ID do exercício inválido: $exerciseId');
        return 0;
      }
    }

    try {
      var dbClient = await db;
      return await dbClient.delete(
        'exercises',
        where: 'id = ? AND workoutPlanId = ?',
        whereArgs: [exerciseId, workoutPlanId],
      );
    } catch (e) {
      debugPrint('❌ Erro ao remover exercício: $e');
      return 0;
    }
  }

  Future<app_user.User?> getUser() async {
    if (kIsWeb) {
      debugPrint(
        '🌐 Executando em modo web - retornando usuário do SharedPreferences',
      );
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_name') ?? 'DIEGO AMANCIO RIBEIRO';
      final email =
          prefs.getString('user_email') ?? 'diegoribeiro359@gmail.com';

      return app_user.User(
        id: '1',
        name: name,
        email: email,
        height: 175.0,
        weight: 70.0,
        age: 25,
      );
    }

    try {
      var dbClient = await db;
      List<Map<String, dynamic>> maps = await dbClient.query('users');
      if (maps.isNotEmpty) {
        return app_user.User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao buscar usuário: $e');
      return null;
    }
  }

  Future<int> updateUser(app_user.User user) async {
    if (kIsWeb) {
      debugPrint(
        '🌐 Executando em modo web - simulando atualização de usuário',
      );
      // Para web, salvar no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
      return 1;
    }

    try {
      var dbClient = await db;
      return await dbClient.update(
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

  Future<int> updateUserName(String name) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - simulando atualização de nome');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      return 1;
    }

    try {
      var dbClient = await db;
      List<Map<String, dynamic>> existing = await dbClient.query('users');
      if (existing.isEmpty) return 0;

      return await dbClient.update(
        'users',
        {'name': name},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar nome: $e');
      return 0;
    }
  }

  Future<int> updateUserEmail(String email) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - simulando atualização de email');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      return 1;
    }

    try {
      var dbClient = await db;
      List<Map<String, dynamic>> existing = await dbClient.query('users');
      if (existing.isEmpty) return 0;

      return await dbClient.update(
        'users',
        {'email': email},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    } catch (e) {
      debugPrint('❌ Erro ao atualizar email: $e');
      return 0;
    }
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
        id: 1,
        dayOfWeek: 'Segunda-feira',
        workoutTypes: ['Peito', 'Tríceps'],
        notes: 'Treino de peito e tríceps',
      ),
      WorkoutPlan(
        id: 2,
        dayOfWeek: 'Terça-feira',
        workoutTypes: ['Costas', 'Bíceps'],
        notes: 'Treino de costas e bíceps',
      ),
      WorkoutPlan(
        id: 3,
        dayOfWeek: 'Quarta-feira',
        workoutTypes: ['Perna'],
        notes: 'Treino de perna',
      ),
      WorkoutPlan(
        id: 4,
        dayOfWeek: 'Quinta-feira',
        workoutTypes: ['Ombro', 'Abdômen'],
        notes: 'Treino de ombro e abdômen',
      ),
      WorkoutPlan(
        id: 5,
        dayOfWeek: 'Sexta-feira',
        workoutTypes: ['Peito', 'Tríceps'],
        notes: 'Treino de peito e tríceps',
      ),
      WorkoutPlan(
        id: 6,
        dayOfWeek: 'Sábado',
        workoutTypes: ['Costas', 'Bíceps'],
        notes: 'Treino de costas e bíceps',
      ),
      WorkoutPlan(
        id: 7,
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
