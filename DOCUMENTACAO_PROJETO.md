# Documentação Detalhada do Projeto FitApp

## Visão Geral
O FitApp é um aplicativo Flutter de fitness completo que permite aos usuários gerenciar treinos, fazer check-ins, acompanhar evolução através de um sistema de "rato" gamificado, e interagir com outros usuários. O projeto utiliza Firebase para autenticação e sincronização, SQLite para armazenamento local, e possui suporte multiplataforma.

## 🚀 Status do Projeto
- **Versão**: 1.0.1+2
- **Flutter SDK**: ^3.8.1
- **Plataformas**: Android, iOS, Web, Windows, Linux, macOS
- **Estado**: ✅ Código limpo (0 problemas no flutter analyze)

## 1. Lista de Arquivos do Projeto

### Arquivos de Configuração
- `pubspec.yaml` (76 linhas) - Configuração de dependências e assets
- `analysis_options.yaml` - Configurações de análise de código
- `firebase.json` - Configuração do Firebase
- `.gitignore` - Arquivos ignorados pelo Git
- `.metadata` - Metadados do Flutter

### Documentação
- `README.md` - Documentação principal
- `DOCUMENTACAO_PROJETO.md` - Documentação detalhada (este arquivo)
- `FIREBASE_SETUP.md` - Instruções de configuração do Firebase
- `GOOGLE_SIGNIN_SETUP.md` - Configuração do login com Google
- `HABILITAR_EMAIL_PASSWORD.md` - Configuração de autenticação por email/senha
- `NOVAS_FUNCIONALIDADES.md` - Lista de novas funcionalidades
- `SOLUCAO_AUTH.md` - Soluções para problemas de autenticação
- `VERIFICAR_FIREBASE.md` - Verificação da configuração do Firebase
- `estrutura.txt` - Estrutura do projeto

### Código Principal (lib/)

#### Arquivo Principal
- `lib/main.dart` (136 linhas) - Ponto de entrada da aplicação com inicialização Firebase
- `lib/firebase_options.dart` - Configurações do Firebase

#### Modelos (lib/models/)
- `lib/models/user.dart` - Modelo de usuário com dados pessoais e preferências
- `lib/models/exercise.dart` - Modelo de exercício com categorias e detalhes
- `lib/models/workout.dart` - Modelo de treino
- `lib/models/checkin.dart` - Modelo de check-in com pontuação
- `lib/models/rat_evolution.dart` (152 linhas) - Sistema de evolução do rato com 6 estágios
- `lib/models/workout_plan.dart` - Modelo de plano de treino

#### Controladores (lib/controllers/)
- `lib/controllers/auth_controller.dart` - Controlador de autenticação Firebase
- `lib/controllers/exercise_controller.dart` - Controlador de exercícios e treinos

#### Banco de Dados (lib/db/)
- `lib/db/database_helper.dart` - Helper principal para SQLite
- `lib/db/database_schema.dart` - Schema do banco de dados
- `lib/db/firestore_helper.dart` - Helper para Firestore
- `lib/db/user_operations.dart` - Operações CRUD de usuários
- `lib/db/exercise_operations.dart` - Operações CRUD de exercícios
- `lib/db/workout_operations.dart` - Operações CRUD de treinos
- `lib/db/workout_plan_operations.dart` - Operações CRUD de planos de treino
- `lib/db/checkin_operations.dart` - Operações CRUD de check-ins

#### Telas (lib/screens/) - 27 telas
**Autenticação e Onboarding:**
- `lib/screens/login_screen.dart` - Tela de login com Firebase Auth
- `lib/screens/register_screen.dart` - Tela de registro
- `lib/screens/onboarding_screen.dart` - Tela de onboarding
- `lib/screens/start_screen.dart` - Tela inicial
- `lib/screens/user_form.dart` - Formulário de dados do usuário

