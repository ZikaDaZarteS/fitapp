import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../db/firestore_helper.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout? workout;

  const WorkoutDetailScreen({this.workout, super.key});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late TextEditingController _titleController;
  String? selectedCategory;

  final categories = ['Força', 'Cardio', 'Flexibilidade'];
  final firestoreHelper = FirestoreHelper();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.workout?.title ?? '');
    selectedCategory = widget.workout?.category ?? categories[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título não pode ficar vazio')),
      );
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma categoria')));
      return;
    }

    final workout = Workout(
      firestoreId: widget.workout?.firestoreId,
      title: title,
      category: selectedCategory!,
    );

    try {
      if (workout.firestoreId == null) {
        await firestoreHelper.addWorkout(workout);
      } else {
        await firestoreHelper.updateWorkout(workout);
      }

      if (!mounted) return;
      Navigator.pop(context, workout);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar treino: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'Novo treino' : 'Editar treino'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Categoria'),
              value: selectedCategory,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedCategory = val;
                  });
                }
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
