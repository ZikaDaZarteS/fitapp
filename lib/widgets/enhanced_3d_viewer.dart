import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../models/rat_evolution.dart';

class Enhanced3DViewer extends StatefulWidget {
  final RatEvolution evolution;
  final double size;
  final bool enableRotation;
  final bool enableZoom;
  final bool autoRotate;
  final bool fullScreen;

  const Enhanced3DViewer({
    super.key,
    required this.evolution,
    this.size = 200,
    this.enableRotation = true,
    this.enableZoom = true,
    this.autoRotate = true,
    this.fullScreen = false,
  });

  @override
  State<Enhanced3DViewer> createState() => _Enhanced3DViewerState();
}

class _Enhanced3DViewerState extends State<Enhanced3DViewer> {
  @override
  Widget build(BuildContext context) {
    // Se não há modelo 3D disponível, mostra a imagem padrão
    if (widget.evolution.modelPath == null) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.fullScreen ? 0 : 12),
          image: DecorationImage(
            image: AssetImage(widget.evolution.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Para arquivos .glb, usa ModelViewer com configurações avançadas
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.fullScreen ? 0 : 12),
        color: Colors.transparent, // Fundo completamente transparente
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.fullScreen ? 0 : 12),
        child: ModelViewer(
          // Fundo transparente
          backgroundColor: Colors.transparent,
          src: widget.evolution.modelPath!,
          alt: widget.evolution.description,

          // Controles de câmera
          ar: widget.enableRotation,
          autoRotate: widget.autoRotate,
          disableZoom: !widget.enableZoom,
          cameraControls: widget.enableRotation,

          // Configurações de ambiente
          environmentImage: null,
          exposure: 1.0,
          shadowIntensity: 0.5,
          shadowSoftness: 0.3,

          // Configurações de câmera para melhor zoom
          cameraOrbit: '0deg 75deg 105%',
          minCameraOrbit: 'auto auto 50%', // Zoom máximo mais próximo
          maxCameraOrbit: 'auto auto 200%', // Zoom mínimo mais distante
          // Campo de visão para zoom mais amplo
          fieldOfView: '30deg',
          minFieldOfView: '5deg', // Zoom máximo (mais próximo)
          maxFieldOfView: '60deg', // Zoom mínimo (mais distante)
          // Configurações de interação
          autoPlay: true,
          loading: Loading.eager,
          interactionPrompt: InteractionPrompt.none,
          touchAction: TouchAction.panY,

          // Configurações de iluminação
          skyboxImage: null,

          // Animações
          animationName: null,
        ),
      ),
    );
  }
}

// Widget para visualização em tela cheia
class FullScreen3DViewer extends StatelessWidget {
  final RatEvolution evolution;

  const FullScreen3DViewer({super.key, required this.evolution});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          evolution.name,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Enhanced3DViewer(
        evolution: evolution,
        size: MediaQuery.of(context).size.width,
        enableRotation: true,
        enableZoom: true,
        autoRotate: true,
        fullScreen: true,
      ),
    );
  }
}