**Navegação Principal:**
- `lib/screens/main_menu_screen.dart` - Menu principal com navegação
- `lib/screens/dashboard_screen.dart` - Dashboard com estatísticas
- `lib/screens/home_screen.dart` - Tela principal de treinos
- `lib/screens/home_screen_firebase.dart` - Versão Firebase da home
- `lib/screens/home_screen_simple.dart` - Versão simplificada da home
- `lib/screens/home_screen_static.dart` - Versão estática da home

**Treinos e Exercícios:**
- `lib/screens/workout_screen.dart` - Tela de execução de treino
- `lib/screens/workout_detail_screen.dart` - Detalhes do treino
- `lib/screens/exercise_management_screen.dart` - Gerenciamento de exercícios

**Sistema Social:**
- `lib/screens/friends_screen.dart` - Tela de amigos e busca de usuários
- `lib/screens/clubs_screen.dart` - Tela de clubes e grupos
- `lib/screens/ranking_screen.dart` - Ranking de usuários

**Gamificação:**
- `lib/screens/rat_evolution_screen.dart` - Evolução do rato
- `lib/screens/rat_showcase_screen.dart` - Showcase do rato
- `lib/screens/scoring_mode_screen.dart` - Modo de pontuação
- `lib/screens/scoring_screen.dart` - Tela de pontuação

**Funcionalidades Avançadas:**
- `lib/screens/checkin_screen.dart` - Tela de check-in
- `lib/screens/calendar_screen.dart` - Calendário de treinos
- `lib/screens/progress_report_screen.dart` - Relatório de progresso
- `lib/screens/settings_screen.dart` - Configurações do app
- `lib/screens/notification_settings_screen.dart` - Configurações de notificação
- `lib/screens/subscription_screen.dart` - Tela de assinatura premium
- `lib/screens/smartwatch_integration_screen.dart` - Integração com smartwatch

#### Widgets (lib/widgets/) - 9 widgets
- `lib/widgets/google_login_button.dart` - Botão de login com Google
- `lib/widgets/social_login_button.dart` - Botão de login social genérico
- `lib/widgets/login_separator.dart` - Separador na tela de login
- `lib/widgets/login_text_field.dart` - Campo de texto para login
- `lib/widgets/exercise_card.dart` - Card de exercício
- `lib/widgets/add_exercise_dialog.dart` - Dialog para adicionar exercício
- `lib/widgets/edit_exercise_dialog.dart` - Dialog para editar exercício
- `lib/widgets/exercise_details_dialog.dart` - Dialog de detalhes do exercício
- `lib/widgets/animated_rat_3d.dart` - Animação 3D do rato

#### Dados e Utilitários
- `lib/data/predefined_exercises.dart` - Exercícios pré-definidos
- `lib/utils/firebase_test.dart` - Testes do Firebase

### Assets
- `assets/images/` - 11 arquivos (logos SVG, imagens de ratos JPG, background)
- `assets/animations/` - Vídeo de animação do rato monstro

### Configurações de Plataforma
- `android/` - Configurações Android com google-services.json
- `ios/` - Configurações iOS
- `web/` - Configurações Web com index.html customizado
- `windows/` - Configurações Windows
- `linux/` - Configurações Linux
- `macos/` - Configurações macOS

## 2. Tecnologias e Dependências

### Dependências Principais
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  logger: ^2.0.2+1
  sqflite: ^2.3.0
  sqflite_common_ffi_web: ^0.4.2+2
  path_provider: ^2.1.1
  path: ^1.8.3
  provider: ^6.1.1
  flutter_slidable: ^3.0.1
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  google_sign_in: ^6.1.6
  flutter_svg: ^2.0.9
  image_picker: ^1.0.4
  shared_preferences: ^2.2.2
  url_launcher: ^6.2.1
  intl: ^0.18.1
  table_calendar: ^3.0.9
