import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/models/user.dart' as app_user;

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addFriendController = TextEditingController();
  List<app_user.User> _friends = [];
  List<app_user.User> _searchResults = [];
  final bool _isLoading = false;
  final bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addFriendController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    try {
      // Simular carregamento de amigos
      setState(() {
        _friends = [
          app_user.User(
            id: '1',
            name: 'João Silva',
            email: 'joao@email.com',
            height: 175.0,
            weight: 70.0,
            age: 25,
          ),
          app_user.User(
            id: '2',
            name: 'Maria Santos',
            email: 'maria@email.com',
            height: 165.0,
            weight: 60.0,
            age: 28,
          ),
          app_user.User(
            id: '3',
            name: 'Pedro Costa',
            email: 'pedro@email.com',
            height: 180.0,
            weight: 75.0,
            age: 30,
          ),
        ];
      });
    } catch (e) {
      debugPrint('❌ Erro ao carregar amigos: $e');
    }
  }

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    try {
      // Simular busca de usuários
      final allUsers = [
        app_user.User(
          id: '1',
          name: 'João Silva',
          email: 'joao@email.com',
          height: 175.0,
          weight: 70.0,
          age: 25,
        ),
        app_user.User(
          id: '2',
          name: 'Maria Santos',
          email: 'maria@email.com',
          height: 165.0,
          weight: 60.0,
          age: 28,
        ),
        app_user.User(
          id: '3',
          name: 'Pedro Costa',
          email: 'pedro@email.com',
          height: 180.0,
          weight: 75.0,
          age: 30,
        ),
      ];

      final filteredUsers = allUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(query.toLowerCase()) ||
                user.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      setState(() {
        _searchResults = filteredUsers;
      });
    } catch (e) {
      debugPrint('❌ Erro ao buscar usuários: $e');
    }
  }

  Future<void> _addFriend(String friendId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Simular adição de amigo (em um app real, isso seria feito no Firestore)
      final newFriend = app_user.User(
        id: friendId,
        name: 'Amigo Adicionado',
        email: 'amigo@example.com',
        height: 170,
        weight: 70,
        age: 25,
      );

      setState(() {
        _friends.add(newFriend);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amigo adicionado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar amigo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Adicionar Amigo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _addFriendController,
              decoration: InputDecoration(
                hintText: 'Digite o email do amigo',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addFriendController.clear();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_addFriendController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Solicitação de amizade enviada!'),
                    backgroundColor: Colors.black,
                  ),
                );
                _addFriendController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Digite um email válido'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Adicionar Amigo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Barra de pesquisa com botão de adicionar amigo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Barra de pesquisa reduzida (apenas ícone)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar usuários...',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: _searchUsers,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Botão de adicionar amigo
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _showAddFriendDialog,
                    icon: const Icon(Icons.add, color: Colors.white, size: 24),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Resultados da busca
          if (_searchResults.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Usuários encontrados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return _buildUserCard(user, isSearchResult: true);
                },
              ),
            ),
          ] else if (_searchController.text.isNotEmpty) ...[
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum usuário encontrado',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Lista de amigos
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Seus amigos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _friends.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum amigo ainda',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Adicione amigos para ver seus treinos!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom:
                            100, // Adicionar padding inferior para evitar overflow
                      ),
                      itemCount: _friends.length,
                      itemBuilder: (context, index) {
                        final friend = _friends[index];
                        return _buildUserCard(friend, isSearchResult: false);
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserCard(app_user.User user, {required bool isSearchResult}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            user.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        subtitle: Text(user.email, style: const TextStyle(color: Colors.grey)),
        trailing: isSearchResult
            ? ElevatedButton(
                onPressed: () => _addFriend(user.id ?? ''),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Adicionar'),
              )
            : const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: isSearchResult
            ? null
            : () {
                _showFriendProfile(user);
              },
      ),
    );
  }

  void _showFriendProfile(app_user.User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Perfil de ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Nome: ${user.name}'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text('Email: ${user.email}'),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text('Altura: ${user.height} cm'),
            ),
            ListTile(
              leading: const Icon(Icons.scale),
              title: Text('Peso: ${user.weight} kg'),
            ),
            ListTile(
              leading: const Icon(Icons.cake),
              title: Text('Idade: ${user.age} anos'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
