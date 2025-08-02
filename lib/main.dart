import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'firebase_options.dart';
import 'package:fitapp/db/database_helper.dart' as db_helper;
import 'package:fitapp/models/user.dart' as local_user;

import 'package:fitapp/screens/login_screen.dart';
import 'package:fitapp/screens/main_menu_screen.dart';
import 'package:fitapp/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('🚀 Iniciando Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase inicializado com sucesso');

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _decideStartScreen() async {
    final db = db_helper.DatabaseHelper();
    final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      try {
        final localUser = await db.getUser();
        if (localUser != null) {
          debugPrint('👤 Usuário local encontrado: ${localUser.email}');
          // Verificar se precisa completar perfil (altura, peso, objetivo, etc.)
          if (localUser.height == 0 && localUser.weight == 0) {
            return const OnboardingScreen();
          }
          return const MainMenuScreen();
        } else {
          await db.upsertUser(
            // <== aqui está o ajuste!
            local_user.User(
              id: firebaseUser.uid,
              name: '',
              email: firebaseUser.email ?? '',
              height: 0,
              weight: 0,
              age: 0,
            ),
          );
          debugPrint('📥 Usuário salvo localmente via Firebase');
          return const OnboardingScreen();
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
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Erro ao carregar o app: ${snapshot.error}'),
                ),
              );
            }
            return snapshot.data ?? const LoginScreen();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
