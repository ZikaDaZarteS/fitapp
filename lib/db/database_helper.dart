import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:path_provider/path_provider.dart';

import '../models/workout.dart';
import '../models/exercise.dart';
import '../models/checkin.dart';
import '../models/workout_plan.dart';
import '../models/user.dart' as app_user;

// Import das operações separadas
import 'database_schema.dart';
import 'user_operations.dart';
import 'checkin_operations.dart';
import 'exercise_operations.dart';
import 'workout_plan_operations.dart';
import 'workout_operations.dart';

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
      debugPrint('🌐 Executando em modo web - usando banco simulado');
      // Para web, retornamos um banco simulado que não será usado
      // As operações serão feitas via SharedPreferences
      
      // Garantir que os dados padrão sejam inseridos na primeira execução
      await WorkoutPlanOperations.insertDefaultWorkoutPlans(await openDatabase(':memory:', version: 3));
      
      return await openDatabase(
        ':memory:',
        version: 3,
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
        ':memory:',
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await DatabaseSchema.onCreate(db, version);
  }

  /// Função para migração do banco de dados
  /// Adiciona colunas que podem estar faltando na tabela checkins
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await DatabaseSchema.onUpgrade(db, oldVersion, newVersion);
  }


  // Workout CRUD - Delegando para WorkoutOperations
  Future<int> insertWorkout(Workout workout) async {
    var dbClient = await db;
    return await WorkoutOperations.insertWorkout(dbClient, workout);
  }

  Future<List<Workout>> getWorkouts() async {
    var dbClient = await db;
    return await WorkoutOperations.getWorkouts(dbClient);
  }

  Future<int> deleteWorkout(int id) async {
    var dbClient = await db;
    return await WorkoutOperations.deleteWorkout(dbClient, id);
  }

  Future<int> updateWorkout(Workout workout) async {
    var dbClient = await db;
    return await WorkoutOperations.updateWorkout(dbClient, workout);
  }

  // Exercise CRUD - Delegando para ExerciseOperations
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
    return await ExerciseOperations.updateExercise(dbClient, exercise);
  }
  // User CRUD - Delegando para UserOperations
  Future<int> upsertUser(app_user.User user) async {
    var dbClient = await db;
    return await UserOperations.upsertUser(dbClient, user);
  }

  Future<int> clearUser() async {
    var dbClient = await db;
    return await UserOperations.clearUser(dbClient);
  }

  // Exercise Operations - Delegando para ExerciseOperations
  Future<List<Exercise>> getExercisesForWorkoutPlan(int workoutPlanId) async {
    var dbClient = await db;
    return await ExerciseOperations.getExercisesForWorkoutPlan(dbClient, workoutPlanId);
  }

  Future<int> addExerciseToWorkoutPlan(
    int workoutPlanId,
    Exercise exercise,
  ) async {
    var dbClient = await db;
    return await ExerciseOperations.addExerciseToWorkoutPlan(dbClient, workoutPlanId, exercise);
  }

  Future<int> removeExerciseFromWorkoutPlan(
    int workoutPlanId,
    int exerciseId,
  ) async {
    var dbClient = await db;
    return await ExerciseOperations.removeExerciseFromWorkoutPlan(dbClient, workoutPlanId, exerciseId);
  }

  // User Operations - Delegando para UserOperations
  Future<app_user.User?> getUser() async {
    var dbClient = await db;
    return await UserOperations.getUser(dbClient);
  }
  Future<int> updateUser(app_user.User user) async {
    var dbClient = await db;
    return await UserOperations.updateUser(dbClient, user);
  }

  Future<int> updateUserName(String name) async {
    var dbClient = await db;
    return await UserOperations.updateUserName(dbClient, name);
  }

  Future<int> updateUserEmail(String email) async {
    var dbClient = await db;
    return await UserOperations.updateUserEmail(dbClient, email);
  }
  Future<List<app_user.User>> getUsers() async {
    var dbClient = await db;
    return await UserOperations.getUsers(dbClient);
  }

  // Check-in Operations - Delegando para UserOperations
  Future<int> updateCheckIn(DateTime checkIn) async {
    var dbClient = await db;
    return await UserOperations.updateCheckIn(dbClient, checkIn);
  }

  Future<int> resetCheckIn() async {
    var dbClient = await db;
    return await UserOperations.resetCheckIn(dbClient);
  }

  // Checkin Operations - Delegando para CheckinOperations
  Future<int> insertCheckin(Checkin checkin) async {
    var dbClient = await db;
    return await CheckinOperations.insertCheckin(dbClient, checkin);
  }

  Future<List<Checkin>> getCheckins(String userId) async {
    var dbClient = await db;
    return await CheckinOperations.getCheckins(dbClient, userId);
  }

  Future<int> getCheckinCount(String userId) async {
    var dbClient = await db;
    return await CheckinOperations.getCheckinCount(dbClient, userId);
  }

  Future<List<Map<String, dynamic>>> getCheckinStats() async {
    var dbClient = await db;
    return await CheckinOperations.getCheckinStats(dbClient);
  }

  // Friends Operations - Delegando para WorkoutOperations
  Future<void> addFriend(int userId, int friendId) async {
    var dbClient = await db;
    await WorkoutOperations.addFriend(dbClient, userId, friendId);
  }

  Future<List<int>> getFriends(int userId) async {
    var dbClient = await db;
    return await WorkoutOperations.getFriends(dbClient, userId);
  }

  Future<List<Map<String, dynamic>>> getFriendRanking(int userId) async {
    var dbClient = await db;
    return await WorkoutOperations.getFriendRanking(dbClient, userId);
  }

  // WorkoutPlan Operations - Delegando para WorkoutPlanOperations
  Future<int> insertWorkoutPlan(WorkoutPlan plan) async {
    var dbClient = await db;
    return await WorkoutPlanOperations.insertWorkoutPlan(dbClient, plan);
  }

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    if (kIsWeb) {
      // No modo web, usar diretamente o SharedPreferences sem banco de dados
      return await WorkoutPlanOperations.getWorkoutPlansWeb();
    }
    var dbClient = await db;
    return await WorkoutPlanOperations.getWorkoutPlans(dbClient);
  }

  Future<int> updateWorkoutPlan(int id, List<String> workoutTypes) async {
    var dbClient = await db;
    return await WorkoutPlanOperations.updateWorkoutPlan(dbClient, id, workoutTypes);
  }

  Future<int> deleteWorkoutPlan(int id) async {
    var dbClient = await db;
    return await WorkoutPlanOperations.deleteWorkoutPlan(dbClient, id);
  }
}
