import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseTest {
  static Future<bool> testConnection() async {
    try {
      debugPrint('🧪 Testando conexão com Firebase...');

      final auth = FirebaseAuth.instance;
      debugPrint('✅ Firebase Auth disponível');

      // Teste de configuração
      final currentUser = auth.currentUser;
      debugPrint('👤 Usuário atual: ${currentUser?.email ?? "Nenhum"}');

      // Teste de configuração do projeto
      final app = auth.app;
      debugPrint('📱 App configurado: ${app.name}');
      debugPrint('🔑 Projeto ID: ${app.options.projectId}');

      return true;
    } catch (e) {
      debugPrint('❌ Erro no teste do Firebase: $e');
      return false;
    }
  }

  static Future<bool> testAuthMethod() async {
    try {
      debugPrint('🔐 Testando método de autenticação...');

      final auth = FirebaseAuth.instance;

      // Lista métodos disponíveis
      // Verificar se Email/Password está habilitado
      try {
        await auth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'test123',
        );
      } catch (e) {
        // Se der erro de usuário não encontrado, significa que Email/Password está habilitado
        if (e.toString().contains('user-not-found')) {
          debugPrint('✅ Email/Password está habilitado');
        } else {
          debugPrint('❌ Email/Password pode não estar habilitado');
        }
      }
      debugPrint('📋 Teste de Email/Password concluído');

      return true;
    } catch (e) {
      debugPrint('❌ Erro no teste de autenticação: $e');
      return false;
    }
  }

  static void printConfig() {
    debugPrint('📋 Configuração do Firebase:');
    debugPrint('- Projeto: academia-173e0');
    debugPrint('- Auth Domain: academia-173e0.firebaseapp.com');
    debugPrint('- Storage Bucket: academia-173e0.appspot.com');
    debugPrint('- API Key Android: AIzaSyBnfupeGpyziAikPPcmw6acspzMr33Efbc');
    debugPrint('- API Key Web: AIzaSyCP5fEvPOelMJLOIJ58rO6PkIMBIAKvhsA');
  }
}
