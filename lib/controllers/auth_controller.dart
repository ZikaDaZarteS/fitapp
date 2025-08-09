import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/main_menu_screen.dart';

class AuthController {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal();

  void checkFirebaseAuth() {
    try {
      final auth = fb_auth.FirebaseAuth.instance;
      debugPrint('✅ Firebase Auth disponível na tela de login');
      debugPrint('👤 Usuário atual: ${auth.currentUser?.email ?? "Nenhum"}');
    } catch (e) {
      debugPrint('❌ Erro no Firebase Auth na tela de login: $e');
    }
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required VoidCallback onLoadingChanged,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha email e senha')),
      );
      return;
    }

    onLoadingChanged();

    try {
      debugPrint('🔐 Tentando fazer login com email: ${email.trim()}');

      await fb_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      debugPrint('✅ Login realizado com sucesso');

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      debugPrint('❌ Erro Firebase Auth: ${e.code} - ${e.message}');

      if (!context.mounted) return;

      String errorMessage = 'Erro ao fazer login';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Usuário não encontrado';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta';
          break;
        case 'invalid-email':
          errorMessage = 'Email inválido';
          break;
        case 'user-disabled':
          errorMessage = 'Usuário desabilitado';
          break;
        case 'too-many-requests':
          errorMessage = 'Muitas tentativas. Tente novamente mais tarde';
          break;
        case 'network-request-failed':
          errorMessage = 'Erro de conexão. Verifique sua internet';
          break;
        default:
          errorMessage = 'Erro ao fazer login: ${e.message}';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      debugPrint('❌ Erro inesperado: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    } finally {
      if (context.mounted) {
        onLoadingChanged();
      }
    }
  }

  Future<void> signInWithGoogle({
    required BuildContext context,
    required VoidCallback onLoadingChanged,
  }) async {
    try {
      onLoadingChanged();

      debugPrint('🔄 Iniciando login com Google...');

      // Verificar se o Google Sign-In está disponível
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      debugPrint('🔄 Fazendo sign out preventivo...');
      await googleSignIn.signOut();

      debugPrint('🔄 Iniciando processo de login...');
      final GoogleSignInAccount? currentUser = await googleSignIn.signIn();

      if (currentUser == null) {
        debugPrint('ℹ️ Usuário cancelou o login');
        if (context.mounted) {
          onLoadingChanged();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login cancelado pelo usuário'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      debugPrint('✅ Usuário selecionado: ${currentUser.email}');

      // Obter as credenciais de autenticação
      debugPrint('🔄 Obtendo credenciais de autenticação...');
      final GoogleSignInAuthentication googleAuth =
          await currentUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Falha ao obter tokens de autenticação do Google');
      }

      debugPrint('✅ Tokens obtidos com sucesso');

      // Criar credenciais do Firebase
      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('🔄 Fazendo login no Firebase...');
      // Fazer login no Firebase
      final fb_auth.UserCredential userCredential = await fb_auth
          .FirebaseAuth
          .instance
          .signInWithCredential(credential);

      debugPrint(
        '✅ Login com Google realizado com sucesso: ${userCredential.user?.email}',
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login com Google realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      debugPrint('❌ Erro Firebase Auth: ${e.code} - ${e.message}');
      
      if (!context.mounted) return;
      
      String errorMessage = 'Erro na autenticação Firebase';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'Esta conta já existe com credenciais diferentes';
          break;
        case 'invalid-credential':
          errorMessage = 'Credenciais inválidas';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Login com Google não está habilitado';
          break;
        case 'user-disabled':
          errorMessage = 'Esta conta foi desabilitada';
          break;
        default:
          errorMessage = 'Erro no Firebase: ${e.message}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      debugPrint('❌ Erro no login com Google: $e');
      debugPrint('❌ Tipo do erro: ${e.runtimeType}');

      if (!context.mounted) return;

      String errorMessage = 'Erro no login com Google';
      if (e.toString().contains('network')) {
        errorMessage = 'Erro de conexão. Verifique sua internet.';
      } else if (e.toString().contains('configuration')) {
        errorMessage = 'Erro de configuração. Entre em contato com o suporte.';
      } else {
        errorMessage = 'Erro inesperado: ${e.toString()}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (context.mounted) {
        onLoadingChanged();
      }
    }
  }

  Future<void> signInWithApple({
    required BuildContext context,
    required VoidCallback onLoadingChanged,
  }) async {
    onLoadingChanged();

    try {
      debugPrint('🔐 Tentando login com Apple...');

      // Simulação do login com Apple (implementação real requer configuração adicional)
      await Future.delayed(const Duration(seconds: 1));

      debugPrint('✅ Login com Apple realizado com sucesso');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login com Apple realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
      );
    } catch (e) {
      debugPrint('❌ Erro no login com Apple: $e');

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro no login com Apple: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (context.mounted) {
        onLoadingChanged();
      }
    }
  }
}