```

### Tecnologias Utilizadas
- **Framework**: Flutter 3.8.1+
- **Linguagem**: Dart
- **Banco Local**: SQLite
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Autenticação**: Firebase Auth + Google Sign-In
- **Estado**: Provider
- **Imagens**: SVG + Image Picker
- **Calendário**: Table Calendar
- **Logs**: Logger

## 3. Análise de Classes e Funções

### main.dart
**Classes:**
- `MyApp` (StatefulWidget) - Widget principal da aplicação
- `_MyAppState` (State) - Estado do widget principal

**Funções:**
- `main()` - Função principal, inicializa Firebase e executa app
- `_decideStartScreen()` - Decide qual tela inicial mostrar baseado na autenticação

### Modelos

#### User (user.dart)
**Classe:** `User`
**Tipo:** Model
**Descrição:** Representa um usuário do sistema com informações pessoais, preferências de treino e dados de gamificação
**Métodos principais:**
- `toMap()` - Converte para Map
- `fromMap()` - Cria instância a partir de Map
- `copyWith()` - Cria cópia com modificações

#### Exercise (exercise.dart)
**Classe:** `Exercise`
**Tipo:** Model
**Descrição:** Representa um exercício físico com instruções, equipamentos e configurações
**Métodos principais:**
- `toMap()` - Converte para Map
- `fromMap()` - Cria instância a partir de Map
- `copyWith()` - Cria cópia com modificações

#### RatEvolution (rat_evolution.dart)
**Enum:** `RatStage` - Estágios de evolução do rato
**Classe:** `RatEvolution`
**Tipo:** Model/Logic
**Descrição:** Sistema de gamificação baseado na evolução de um rato virtual
**Métodos principais:**
- `getEvolutionStage()` - Determina estágio baseado em pontos
- `getNextStageName()` - Nome do próximo estágio
- `getPointsToNextStage()` - Pontos necessários para próximo nível

### Controladores

#### AuthController (auth_controller.dart)
**Classe:** `AuthController` (Singleton)
**Tipo:** Controller
**Descrição:** Gerencia autenticação com Firebase (email/senha, Google, Apple)
**Métodos principais:**
- `loginWithEmailPassword()` - Login com email e senha
- `signInWithGoogle()` - Login com Google
- `signInWithApple()` - Login com Apple (simulado)
- `checkFirebaseAuth()` - Verifica estado da autenticação

#### ExerciseController (exercise_controller.dart)
**Classe:** `ExerciseController`
**Tipo:** Controller
**Descrição:** Gerencia exercícios pré-definidos organizados por grupo muscular
**Propriedades:**
- `predefinedExercises` - Map com exercícios organizados por grupo muscular
**Exercícios incluídos:**
- Peito: Supino Reto, Supino Inclinado, Flexão, Crucifixo, etc.
- Costas: Puxada, Remada, Pull-up, etc.
- Bíceps: Rosca Direta, Rosca Martelo, Rosca Scott, etc.
- Tríceps: Extensão, Tríceps na Polia, Mergulho, etc.
- Ombros: Desenvolvimento, etc.

### Helpers de Banco de Dados

#### DatabaseHelper (database_helper.dart)
**Classe:** `DatabaseHelper` (Singleton)
**Tipo:** Database Helper
**Descrição:** Gerencia banco SQLite local com suporte para web
**Tabelas:**
- `users` - Dados dos usuários
- `workouts` - Treinos
- `checkins` - Check-ins dos usuários
- `friends` - Relacionamentos de amizade
- `workout_plans` - Planos de treino
- `exercises` - Exercícios
**Métodos principais:**
- `initDb()` - Inicializa banco de dados
- `_onCreate()` - Cria tabelas
- `_onUpgrade()` - Migração de versões

#### FirestoreHelper (firestore_helper.dart)
**Classe:** `FirestoreHelper`
**Tipo:** Database Helper
**Descrição:** Gerencia sincronização com Firestore
**Métodos principais:**
- `addWorkout()` - Adiciona treino no Firestore
- `updateWorkout()` - Atualiza treino
- `getWorkouts()` - Stream de treinos
- `deleteWorkout()` - Remove treino

### Telas Principais

#### LoginScreen (login_screen.dart)
**Classe:** `LoginScreen` (StatefulWidget)
**Tipo:** Screen Widget
**Descrição:** Tela de autenticação com email/senha e login social
**Funcionalidades:**
- Login com email e senha
- Login com Google
- Login com Apple (simulado)
- Validação de campos
- Estados de loading

#### MainMenuScreen (main_menu_screen.dart)
**Classe:** `MainMenuScreen` (StatefulWidget)
**Tipo:** Screen Widget
**Descrição:** Menu principal com navegação por abas
**Abas:**
- Dashboard
- Treinos (Home)
- Amigos
- Mais (configurações e perfil)

#### DashboardScreen (dashboard_screen.dart)
**Classe:** `DashboardScreen` (StatefulWidget)
**Tipo:** Screen Widget
**Descrição:** Dashboard principal com estatísticas e navegação rápida
**Funcionalidades:**
- Exibição do rato atual e evolução
- Cards de estatísticas (check-ins, dias ativos)
- Botão de check-in
- Navegação rápida para funcionalidades principais

#### HomeScreen (home_screen.dart)
**Classe:** `HomeScreen` (StatefulWidget)
**Tipo:** Screen Widget
**Descrição:** Tela de gerenciamento de treinos
**Funcionalidades:**
- Lista de planos de treino por dia da semana
- Sincronização com Firestore
- Edição de treinos
- Navegação para detalhes e exercícios

### Widgets Reutilizáveis

#### GoogleLoginButton (google_login_button.dart)
**Classe:** `GoogleLoginButton` (StatelessWidget)
**Tipo:** UI Widget
**Descrição:** Botão customizado para login com Google usando SVG

#### ExerciseCard (exercise_card.dart)
**Classe:** `ExerciseCard` (StatelessWidget)
**Tipo:** UI Widget
**Descrição:** Card para exibir informações de exercício
**Funcionalidades:**
- Exibição de nome, descrição e grupo muscular
- Cores por grupo muscular
- Menu de ações (detalhes, remover)
- Edição de séries e repetições

## 3. Dependências por Arquivo

### main.dart
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'firebase_options.dart';
import 'package:fitapp/db/database_helper.dart' as db_helper;
import 'package:fitapp/models/user.dart' as local_user;
import 'package:fitapp/screens/login_screen.dart';
import 'package:fitapp/screens/main_menu_screen.dart';
import 'package:fitapp/screens/onboarding_screen.dart';
```

