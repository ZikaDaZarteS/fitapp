# FitApp 🏋️‍♂️

Um aplicativo Flutter completo de fitness com sistema de gamificação, autenticação Firebase e funcionalidades sociais.

## 🚀 Status do Projeto
- **Versão**: 1.0.1+2
- **Flutter SDK**: ^3.8.1
- **Plataformas**: Android, iOS, Web, Windows, Linux, macOS
- **Estado**: ✅ Código limpo (0 problemas no flutter analyze)

## 📱 Funcionalidades

### Interface Principal
- Dashboard com estatísticas de progresso em tempo real
- Sistema de navegação intuitivo com bottom navigation
- Interface responsiva e moderna com Material Design
- Múltiplas versões da tela principal (Firebase, Simple, Static)

### Sistema de Treinos
- Criação e gerenciamento de exercícios personalizados
- Planos de treino estruturados e flexíveis
- Histórico detalhado de treinos com estatísticas
- Categorização de exercícios (Peito, Costas, Pernas, Cardio, etc.)
- Exercícios pré-definidos para início rápido
- Sistema de séries, repetições e peso

### Sistema de Evolução (Gamificação)
- **Rato Gamificado**: Sistema único de evolução baseado em pontos
- 6 estágios de evolução: Bebê → Jovem → Adulto → Forte → Épico → Lendário
- Pontuação baseada em check-ins e atividades de treino
- Visualização 3D do rato em diferentes estágios
- Sistema de conquistas e marcos
- Animações e feedback visual

### Funcionalidades Sociais
- Sistema de amigos e busca de usuários
- Ranking global de usuários por pontos
- Clubes e grupos de treino
- Compartilhamento de progresso e conquistas
- Perfis de usuário personalizáveis

### Recursos Avançados
- Check-in diário com sistema de pontos
- Calendário de treinos com visualização mensal
- Relatórios de progresso detalhados e gráficos
- Configurações personalizáveis e notificações
- Integração com smartwatch (planejada)
- Sistema de assinatura premium
- Suporte completo multiplataforma

## 🛠️ Tecnologias Utilizadas

### Core
- **Flutter** 3.8.1+ - Framework de desenvolvimento multiplataforma
- **Dart** - Linguagem de programação

### Backend e Autenticação
- **Firebase** - Plataforma backend completa
  - Firebase Auth (Email/Senha + Google Sign-In)
  - Cloud Firestore (Banco de dados NoSQL)
  - Firebase Storage (Armazenamento de imagens)

### Banco de Dados
- **SQLite** - Banco de dados local para offline-first
- **sqflite** - Plugin Flutter para SQLite
- **sqflite_common_ffi_web** - Suporte web para SQLite

### Gerenciamento de Estado e UI
- **Provider** - Gerenciamento de estado reativo
- **Material Design** - Design system do Google
- **flutter_svg** - Suporte a imagens SVG
- **flutter_slidable** - Widgets deslizáveis

### Funcionalidades Específicas
- **table_calendar** - Calendário interativo
- **image_picker** - Seleção de imagens
- **shared_preferences** - Armazenamento de preferências
- **url_launcher** - Abertura de URLs externas
- **intl** - Internacionalização e formatação
- **logger** - Sistema de logs

## 📋 Pré-requisitos

- Flutter SDK 3.8.1 ou superior
- Dart SDK 2.19.0 ou superior
- Android Studio / VS Code com extensões Flutter
- Conta no Firebase (gratuita)
- Emulador Android/iOS ou dispositivo físico
- Git para controle de versão

