import 'package:flutter/material.dart';

enum RatStage {
  baby, // Bebê rato - iniciante
  young, // Rato jovem - bronze
  adult, // Rato adulto - prata
  warrior, // Rato guerreiro - ouro
  champion, // Rato campeão - diamante
  legend, // Rato lendário - lendário
  god, // Rato divino - divino
}

class RatEvolution {
  final RatStage stage;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int minPoints;
  final int maxPoints;
  final double evolutionProgress;
  final String imagePath;

  const RatEvolution({
    required this.stage,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.minPoints,
    required this.maxPoints,
    required this.evolutionProgress,
    required this.imagePath,
  });

  static RatEvolution getEvolutionStage(int points) {
    if (points >= 0 && points < 100) {
      return RatEvolution(
        stage: RatStage.baby,
        name: 'Bebê Rato',
        description:
            'Um pequeno rato iniciante, começando sua jornada fitness!',
        icon: Icons.child_care,
        color: Colors.grey,
        minPoints: 0,
        maxPoints: 100,
        evolutionProgress: points / 100,
        imagePath: 'assets/images/rat_1.jpg',
      );
    } else if (points >= 100 && points < 300) {
      return RatEvolution(
        stage: RatStage.young,
        name: 'Rato Jovem',
        description: 'Rato em crescimento, ganhando força e resistência!',
        icon: Icons.sports_gymnastics,
        color: Colors.brown,
        minPoints: 100,
        maxPoints: 300,
        evolutionProgress: (points - 100) / 200,
        imagePath: 'assets/images/rat_2.jpg',
      );
    } else if (points >= 300 && points < 600) {
      return RatEvolution(
        stage: RatStage.adult,
        name: 'Rato Adulto',
        description: 'Rato maduro, com experiência e determinação!',
        icon: Icons.fitness_center,
        color: Colors.blue,
        minPoints: 300,
        maxPoints: 600,
        evolutionProgress: (points - 300) / 300,
        imagePath: 'assets/images/rat_3.jpg',
      );
    } else if (points >= 600 && points < 1000) {
      return RatEvolution(
        stage: RatStage.warrior,
        name: 'Rato Guerreiro',
        description: 'Rato combatente, enfrentando desafios com coragem!',
        icon: Icons.sports_martial_arts,
        color: Colors.orange,
        minPoints: 600,
        maxPoints: 1000,
        evolutionProgress: (points - 600) / 400,
        imagePath: 'assets/images/rat_4.jpg',
      );
    } else if (points >= 1000 && points < 1500) {
      return RatEvolution(
        stage: RatStage.champion,
        name: 'Rato Campeão',
        description: 'Rato vitorioso, líder entre os ratos!',
        icon: Icons.emoji_events,
        color: Colors.purple,
        minPoints: 1000,
        maxPoints: 1500,
        evolutionProgress: (points - 1000) / 500,
        imagePath: 'assets/images/rat_5.jpg',
      );
    } else if (points >= 1500 && points < 2500) {
      return RatEvolution(
        stage: RatStage.legend,
        name: 'Rato Lendário',
        description: 'Rato lendário, história contada por gerações!',
        icon: Icons.auto_awesome,
        color: Colors.amber,
        minPoints: 1500,
        maxPoints: 2500,
        evolutionProgress: (points - 1500) / 1000,
        imagePath: 'assets/images/rat_6.jpg',
      );
    } else {
      return const RatEvolution(
        stage: RatStage.god,
        name: 'Rato Divino',
        description: 'Rato divino, transcendendo os limites mortais!',
        icon: Icons.psychology,
        color: Colors.red,
        minPoints: 2500,
        maxPoints: 9999,
        evolutionProgress: 1.0,
        imagePath:
            'assets/images/rat_6.jpg', // Usa a mesma imagem do lendário para o divino
      );
    }
  }

  String getNextStageName() {
    switch (stage) {
      case RatStage.baby:
        return 'Rato Jovem';
      case RatStage.young:
        return 'Rato Adulto';
      case RatStage.adult:
        return 'Rato Guerreiro';
      case RatStage.warrior:
        return 'Rato Campeão';
      case RatStage.champion:
        return 'Rato Lendário';
      case RatStage.legend:
        return 'Rato Divino';
      case RatStage.god:
        return 'Máximo';
    }
  }

  int getPointsToNextStage() {
    return maxPoints - minPoints;
  }

  int getCurrentPointsInStage(int totalPoints) {
    return totalPoints - minPoints;
  }
}