### auth_controller.dart
```dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/main_menu_screen.dart';
```

### database_helper.dart
```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../models/checkin.dart';
import '../models/workout_plan.dart';
import '../models/user.dart' as app_user;
```

## 4. Dependências Externas (pubspec.yaml)

### Dependências Principais
- `flutter` - Framework principal
- `cupertino_icons: ^1.0.8` - Ícones iOS
- `logger: ^2.0.2` - Sistema de logs

### Banco de Dados
- `sqflite: ^2.3.0` - SQLite local
- `path_provider: ^2.1.2` - Acesso a diretórios
- `path: ^1.8.3` - Manipulação de caminhos

### Estado e UI
- `provider: ^6.1.2` - Gerenciamento de estado
- `flutter_slidable: ^4.0.0` - Widgets deslizáveis

### Firebase
- `firebase_core: ^2.27.0` - Core do Firebase
- `firebase_auth: ^4.19.0` - Autenticação
- `cloud_firestore: ^4.15.0` - Banco de dados
- `firebase_storage: ^11.6.0` - Armazenamento

### Funcionalidades Específicas
- `google_sign_in: ^6.2.1` - Login com Google
- `flutter_svg: ^2.0.9` - Suporte a SVG
- `image_picker: ^1.0.7` - Seleção de imagens
- `shared_preferences: ^2.2.2` - Preferências locais
- `url_launcher: ^6.2.5` - Abertura de URLs
- `intl: ^0.18.0` - Internacionalização
- `table_calendar: ^3.0.9` - Calendário

