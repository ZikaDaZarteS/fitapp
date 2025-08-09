import 'package:flutter/material.dart';
import 'package:fitapp/db/database_helper.dart';
import 'package:fitapp/models/user.dart' as app_user;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'notification_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  app_user.User? _currentUser;

  // Controllers para edição
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Links sociais
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();

  // Estados de visibilidade das senhas
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  // Estados de conexão social
  bool _instagramConnected = false;
  bool _tiktokConnected = false;
  bool _twitterConnected = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSocialLinks();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await _dbHelper.getUser();
    if (user != null) {
      setState(() {
        _currentUser = user;
        _nameController.text = user.name;
        _emailController.text = user.email;
      });
    }
  }

  Future<void> _loadSocialLinks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _instagramController.text = prefs.getString('instagram_link') ?? '';
      _tiktokController.text = prefs.getString('tiktok_link') ?? '';
      _twitterController.text = prefs.getString('twitter_link') ?? '';

      _instagramConnected = prefs.getBool('instagram_connected') ?? false;
      _tiktokConnected = prefs.getBool('tiktok_connected') ?? false;
      _twitterConnected = prefs.getBool('twitter_connected') ?? false;
    });
  }

  Future<void> _saveSocialLinks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('instagram_link', _instagramController.text);
    await prefs.setString('tiktok_link', _tiktokController.text);
    await prefs.setString('twitter_link', _twitterController.text);

    // Salvar estados de conexão
    await prefs.setBool('instagram_connected', _instagramConnected);
    await prefs.setBool('tiktok_connected', _tiktokConnected);
    await prefs.setBool('twitter_connected', _twitterConnected);
  }

  Future<void> _launchUrl(String url) async {
    if (url.isNotEmpty) {
      final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Senha atual',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => setState(
                      () => _showCurrentPassword = !_showCurrentPassword,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  labelText: 'Nova senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _showNewPassword = !_showNewPassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirmar nova senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => setState(
                      () => _showConfirmPassword = !_showConfirmPassword,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de alteração de senha
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Senha alterada com sucesso!')),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção: Informações Pessoais
            _buildSectionTitle('Informações Pessoais', Icons.person),
            const SizedBox(height: 12),
            _buildInfoCard(
              title: 'Nome',
              value: _currentUser?.name ?? 'Não definido',
              icon: Icons.person_outline,
              onTap: () {
                // Implementar edição de nome
              },
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Email',
              value: _currentUser?.email ?? 'Não definido',
              icon: Icons.email_outlined,
              onTap: () {
                // Implementar edição de email
              },
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Senha',
              value: '••••••••',
              icon: Icons.lock_outline,
              onTap: _showPasswordChangeDialog,
            ),

            const SizedBox(height: 24),

            // Seção: Links Sociais
            _buildSectionTitle('Links Sociais', Icons.share),
            const SizedBox(height: 12),
            _buildSocialCard(
              platform: 'Instagram',
              controller: _instagramController,
              color: const Color(0xFFE4405F),
              isConnected: _instagramConnected,
              onConnect: () {
                setState(() {
                  _instagramConnected = !_instagramConnected;
                  if (_instagramConnected &&
                      _instagramController.text.isEmpty) {
                    _instagramController.text = 'instagram.com/';
                  } else if (!_instagramConnected) {
                    _instagramController.text = '';
                  }
                });
                _saveSocialLinks();
              },
              onLaunch: () => _launchUrl(_instagramController.text),
            ),
            const SizedBox(height: 8),
            _buildSocialCard(
              platform: 'TikTok',
              controller: _tiktokController,
              color: const Color(0xFF000000),
              isConnected: _tiktokConnected,
              onConnect: () {
                setState(() {
                  _tiktokConnected = !_tiktokConnected;
                  if (_tiktokConnected && _tiktokController.text.isEmpty) {
                    _tiktokController.text = 'tiktok.com/@';
                  } else if (!_tiktokConnected) {
                    _tiktokController.text = '';
                  }
                });
                _saveSocialLinks();
              },
              onLaunch: () => _launchUrl(_tiktokController.text),
            ),
            const SizedBox(height: 8),
            _buildSocialCard(
              platform: 'X (Twitter)',
              controller: _twitterController,
              color: const Color(0xFF1DA1F2),
              isConnected: _twitterConnected,
              onConnect: () {
                setState(() {
                  _twitterConnected = !_twitterConnected;
                  if (_twitterConnected && _twitterController.text.isEmpty) {
                    _twitterController.text = 'twitter.com/';
                  } else if (!_twitterConnected) {
                    _twitterController.text = '';
                  }
                });
                _saveSocialLinks();
              },
              onLaunch: () => _launchUrl(_twitterController.text),
            ),

            const SizedBox(height: 24),

            // Seção: Configurações Avançadas
            _buildSectionTitle('Configurações Avançadas', Icons.settings),
            const SizedBox(height: 12),
            _buildAdvancedCard(
              title: 'Notificações',
              subtitle: 'Gerenciar alertas e lembretes',
              icon: Icons.notifications_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildAdvancedCard(
              title: 'Privacidade',
              subtitle: 'Configurar visibilidade do perfil',
              icon: Icons.security_outlined,
              onTap: () {
                // Implementar configurações de privacidade
              },
            ),
            const SizedBox(height: 8),
            _buildAdvancedCard(
              title: 'Backup e Sincronização',
              subtitle: 'Sincronizar dados entre dispositivos',
              icon: Icons.cloud_sync_outlined,
              onTap: () {
                // Implementar backup
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF667eea), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF667eea), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.edit_outlined, color: Colors.grey),
        onTap: () {
          if (title == 'Nome') {
            _showEditDialog('Nome', _nameController, (newValue) async {
              final updatedUser = _currentUser?.copyWith(name: newValue);
              if (updatedUser != null) {
                final result = await _dbHelper.updateUserName(newValue);
                if (result > 0) {
                  setState(() {
                    _currentUser = updatedUser;
                  });
                }
              }
            });
          } else if (title == 'Email') {
            _showEditDialog('Email', _emailController, (newValue) async {
              final updatedUser = _currentUser?.copyWith(email: newValue);
              if (updatedUser != null) {
                final result = await _dbHelper.updateUserEmail(newValue);
                if (result > 0) {
                  setState(() {
                    _currentUser = updatedUser;
                  });
                }
              }
            });
          } else {
            onTap();
          }
        },
      ),
    );
  }

  void _showEditDialog(
    String title,
    TextEditingController controller,
    Function(String) onSave,
  ) {
    controller.text = title == 'Nome'
        ? (_currentUser?.name ?? '')
        : (_currentUser?.email ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            hintText: 'Digite seu $title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                await onSave(newValue);
                if (mounted) {
                  navigator.pop();
                  messenger.showSnackBar(
                    SnackBar(content: Text('$title atualizado com sucesso!')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title não pode estar vazio!')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCard({
    required String platform,
    required TextEditingController controller,
    required Color color,
    required bool isConnected,
    required VoidCallback onConnect,
    required VoidCallback onLaunch,
  }) {
    String getSvgPath() {
      switch (platform.toLowerCase()) {
        case 'instagram':
          return 'assets/images/instagram_icon.svg';
        case 'tiktok':
          return 'assets/images/tiktok_icon.svg';
        case 'x (twitter)':
        case 'twitter':
          return 'assets/images/twitter_icon.svg';
        default:
          return 'assets/images/instagram_icon.svg';
      }
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isConnected ? color : Colors.grey.withValues(alpha: 0.2),
          width: isConnected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            getSvgPath(),
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
        title: Text(
          platform,
          style: const TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          isConnected ? controller.text : 'Não conectado',
          style: TextStyle(
            color: isConnected ? Colors.grey[600] : Colors.grey,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isConnected && controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.open_in_new,
                  color: Colors.grey,
                  size: 18,
                ),
                onPressed: onLaunch,
              ),
            Switch(
              value: isConnected,
              onChanged: (value) => onConnect(),
              activeColor: color,
            ),
          ],
        ),
        onTap: () {
          if (isConnected) {
            _showSocialLinkDialog(platform, controller);
          } else {
            onConnect();
          }
        },
      ),
    );
  }

  Widget _buildAdvancedCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF667eea), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showSocialLinkDialog(
    String platform,
    TextEditingController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar $platform'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'URL do $platform',
            hintText: 'Digite sua URL do $platform',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveSocialLinks();
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
