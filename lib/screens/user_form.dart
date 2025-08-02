import 'package:flutter/material.dart';
import 'package:fitapp/db/database_helper.dart'; // Corrigir o caminho conforme sua estrutura
import 'package:fitapp/models/user.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _goal = 'Emagrecer';
  String _level = 'Iniciante';
  String _time = '30';

  final List<String> _goalOptions = [
    'Emagrecer',
    'Ganhar massa',
    'Manter forma',
    'Melhorar condicionamento',
  ];
  final List<String> _levelOptions = ['Iniciante', 'Intermediário', 'Avançado'];
  final List<String> _timeOptions = ['15', '30', '45', '60', '90'];
  final List<String> _equipmentOptions = [
    'Peso livre',
    'Máquinas',
    'Elásticos',
    'Corpo livre',
    'Cardio',
  ];
  final List<String> _equipments = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _dbHelper.getUser();
    if (user != null) {
      setState(() {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _heightController.text = user.height.toString();
        _weightController.text = user.weight.toString();
        _goal = user.goal ?? 'Emagrecer';
        _level = user.level ?? 'Iniciante';
        _time = user.time ?? '30';
        if (user.equipments != null) {
          _equipments.clear();
          _equipments.addAll(user.equipments!.split(','));
        }
      });
    }
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: null,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        height: double.tryParse(_heightController.text) ?? 0.0,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        age: 0,
        goal: _goal,
        level: _level,
        time: _time,
        equipments: _equipments.join(','),
      );
      await _dbHelper.upsertUser(user);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Seção: Dados Básicos
              const Text(
                'Dados Básicos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o email';
                  if (!value.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Seção: Medidas
              const Text(
                'Medidas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Altura (cm)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a altura';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Altura inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Peso (kg)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o peso';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Peso inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Seção: Objetivos
              const Text(
                'Objetivos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _goal,
                decoration: const InputDecoration(labelText: 'Objetivo'),
                items: _goalOptions
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _goal = val ?? 'Emagrecer'),
              ),
              DropdownButtonFormField<String>(
                value: _level,
                decoration: const InputDecoration(labelText: 'Nível'),
                items: _levelOptions
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (val) => setState(() => _level = val ?? 'Iniciante'),
              ),
              const SizedBox(height: 16),

              // Seção: Preferências
              const Text(
                'Preferências',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _time,
                decoration: const InputDecoration(
                  labelText: 'Tempo disponível (min)',
                ),
                items: _timeOptions
                    .map(
                      (t) =>
                          DropdownMenuItem(value: t, child: Text('$t minutos')),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _time = val ?? '30'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Equipamentos disponíveis:',
                style: TextStyle(fontSize: 14),
              ),
              ..._equipmentOptions.map(
                (equip) => CheckboxListTile(
                  title: Text(equip),
                  value: _equipments.contains(equip),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _equipments.add(equip);
                      } else {
                        _equipments.remove(equip);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Salvar Perfil',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