### Dependências de Desenvolvimento
- `flutter_test` - Testes
- `flutter_lints: ^3.0.1` - Linting

## 5. Fluxo Geral da Aplicação

### 1. Inicialização
1. `main()` inicializa Firebase
2. `MyApp` verifica estado de autenticação
3. `_decideStartScreen()` decide tela inicial:
   - Se autenticado → `MainMenuScreen`
   - Se não autenticado → `LoginScreen`

### 2. Autenticação
1. `LoginScreen` oferece opções de login
2. `AuthController` gerencia autenticação:
   - Email/senha via Firebase Auth
   - Google Sign-In
   - Apple Sign-In (simulado)
3. Sucesso → Navega para `MainMenuScreen`

### 3. Menu Principal
1. `MainMenuScreen` com 4 abas:
   - **Dashboard**: Estatísticas e navegação rápida
   - **Treinos**: Gerenciamento de treinos
   - **Amigos**: Funcionalidades sociais
   - **Mais**: Configurações e perfil

### 4. Funcionalidades Principais

#### Dashboard
- Exibe evolução do rato baseada em pontos
- Mostra estatísticas (check-ins, dias ativos)
- Navegação rápida para:
  - Check-in
  - Clubes
  - Criação de grupos/desafios
  - Evolução do rato

#### Treinos
- Lista planos de treino por dia da semana
- Sincronização SQLite ↔ Firestore
- Gerenciamento de exercícios por grupo muscular
- Exercícios pré-definidos organizados por:
  - Peito, Costas, Bíceps, Tríceps
  - Perna, Ombro, Abdômen

#### Sistema de Gamificação
- **Rato Virtual** evolui baseado em pontos
- **7 Estágios**: Bebê → Jovem → Adulto → Guerreiro → Campeão → Lendário → Divino
- **Pontos** ganhos através de check-ins e atividades
- **Imagens** diferentes para cada estágio

### 5. Persistência de Dados

#### Local (SQLite)
- Usuários, treinos, check-ins
- Planos de treino e exercícios
- Funciona offline

#### Nuvem (Firestore)
- Sincronização de treinos
- Backup de dados
- Funcionalidades sociais

### 6. Arquitetura

```
UI Layer (Screens/Widgets)
    ↓
Controller Layer (AuthController, ExerciseController)
    ↓
Data Layer (DatabaseHelper, FirestoreHelper)
    ↓
Model Layer (User, Exercise, Workout, etc.)
```

## 6. Estado Atual do Projeto

### Funcionalidades Implementadas
✅ Sistema de autenticação completo
✅ Banco de dados local e nuvem
✅ Sistema de gamificação (rato virtual)
✅ Gerenciamento de treinos e exercícios
✅ Interface de usuário moderna
✅ Navegação por abas
✅ Check-ins e estatísticas

### Funcionalidades Parciais
🔄 Integração com smartwatch (tela criada)
🔄 Sistema de amigos (estrutura básica)
🔄 Clubes e ranking (interfaces criadas)
🔄 Notificações (dependência comentada)
🔄 Integração com Health (dependência comentada)

### Pontos de Atenção
⚠️ Algumas dependências comentadas por compatibilidade
⚠️ Funcionalidades sociais em desenvolvimento
⚠️ Testes unitários não implementados
⚠️ Documentação de API incompleta

## 7. Próximos Passos Sugeridos

1. **Completar funcionalidades sociais** (amigos, clubes)
2. **Implementar sistema de notificações**
3. **Adicionar testes unitários e de integração**
4. **Melhorar tratamento de erros**
5. **Implementar cache offline mais robusto**
6. **Adicionar analytics e crash reporting**
7. **Otimizar performance e carregamento**

Este documento serve como mapa completo do projeto para futuras reorganizações e melhorias do código.