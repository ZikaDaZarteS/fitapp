import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/db/database_helper.dart';
import 'package:fitapp/models/checkin.dart';
import 'dart:io' as io;

/// Tela de check-in do usuário
/// Permite que o usuário registre seu treino com nota e foto opcional
class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  // Controlador para o campo de texto da nota
  final TextEditingController _noteController = TextEditingController();

  // Caminho da imagem selecionada (opcional)
  String? _selectedImagePath;

  // Estado de carregamento durante o envio
  bool _isLoading = false;

  // Instância do ImagePicker para captura/seleção de fotos
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  /// Função para capturar foto usando a câmera
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Qualidade da imagem (80% para otimizar tamanho)
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao capturar foto: $e')));
      }
    }
  }

  /// Função para selecionar foto da galeria
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Qualidade da imagem (80% para otimizar tamanho)
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao selecionar foto: $e')));
      }
    }
  }

  /// Função principal para enviar o check-in
  /// Valida os dados e salva no banco de dados
  Future<void> _submitCheckin() async {
    // Valida se a nota foi preenchida
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione uma nota ao seu check-in')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Ativa o indicador de carregamento
    });

    try {
      // Obtém o usuário atual do Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado')),
        );
        return;
      }

      // Cria o objeto Checkin com os dados do formulário
      final checkin = Checkin(
        userId: user.uid, // ID do usuário do Firebase
        note: _noteController.text.trim(), // Nota do treino
        imagePath: _selectedImagePath, // Caminho da foto (opcional)
        timestamp: DateTime.now(), // Data e hora atual
      );

      // Salva o check-in no banco de dados
      final db = DatabaseHelper();
      await db.insertCheckin(checkin);

      if (!mounted) return;

      // Mostra mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpa os campos após o sucesso
      _noteController.clear();
      setState(() {
        _selectedImagePath = null;
      });
    } catch (e) {
      if (!mounted) return;
      // Mostra erro detalhado para debug
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao fazer check-in: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Desativa o indicador de carregamento
        });
      }
    }
  }

  /// Widget para exibir a imagem selecionada
  /// Suporta tanto arquivos locais quanto web
  Widget buildImageWidget(String? path) {
    if (path == null) return Container();
    if (kIsWeb) {
      // Em modo web, mostra ícone placeholder
      return Container(
        color: Colors.grey[300],
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 64,
        ),
      );
    } else {
      // Em modo mobile, exibe a imagem do arquivo
      return Image.file(io.File(path), fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Cor de fundo cinza claro
      appBar: AppBar(
        title: const Text('Check-in'),
        backgroundColor: const Color(0xFFFF6B35), // Cor laranja
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card principal do formulário
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Ícone e título da tela
                    const Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Color(0xFFFF6B35),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Como foi seu treino hoje?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campo de texto para a nota do treino
                    TextField(
                      controller: _noteController,
                      maxLines: 4, // Permite múltiplas linhas
                      decoration: InputDecoration(
                        hintText: 'Conte como foi seu treino...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6B35),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Seção de foto (opcional)
                    const Text(
                      'Foto do treino (opcional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botões para selecionar foto
                    Row(
                      children: [
                        // Botão para selecionar da galeria
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickImageFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Galeria'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Botão para capturar com a câmera
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Câmera'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Exibição da imagem selecionada
                    if (_selectedImagePath != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFF6B35)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: buildImageWidget(_selectedImagePath),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Botão para remover a foto
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedImagePath = null;
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          'Remover foto',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Botão principal para enviar o check-in
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _submitCheckin, // Desabilita durante carregamento
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                            : const Text(
                                'Fazer Check-in',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
