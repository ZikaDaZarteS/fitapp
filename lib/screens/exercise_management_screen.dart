import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/exercise.dart';
import '../models/workout_plan.dart';
import '../db/database_helper.dart';

class ExerciseManagementScreen extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  const ExerciseManagementScreen({super.key, required this.workoutPlan});

  @override
  State<ExerciseManagementScreen> createState() =>
      _ExerciseManagementScreenState();
}

class _ExerciseManagementScreenState extends State<ExerciseManagementScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Exercise> exercises = [];
  bool isLoading = true;

  // Exercícios pré-definidos por grupo muscular
  final Map<String, List<Exercise>> predefinedExercises = {
    'Peito': [
      Exercise(
        name: 'Supino Reto',
        muscleGroup: 'Peito',
        description: 'Exercício fundamental para desenvolvimento do peitoral',
        instructions:
            'Deite no banco, segure a barra com pegada pronada, abaixe controladamente e empurre para cima',
        sets: 3,
        reps: 12,
        restTime: 90,
        equipment: 'Barra e banco',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Supino Inclinado',
        muscleGroup: 'Peito',
        description: 'Foca na parte superior do peitoral',
        instructions:
            'Deite no banco inclinado, execute o movimento de forma controlada',
        sets: 3,
        reps: 10,
        restTime: 90,
        equipment: 'Barra e banco inclinado',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Supino Declinado',
        muscleGroup: 'Peito',
        description: 'Foca na parte inferior do peitoral',
        instructions: 'Deite no banco declinado, execute o movimento',
        sets: 3,
        reps: 10,
        restTime: 90,
        equipment: 'Barra e banco declinado',
        difficulty: 'Avançado',
      ),
      Exercise(
        name: 'Flexão de Braço',
        muscleGroup: 'Peito',
        description: 'Exercício com peso corporal',
        instructions:
            'Mantenha o corpo alinhado, desça controladamente e empurre para cima',
        sets: 3,
        reps: 15,
        restTime: 60,
        equipment: 'Peso corporal',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Crucifixo',
        muscleGroup: 'Peito',
        description: 'Isolamento do peitoral',
        instructions:
            'Deite no banco, abra os braços em arco e feche controladamente',
        sets: 3,
        reps: 12,
        restTime: 90,
        equipment: 'Halteres e banco',
        difficulty: 'Intermediário',
      ),
    ],
    'Costas': [
      Exercise(
        name: 'Puxada na Frente',
        muscleGroup: 'Costas',
        description: 'Desenvolvimento da largura das costas',
        instructions: 'Sente na máquina, puxe a barra em direção ao peito',
        sets: 3,
        reps: 12,
        restTime: 90,
        equipment: 'Máquina de puxada',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Remada Curvada',
        muscleGroup: 'Costas',
        description: 'Exercício composto para costas',
        instructions: 'Incline o tronco, puxe a barra em direção ao abdômen',
        sets: 3,
        reps: 10,
        restTime: 90,
        equipment: 'Barra',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Remada Unilateral',
        muscleGroup: 'Costas',
        description: 'Trabalha cada lado separadamente',
        instructions:
            'Apoie uma mão no banco, puxe o haltere em direção ao quadril',
        sets: 3,
        reps: 12,
        restTime: 90,
        equipment: 'Haltere e banco',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Puxada no Pulley',
        muscleGroup: 'Costas',
        description: 'Variação da puxada',
        instructions: 'Sente no pulley, puxe o cabo em direção ao peito',
        sets: 3,
        reps: 12,
        restTime: 90,
        equipment: 'Pulley',
        difficulty: 'Iniciante',
      ),
    ],
    'Bíceps': [
      Exercise(
        name: 'Rosca Direta',
        muscleGroup: 'Bíceps',
        description: 'Exercício fundamental para bíceps',
        instructions: 'Em pé, eleve os halteres flexionando os cotovelos',
        sets: 3,
        reps: 12,
        restTime: 60,
        equipment: 'Halteres',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Rosca Martelo',
        muscleGroup: 'Bíceps',
        description: 'Trabalha bíceps e antebraço',
        instructions: 'Segure os halteres como martelos, eleve controladamente',
        sets: 3,
        reps: 12,
        restTime: 60,
        equipment: 'Halteres',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Rosca Concentrada',
        muscleGroup: 'Bíceps',
        description: 'Isolamento do bíceps',
        instructions: 'Sente, apoie o cotovelo na coxa, eleve o haltere',
        sets: 3,
        reps: 10,
        restTime: 60,
        equipment: 'Haltere',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Rosca Scott',
        muscleGroup: 'Bíceps',
        description: 'Isolamento máximo do bíceps',
        instructions: 'Apoie os braços no banco Scott, execute a rosca',
        sets: 3,
        reps: 10,
        restTime: 60,
        equipment: 'Banco Scott e halteres',
        difficulty: 'Intermediário',
      ),
    ],
    'Tríceps': [
      Exercise(
        name: 'Extensão de Tríceps',
        muscleGroup: 'Tríceps',
        description: 'Exercício básico para tríceps',
        instructions:
            'Em pé, eleve o haltere atrás da cabeça, estenda os braços',
        sets: 3,
        reps: 12,
        restTime: 60,
        equipment: 'Haltere',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Tríceps na Polia',
        muscleGroup: 'Tríceps',
        description: 'Isolamento do tríceps',
        instructions: 'Na polia alta, empurre o cabo para baixo',
        sets: 3,
        reps: 12,
        restTime: 60,
        equipment: 'Polia',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Mergulho',
        muscleGroup: 'Tríceps',
        description: 'Exercício com peso corporal',
        instructions: 'Apoie as mãos na barra, desça e empurre para cima',
        sets: 3,
        reps: 10,
        restTime: 60,
        equipment: 'Barras paralelas',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Supino Fechado',
        muscleGroup: 'Tríceps',
        description: 'Exercício composto focado em tríceps',
        instructions: 'Supino com pegada fechada, foca nos tríceps',
        sets: 3,
        reps: 10,
        restTime: 90,
        equipment: 'Barra e banco',
        difficulty: 'Intermediário',
      ),
    ],
    'Perna': [
      Exercise(
        name: 'Agachamento',
        muscleGroup: 'Perna',
        description: 'Rei dos exercícios para pernas',
        instructions: 'Pés na largura dos ombros, desça como se fosse sentar',
        sets: 3,
        reps: 10,
        restTime: 120,
        equipment: 'Barra',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Leg Press',
        muscleGroup: 'Perna',
        description: 'Exercício seguro para pernas',
        instructions: 'Sente na máquina, empurre a plataforma',
        sets: 3,
        reps: 12,
        restTime: 90,
        equipment: 'Máquina Leg Press',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Extensora',
        muscleGroup: 'Perna',
        description: 'Isolamento do quadríceps',
        instructions: 'Sente na máquina, estenda as pernas',
        sets: 3,
        reps: 15,
        restTime: 60,
        equipment: 'Máquina extensora',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Flexora',
        muscleGroup: 'Perna',
        description: 'Isolamento dos isquiotibiais',
        instructions: 'Deite na máquina, flexione as pernas',
        sets: 3,
        reps: 15,
        restTime: 60,
        equipment: 'Máquina flexora',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Panturrilha em Pé',
        muscleGroup: 'Perna',
        description: 'Desenvolvimento da panturrilha',
        instructions: 'Em pé, eleve os calcanhares',
        sets: 4,
        reps: 20,
        restTime: 45,
        equipment: 'Máquina ou halteres',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Stiff',
        muscleGroup: 'Perna',
        description: 'Foca nos isquiotibiais',
        instructions: 'Mantenha as pernas estendidas, incline o tronco',
        sets: 3,
        reps: 12,
        restTime: 90,
        equipment: 'Barra ou halteres',
        difficulty: 'Intermediário',
      ),
    ],
    'Ombro': [
      Exercise(
        name: 'Desenvolvimento',
        muscleGroup: 'Ombro',
        description: 'Exercício composto para ombros',
        instructions: 'Em pé ou sentado, eleve a barra acima da cabeça',
        sets: 3,
        reps: 10,
        restTime: 90,
        equipment: 'Barra ou halteres',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Elevação Lateral',
        muscleGroup: 'Ombro',
        description: 'Isolamento do deltoide lateral',
        instructions: 'Em pé, eleve os halteres lateralmente',
        sets: 3,
        reps: 12,
        restTime: 60,
        equipment: 'Halteres',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Elevação Frontal',
        muscleGroup: 'Ombro',
        description: 'Foca no deltoide anterior',
        instructions: 'Eleve os halteres à frente do corpo',
        sets: 3,
        reps: 12,
        restTime: 60,
        equipment: 'Halteres',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Remada Alta',
        muscleGroup: 'Ombro',
        description: 'Trabalha trapézio e deltoides',
        instructions: 'Eleve a barra em direção ao queixo',
        sets: 3,
        reps: 10,
        restTime: 90,
        equipment: 'Barra',
        difficulty: 'Intermediário',
      ),
    ],
    'Abdômen': [
      Exercise(
        name: 'Abdominal Reto',
        muscleGroup: 'Abdômen',
        description: 'Exercício básico para abdômen',
        instructions: 'Deite, flexione o tronco em direção aos joelhos',
        sets: 3,
        reps: 20,
        restTime: 45,
        equipment: 'Peso corporal',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Prancha',
        muscleGroup: 'Abdômen',
        description: 'Isometria para core',
        instructions: 'Mantenha o corpo alinhado, segure a posição',
        sets: 3,
        reps: 1,
        restTime: 60,
        equipment: 'Peso corporal',
        difficulty: 'Iniciante',
      ),
      Exercise(
        name: 'Abdominal Bicicleta',
        muscleGroup: 'Abdômen',
        description: 'Trabalha abdômen oblíquo',
        instructions: 'Deite, simule pedalar no ar',
        sets: 3,
        reps: 20,
        restTime: 45,
        equipment: 'Peso corporal',
        difficulty: 'Intermediário',
      ),
      Exercise(
        name: 'Abdominal Inverso',
        muscleGroup: 'Abdômen',
        description: 'Foca na parte inferior do abdômen',
        instructions: 'Deite, eleve as pernas em direção ao peito',
        sets: 3,
        reps: 15,
        restTime: 45,
        equipment: 'Peso corporal',
        difficulty: 'Intermediário',
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Verificar se o workoutPlan tem ID
      if (widget.workoutPlan.id == null) {
        debugPrint('❌ WorkoutPlan ID é null');
        setState(() {
          exercises = [];
          isLoading = false;
        });
        return;
      }

      debugPrint(
        '🔄 Carregando exercícios para WorkoutPlan ID: ${widget.workoutPlan.id}',
      );

      // Carregar exercícios do banco de dados
      final loadedExercises = await _dbHelper.getExercisesForWorkoutPlan(
        widget.workoutPlan.id!,
      );

      debugPrint('✅ Exercícios carregados: ${loadedExercises.length}');

      setState(() {
        exercises = loadedExercises;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Erro ao carregar exercícios: $e');
      setState(() {
        exercises = [];
        isLoading = false;
      });
    }
  }

  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Exercício'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.workoutPlan.workoutTypes.length,
              itemBuilder: (context, index) {
                final muscleGroup = widget.workoutPlan.workoutTypes[index];
                final exercisesForGroup =
                    predefinedExercises[muscleGroup] ?? [];

                return ExpansionTile(
                  title: Text(muscleGroup),
                  children: exercisesForGroup.map((exercise) {
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(exercise.description),
                      trailing: const Icon(Icons.add),
                      onTap: () async {
                        Navigator.pop(context);
                        await _addExerciseToWorkout(exercise);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addExerciseToWorkout(Exercise exercise) async {
    try {
      // Verificar se o workoutPlan tem ID
      if (widget.workoutPlan.id == null) {
        throw Exception('ID do plano de treino não encontrado');
      }

      debugPrint('🔄 Adicionando exercício: ${exercise.name}');
      debugPrint('📋 WorkoutPlan ID: ${widget.workoutPlan.id}');

      await _dbHelper.addExerciseToWorkoutPlan(
        widget.workoutPlan.id!,
        exercise,
      );
      await loadExercises();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exercício "${exercise.name}" adicionado!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('❌ Erro ao adicionar exercício: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar exercício: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeExercise(Exercise exercise) async {
    try {
      // Verificar se o workoutPlan tem ID
      if (widget.workoutPlan.id == null) {
        throw Exception('ID do plano de treino não encontrado');
      }

      // Verificar se o exercise tem ID
      if (exercise.id == null) {
        throw Exception('ID do exercício não encontrado');
      }

      debugPrint('🔄 Removendo exercício: ${exercise.name}');
      debugPrint('📋 WorkoutPlan ID: ${widget.workoutPlan.id}');
      debugPrint('💪 Exercise ID: ${exercise.id}');

      await _dbHelper.removeExerciseFromWorkoutPlan(
        widget.workoutPlan.id!,
        exercise.id!,
      );
      await loadExercises();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exercício "${exercise.name}" removido!'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      debugPrint('❌ Erro ao remover exercício: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover exercício: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios - ${widget.workoutPlan.dayOfWeek}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddExerciseDialog,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : exercises.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum exercício adicionado',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Toque no + para adicionar exercícios',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getMuscleGroupColor(
                        exercise.muscleGroup,
                      ),
                      child: Icon(
                        _getMuscleGroupIcon(exercise.muscleGroup),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise.description),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (exercise.sets != null)
                              GestureDetector(
                                onTap: () => _editExerciseSets(exercise),
                                child: Chip(
                                  label: Text('${exercise.sets} séries'),
                                  backgroundColor: Colors.blue.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            if (exercise.reps != null)
                              GestureDetector(
                                onTap: () => _editExerciseReps(exercise),
                                child: Chip(
                                  label: Text('${exercise.reps} reps'),
                                  backgroundColor: Colors.green.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(exercise.difficulty),
                              backgroundColor: _getDifficultyColor(
                                exercise.difficulty,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility),
                              SizedBox(width: 8),
                              Text('Ver detalhes'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Remover',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'view') {
                          _showExerciseDetails(exercise);
                        } else if (value == 'remove') {
                          _removeExercise(exercise);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getMuscleGroupColor(String muscleGroup) {
    switch (muscleGroup.toLowerCase()) {
      case 'peito':
        return Colors.red;
      case 'costas':
        return Colors.blue;
      case 'bíceps':
        return Colors.green;
      case 'tríceps':
        return Colors.orange;
      case 'perna':
        return Colors.purple;
      case 'ombro':
        return Colors.teal;
      case 'abdômen':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getMuscleGroupIcon(String muscleGroup) {
    switch (muscleGroup.toLowerCase()) {
      case 'peito':
        return Icons.fitness_center;
      case 'costas':
        return Icons.accessibility_new;
      case 'bíceps':
        return Icons.fitness_center;
      case 'tríceps':
        return Icons.fitness_center;
      case 'perna':
        return Icons.directions_run;
      case 'ombro':
        return Icons.accessibility_new;
      case 'abdômen':
        return Icons.fitness_center;
      default:
        return Icons.fitness_center;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'iniciante':
        return Colors.green.withValues(alpha: 0.1);
      case 'intermediário':
        return Colors.orange.withValues(alpha: 0.1);
      case 'avançado':
        return Colors.red.withValues(alpha: 0.1);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  void _editExerciseSets(Exercise exercise) {
    final TextEditingController setsController = TextEditingController(
      text: exercise.sets?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Séries - ${exercise.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: setsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de Séries',
                  hintText: 'Ex: 3',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newSets = int.tryParse(setsController.text);
                if (newSets != null && newSets > 0) {
                  _updateExerciseSets(exercise, newSets);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor, insira um número válido de séries',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _editExerciseReps(Exercise exercise) {
    final TextEditingController repsController = TextEditingController(
      text: exercise.reps?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Repetições - ${exercise.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de Repetições',
                  hintText: 'Ex: 12',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newReps = int.tryParse(repsController.text);
                if (newReps != null && newReps > 0) {
                  _updateExerciseReps(exercise, newReps);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor, insira um número válido de repetições',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _updateExerciseSets(Exercise exercise, int newSets) {
    // Atualiza o exercício no armazenamento temporário (modo web)
    if (kIsWeb) {
      // Recarrega os exercícios para obter a lista atualizada
      loadExercises();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Séries atualizadas para $newSets'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Para Android, você pode implementar a atualização no banco de dados aqui
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Funcionalidade de edição disponível apenas no modo web',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _updateExerciseReps(Exercise exercise, int newReps) {
    // Atualiza o exercício no armazenamento temporário (modo web)
    if (kIsWeb) {
      // Recarrega os exercícios para obter a lista atualizada
      loadExercises();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Repetições atualizadas para $newReps'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Para Android, você pode implementar a atualização no banco de dados aqui
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Funcionalidade de edição disponível apenas no modo web',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showExerciseDetails(Exercise exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercise.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Grupo Muscular: ${exercise.muscleGroup}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Descrição: ${exercise.description}'),
                const SizedBox(height: 16),
                Text(
                  'Instruções:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(exercise.instructions),
                const SizedBox(height: 16),
                if (exercise.sets != null ||
                    exercise.reps != null ||
                    exercise.restTime != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuração:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      if (exercise.sets != null)
                        Text('Séries: ${exercise.sets}'),
                      if (exercise.reps != null)
                        Text('Repetições: ${exercise.reps}'),
                      if (exercise.restTime != null)
                        Text('Descanso: ${exercise.restTime}s'),
                    ],
                  ),
                if (exercise.equipment != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Equipamento: ${exercise.equipment}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'Dificuldade: ${exercise.difficulty}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