## 🚀 Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/fitapp.git
   cd fitapp
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**
   - Siga as instruções detalhadas em `FIREBASE_SETUP.md`
   - Adicione os arquivos de configuração:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`
   - Configure as regras do Firestore

4. **Verifique a instalação**
   ```bash
   flutter doctor
   flutter analyze
   ```

5. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 📸 Screenshots

### Tela de Login
![Login](assets/images/login_screenshot.png)
*Autenticação com email/senha e Google Sign-In*

### Dashboard Principal
![Dashboard](assets/images/dashboard_screenshot.png)
*Visão geral do progresso e estatísticas*

### Sistema de Evolução do Rato
![Rat Evolution](assets/images/rat_evolution_screenshot.png)
*Gamificação com 6 estágios de evolução*

### Gerenciamento de Treinos
![Workouts](assets/images/workouts_screenshot.png)
*Criação e execução de treinos personalizados*

## 🔧 Configuração do Firebase

Para configurar o Firebase no projeto:

1. **Crie um projeto** no [Firebase Console](https://console.firebase.google.com/)
2. **Ative os serviços necessários**:
   - Authentication (Email/Senha e Google)
   - Cloud Firestore Database
   - Storage
3. **Configure as plataformas** (Android, iOS, Web)
4. **Baixe os arquivos de configuração**
5. **Siga o guia detalhado** em `FIREBASE_SETUP.md`

## 📁 Estrutura do Projeto

```
fitapp/
├── lib/
│   ├── controllers/                 # Controladores de lógica de negócio
│   │   ├── auth_controller.dart     # Autenticação Firebase
│   │   └── exercise_controller.dart # Gerenciamento de exercícios
│   ├── db/                          # Camada de banco de dados
│   │   ├── database_helper.dart     # Helper principal SQLite
│   │   ├── database_schema.dart     # Schema do banco
│   │   ├── firestore_helper.dart    # Helper Firestore
│   │   ├── user_operations.dart     # CRUD usuários
│   │   ├── exercise_operations.dart # CRUD exercícios
│   │   ├── workout_operations.dart  # CRUD treinos
│   │   ├── workout_plan_operations.dart # CRUD planos
│   │   └── checkin_operations.dart  # CRUD check-ins
│   ├── models/                      # Modelos de dados
│   │   ├── user.dart               # Modelo de usuário
│   │   ├── exercise.dart           # Modelo de exercício
│   │   ├── workout.dart            # Modelo de treino
│   │   ├── checkin.dart            # Modelo de check-in
│   │   ├── rat_evolution.dart      # Sistema de evolução
│   │   └── workout_plan.dart       # Modelo de plano
│   ├── screens/                     # Telas da aplicação (27 telas)
│   │   ├── auth/                   # Autenticação
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── onboarding_screen.dart
│   │   ├── main/                   # Navegação principal
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   └── main_menu_screen.dart
│   │   ├── workouts/               # Treinos
│   │   │   ├── workout_screen.dart
│   │   │   ├── workout_detail_screen.dart
│   │   │   └── exercise_management_screen.dart
│   │   ├── social/                 # Funcionalidades sociais
│   │   │   ├── friends_screen.dart
│   │   │   ├── clubs_screen.dart
│   │   │   └── ranking_screen.dart
│   │   ├── gamification/           # Sistema de gamificação
│   │   │   ├── rat_evolution_screen.dart
│   │   │   ├── rat_showcase_screen.dart
│   │   │   └── scoring_screen.dart
│   │   └── settings/               # Configurações
│   │       ├── settings_screen.dart
│   │       └── notification_settings_screen.dart
│   ├── widgets/                     # Widgets reutilizáveis (9 widgets)
│   │   ├── auth/                   # Widgets de autenticação
│   │   │   ├── google_login_button.dart
│   │   │   ├── social_login_button.dart
│   │   │   ├── login_separator.dart
│   │   │   └── login_text_field.dart
│   │   ├── exercise/               # Widgets de exercícios
│   │   │   ├── exercise_card.dart
│   │   │   ├── add_exercise_dialog.dart
│   │   │   ├── edit_exercise_dialog.dart
│   │   │   └── exercise_details_dialog.dart
│   │   └── animations/             # Animações
│   │       └── animated_rat_3d.dart
│   ├── data/                        # Dados estáticos
│   │   └── predefined_exercises.dart
│   ├── utils/                       # Utilitários
│   │   └── firebase_test.dart
│   ├── firebase_options.dart        # Configurações Firebase
│   └── main.dart                    # Ponto de entrada
├── assets/                          # Recursos estáticos
│   ├── images/                     # 11 imagens (SVG + JPG)
│   │   ├── logo.svg
│   │   ├── rat_baby.jpg
│   │   ├── rat_young.jpg
│   │   ├── rat_adult.jpg
│   │   ├── rat_strong.jpg
│   │   ├── rat_epic.jpg
│   │   ├── rat_legendary.jpg
│   │   └── ...
│   └── animations/                 # Vídeos de animação
│       └── rat_monster.mp4
├── android/                         # Configurações Android
│   └── app/google-services.json    # Config Firebase Android
├── ios/                            # Configurações iOS
├── web/                            # Configurações Web
├── windows/                        # Configurações Windows
├── linux/                          # Configurações Linux
├── macos/                          # Configurações macOS
├── docs/                           # Documentação
│   ├── FIREBASE_SETUP.md
│   ├── GOOGLE_SIGNIN_SETUP.md
│   └── ...
└── pubspec.yaml                    # Dependências e configurações
```

## 🎯 Roadmap

### ✅ Versão Atual (1.0.1+2)
- ✅ Sistema de autenticação Firebase completo
- ✅ CRUD de exercícios e treinos
- ✅ Sistema de evolução do rato (6 estágios)
- ✅ Check-ins diários com pontuação
- ✅ Interface responsiva multiplataforma
- ✅ Sistema social (amigos, ranking, clubes)
- ✅ Calendário de treinos
- ✅ Relatórios de progresso
- ✅ Código limpo (0 problemas flutter analyze)

### 🔄 Próximas Versões (1.1.x)
- 🔄 Integração com wearables e smartwatch
- 🔄 Sistema de notificações push
- 🔄 Modo offline completo com sincronização
- 🔄 Análises avançadas e gráficos
- 🔄 Compartilhamento social aprimorado
- 🔄 Sistema de conquistas e badges
- 🔄 Planos de treino automáticos com IA

### 🚀 Versões Futuras (2.0+)
- 🚀 Integração com nutrição e dieta
- 🚀 Marketplace de treinos
- 🚀 Coaching virtual
- 🚀 Realidade aumentada para exercícios
- 🚀 Competições e desafios globais

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### 📝 Diretrizes de Contribuição
- Siga as convenções de código Dart/Flutter
- Mantenha o código limpo (flutter analyze deve passar)
- Adicione testes para novas funcionalidades
- Atualize a documentação quando necessário
- Use commits semânticos (feat:, fix:, docs:, etc.)

## 🧪 Testes

```bash
# Executar todos os testes
flutter test

# Análise de código
flutter analyze

# Verificar formatação
flutter format --set-exit-if-changed .
```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Contato e Suporte

- **Documentação**: Consulte os arquivos em `/docs`
- **Issues**: [GitHub Issues](https://github.com/seu-usuario/fitapp/issues)
- **Discussões**: [GitHub Discussions](https://github.com/seu-usuario/fitapp/discussions)
- **Email**: fitapp.support@exemplo.com

## 🙏 Agradecimentos

- Flutter Team pelo framework incrível
- Firebase pela infraestrutura robusta
- Comunidade Flutter pelas bibliotecas e suporte
- Todos os contribuidores do projeto

---

⭐ **Se este projeto te ajudou, considere dar uma estrela no repositório!**

📱 **Baixe o FitApp e comece sua jornada fitness hoje mesmo!**
