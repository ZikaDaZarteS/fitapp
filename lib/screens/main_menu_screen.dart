import 'package:flutter/material.dart';
import 'package:fitapp/screens/dashboard_screen.dart';
import 'package:fitapp/screens/home_screen.dart';
import 'package:fitapp/screens/friends_screen.dart';
import 'package:fitapp/screens/user_form.dart';
import 'package:fitapp/screens/subscription_screen.dart';
import 'package:fitapp/screens/smartwatch_integration_screen.dart';
import 'package:fitapp/screens/progress_report_screen.dart';
import 'package:fitapp/screens/clubs_screen.dart';
import 'package:fitapp/screens/scoring_mode_screen.dart';
import 'package:fitapp/screens/start_screen.dart';
import 'package:fitapp/screens/rat_evolution_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/db/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HomeScreen(),
    const FriendsScreen(),
    const _MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF6B35),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Amigos'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Mais'),
        ],
      ),
    );
  }
}

class _ScreenWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const _ScreenWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: child,
    );
  }
}

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking de Check-ins')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Ranking de Check-ins',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Funcionalidade em desenvolvimento',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreScreen extends StatefulWidget {
  const _MoreScreen();

  @override
  State<_MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<_MoreScreen> {
  String? _selectedImagePath;
  String? _profilePhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedImagePath = prefs.getString('profile_photo_path');
      _profilePhotoUrl = prefs.getString('profile_photo_url');
    });
  }

  Future<void> _saveProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedImagePath != null) {
      await prefs.setString('profile_photo_path', _selectedImagePath!);
    }
    if (_profilePhotoUrl != null) {
      await prefs.setString('profile_photo_url', _profilePhotoUrl!);
    }
  }

  Future<void> _uploadToFirebaseStorage(String filePath) async {
    try {
      final file = File(filePath);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _profilePhotoUrl = downloadUrl;
      });

      await _saveProfilePhoto();
    } catch (e) {
      debugPrint('Erro ao fazer upload: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImagePath = pickedFile.path;
        });

        await _saveProfilePhoto();
        await _uploadToFirebaseStorage(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com gradiente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF667eea),
                    Color(0xFF764ba2),
                  ], // Gradiente azul/roxo
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Avatar clicável
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: _selectedImagePath != null
                              ? (kIsWeb
                                    ? null // Para web, Image.network é usado diretamente
                                    : FileImage(File(_selectedImagePath!)))
                              : null,
                          child:
                              _selectedImagePath == null &&
                                  _profilePhotoUrl == null
                              ? const Text(
                                  'DA',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DIEGO AMANCIO RIBEIRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'diegoribeiro359@gmail.com',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Opções em cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildOptionCard(
                    icon: Icons.star,
                    title: 'Assinatura',
                    description: 'Planos premium com benefícios exclusivos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubscriptionScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: Icons.group,
                    title: 'Clubes',
                    description: 'Participe de grupos e desafios',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClubsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: Icons.settings,
                    title: 'Criar Grupo/Desafio',
                    description: 'Organize competições e desafios',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScoringModeScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: Icons.psychology,
                    title: 'Evolução do Rato',
                    description: 'Veja sua evolução e progresso',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RatEvolutionScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: Icons.bar_chart,
                    title: 'Relatórios de Progresso',
                    description: 'Acompanhe seus resultados',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProgressReportScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: Icons.watch,
                    title: 'Integração com Smartwatch',
                    description: 'Conecte seu dispositivo',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SmartwatchIntegrationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionCard(
                    icon: Icons.logout,
                    title: 'Sair',
                    description: 'Encerrar sessão e sair do aplicativo',
                    onTap: () async {
                      debugPrint('🔄 Botão Sair pressionado');
                      try {
                        // Mostrar loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saindo...'),
                            backgroundColor: Colors.blue,
                            duration: Duration(seconds: 1),
                          ),
                        );

                        debugPrint('🔥 Fazendo logout do Firebase...');
                        // Fazer logout do Firebase
                        await FirebaseAuth.instance.signOut();
                        debugPrint('✅ Logout do Firebase realizado');

                        if (!context.mounted) return;

                        debugPrint('🗄️ Limpando dados locais...');
                        // Limpar dados locais
                        final db = DatabaseHelper();
                        await db.clearUser();
                        debugPrint('✅ Dados locais limpos');

                        if (!context.mounted) return;

                        debugPrint('🔄 Navegando para tela de login...');
                        // Navegar para login e limpar stack
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (route) => false);
                        debugPrint('✅ Navegação concluída');
                      } catch (e) {
                        debugPrint('❌ Erro ao sair: $e');
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao sair: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: () {
          debugPrint('🖱️ Card "$title" pressionado');
          onTap();
        },
      ),
    );
  }
}
