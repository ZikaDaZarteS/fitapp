import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

import 'firebase_options.dart';
import 'package:fitapp/db/database_helper.dart' as db_helper;
import 'package:fitapp/models/user.dart' as local_user;

import 'package:fitapp/screens/login_screen.dart';
import 'package:fitapp/screens/main_menu_screen.dart';
import 'package:fitapp/screens/onboarding_screen.dart';
import 'package:fitapp/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar sqflite para web
  if (kIsWeb) {
    debugPrint('🌐 Inicializando sqflite para web...');
    databaseFactory = databaseFactoryFfiWeb;
    debugPrint('✅ sqflite para web inicializado');
  }

  try {
    debugPrint('🚀 Iniciando Firebase...');
    // Verificar se já foi inicializado
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ Firebase inicializado com sucesso');
    } else {
      debugPrint('✅ Firebase já inicializado');
    }

    // Teste de conexão com Firebase Auth
    try {
      final auth = fb_auth.FirebaseAuth.instance;
      debugPrint('✅ Firebase Auth disponível');
      debugPrint('👤 Usuário atual: ${auth.currentUser?.email ?? "Nenhum"}');
    } catch (e) {
      debugPrint('❌ Erro no Firebase Auth: $e');
    }
  } catch (e) {
    debugPrint('❌ Erro ao inicializar Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  fb_auth.User? _user;

  @override
  void initState() {
    super.initState();
    // Listener para mudanças no estado de autenticação
    fb_auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<Widget> _decideStartScreen() async {
    final db = db_helper.DatabaseHelper();
    final firebaseUser = _user ?? fb_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      try {
        final localUser = await db.getUser();
        if (localUser != null) {
          debugPrint('👤 Usuário local encontrado: ${localUser.email}');
          return const MainMenuScreen();
        } else {
          await db.upsertUser(
            local_user.User(
              id: firebaseUser.uid,
              name: firebaseUser.displayName ?? 'Usuário',
              email: firebaseUser.email ?? '',
              height: 0,
              weight: 0,
              age: 0,
            ),
          );
          debugPrint('📥 Usuário salvo localmente via Firebase: ${firebaseUser.displayName}');
          return const MainMenuScreen();
        }
      } catch (e) {
        debugPrint('❌ Erro ao acessar usuário local: $e');
        return const LoginScreen();
      }
    }

    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Treinos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: FutureBuilder<Widget>(
        future: _decideStartScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return snapshot.data ?? const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainMenuScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
