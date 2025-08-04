import 'package:flutter/material.dart';

class EditExerciseDialog extends StatelessWidget {
  final String title;
  final String label;
  final String hint;
  final String initialValue;
  final Function(int) onSave;

  const EditExerciseDialog({
    super.key,
    required this.title,
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: label, hintText: hint),
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
            final newValue = int.tryParse(controller.text);
            if (newValue != null && newValue > 0) {
              onSave(newValue);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, insira um número válido'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
