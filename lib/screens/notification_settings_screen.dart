import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _checkInNotifications = true;
  bool _commentNotifications = true;
  bool _reactionNotifications = true;
  bool _chatNotifications = true;
  bool _challengeUpdates = true;
  bool _workoutReminders = true;
  bool _weeklyReports = false;
  bool _friendActivity = true;
  
  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _checkInNotifications = prefs.getBool('check_in_notifications') ?? true;
      _commentNotifications = prefs.getBool('comment_notifications') ?? true;
      _reactionNotifications = prefs.getBool('reaction_notifications') ?? true;
      _chatNotifications = prefs.getBool('chat_notifications') ?? true;
      _challengeUpdates = prefs.getBool('challenge_updates') ?? true;
      _workoutReminders = prefs.getBool('workout_reminders') ?? true;
      _weeklyReports = prefs.getBool('weekly_reports') ?? false;
      _friendActivity = prefs.getBool('friend_activity') ?? true;
    });
  }

  Future<void> _saveNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('check_in_notifications', _checkInNotifications);
    await prefs.setBool('comment_notifications', _commentNotifications);
    await prefs.setBool('reaction_notifications', _reactionNotifications);
    await prefs.setBool('chat_notifications', _chatNotifications);
    await prefs.setBool('challenge_updates', _challengeUpdates);
    await prefs.setBool('workout_reminders', _workoutReminders);
    await prefs.setBool('weekly_reports', _weeklyReports);
    await prefs.setBool('friend_activity', _friendActivity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notificações via push',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Defina as configurações de notificação por push.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildNotificationTile(
              'Check-in',
              'Quando alguém registra uma check-in.',
              _checkInNotifications,
              (value) {
                setState(() {
                  _checkInNotifications = value;
                });
                _saveNotificationSettings();
              },
            ),
            
            _buildNotificationTile(
              'Comente',
              'Quando alguém comenta sobre sua check-in.',
              _commentNotifications,
              (value) {
                setState(() {
                  _commentNotifications = value;
                });
                _saveNotificationSettings();
              },
            ),
            
            _buildNotificationTile(
              'Reação',
              'Quando alguém reage à sua check-in.',
              _reactionNotifications,
              (value) {
                setState(() {
                  _reactionNotifications = value;
                });
                _saveNotificationSettings();
              },
            ),
            
            _buildNotificationTile(
              'Mensagem de bate-papo',
              'Quando alguém envia uma mensagem para o chat em grupo.',
              _chatNotifications,
              (value) {
                setState(() {
                  _chatNotifications = value;
                });
                _saveNotificationSettings();
              },
            ),
            
            _buildNotificationTile(
              'Atualizações dos vencedores',
              'Anúncios regulares de vencedores para conquistas semanais e mensais.',
              _challengeUpdates,
              (value) {
                setState(() {
                  _challengeUpdates = value;
                });
                _saveNotificationSettings();
              },
            ),
            
            _buildNotificationTile(
              'Lembretes de Treino',
              'Receba lembretes para não perder seus treinos.',
              _workoutReminders,
              (value) {
                setState(() {
                  _workoutReminders = value;
                });
                _saveNotificationSettings();
              },
            ),
            
            _buildNotificationTile(
              'Relatórios Semanais',
              'Resumo semanal do seu progresso e atividades.',
              _weeklyReports,
              (value) {
                setState(() {
                  _weeklyReports = value;
                });
                _saveNotificationSettings();
              },
            ),
            
            _buildNotificationTile(
              'Atividade de Amigos',
              'Quando seus amigos fazem check-in ou completam desafios.',
              _friendActivity,
              (value) {
                setState(() {
                  _friendActivity = value;
                });
                _saveNotificationSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.grey[600],
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[800],
          ),
        ],
      ),
    );
  }
}