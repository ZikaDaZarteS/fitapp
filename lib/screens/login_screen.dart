import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../widgets/login_text_field.dart';
import '../widgets/social_login_button.dart';
import '../widgets/google_login_button.dart';
import '../widgets/login_separator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _authController.checkFirebaseAuth();
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> _login() async {
    await _authController.loginWithEmailPassword(
      email: emailController.text,
      password: senhaController.text,
      context: context,
      onLoadingChanged: _toggleLoading,
    );
  }

  Future<void> _signInWithGoogle() async {
    await _authController.signInWithGoogle(
      context: context,
      onLoadingChanged: _toggleLoading,
    );
  }

  Future<void> _signInWithApple() async {
    await _authController.signInWithApple(
      context: context,
      onLoadingChanged: _toggleLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Foto de fundo
          Image.asset('assets/images/dumbbells_bg.jpg', fit: BoxFit.cover),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.5)),

          // Conteúdo
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Título
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Campo Email
                      LoginTextField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'seu@email.com',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: Icons.info_outline,
                      ),
                      const SizedBox(height: 16),

                      // Campo Senha
                      LoginTextField(
                        controller: senhaController,
                        label: 'Senha',
                        hint: 'Digite sua senha',
                        icon: Icons.lock,
                        keyboardType: TextInputType.text,
                        obscureText: _obscurePassword,
                        suffixIcon: _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSuffixTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botão Entrar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Entrar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Separador
                      const LoginSeparator(),
                      const SizedBox(height: 24),

                      // Botões de login social (lado a lado)
                      Row(
                        children: [
                          Expanded(
                            child: GoogleLoginButton(
                              onPressed: _isLoading ? null : _signInWithGoogle,
                              text: 'Entrar com Google',
                              backgroundColor: Colors.transparent,
                              textColor: Colors.white,
                              borderColor: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SocialLoginButton(
                              onPressed: _isLoading ? null : _signInWithApple,
                              icon: Icons.apple,
                              text: 'Entrar com Apple',
                              backgroundColor: Colors.transparent,
                              textColor: Colors.white,
                              borderColor: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Link Esqueci minha senha
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // Implementar recuperação de senha
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Funcionalidade em desenvolvimento',
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Esqueci minha senha',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Link Criar conta
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não tem uma conta? ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Implementar navegação para tela de registro
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Funcionalidade em desenvolvimento',
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Criar conta',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
