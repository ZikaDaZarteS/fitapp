import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'workout_plan_operations.dart';

class DatabaseSchema {
  static Future<void> onCreate(Database db, int version) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - pulando criação de tabelas SQLite');
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

    await WorkoutPlanOperations.insertDefaultWorkoutPlans(db);
  }

  /// Função para migração do banco de dados
  /// Adiciona colunas que podem estar faltando na tabela checkins
  static Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (kIsWeb) {
      debugPrint('🌐 Executando em modo web - pulando migração SQLite');
      return;
    }

    debugPrint('🔄 Migrando banco de dados de versão $oldVersion para $newVersion');

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
}