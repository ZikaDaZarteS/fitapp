# FitApp - Aplicativo de Treinos

Um aplicativo completo de fitness desenvolvido em Flutter com funcionalidades avançadas de acompanhamento de treinos, evolução de personagem e integração social.

## 🚀 Funcionalidades

### 📱 Interface Principal
- **Dashboard**: Visão geral do progresso com estatísticas
- **Treinos**: Gerenciamento de rotinas de exercícios
- **Amigos**: Sistema social para conectar com outros usuários
- **Perfil**: Configurações e dados pessoais

### 🏋️ Sistema de Treinos
- Criação e edição de planos de treino
- Categorização por grupos musculares
- Acompanhamento de progresso
- Integração com Firebase para sincronização

### 🐀 Sistema de Evolução
- Personagem rato que evolui conforme o progresso
- Sistema de pontos baseado em check-ins
- Múltiplas fases de evolução
- Animações 3D interativas

### 👥 Funcionalidades Sociais
- Sistema de amigos
- Busca de usuários
- Perfis detalhados
- Ranking de check-ins

### ⚙️ Recursos Avançados
- Integração com smartwatch
- Relatórios de progresso
- Sistema de clubes
- Criação de grupos e desafios
- Assinatura premium

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework principal
- **Dart**: Linguagem de programação
- **Firebase**: Backend e autenticação
- **SQLite**: Banco de dados local
- **Firestore**: Sincronização em nuvem

## 📋 Pré-requisitos

- Flutter SDK (versão 3.0 ou superior)
- Dart SDK
- Android Studio / VS Code
- Firebase project configurado

## 🔧 Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/ZikaDaZarteS/fitapp.git
   cd fitapp
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**
   - Crie um projeto no Firebase Console
   - Adicione o arquivo `google-services.json` na pasta `android/app/`
   - Configure as regras do Firestore

4. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Dashboard
- Visão geral do progresso
- Estatísticas de check-ins
- Evolução do personagem

### Treinos
- Lista de rotinas diárias
- Edição de planos
- Categorização por músculos

### Amigos
- Sistema social
- Busca de usuários
- Perfis detalhados

## 🔐 Configuração do Firebase

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Ative a autenticação por email/senha
3. Configure o Firestore Database
4. Baixe o arquivo `google-services.json` e coloque em `android/app/`

## 📊 Estrutura do Projeto

```
lib/
├── db/                    # Banco de dados
│   ├── database_helper.dart
│   └── firestore_helper.dart
├── models/               # Modelos de dados
│   ├── user.dart
│   ├── workout.dart
│   ├── exercise.dart
│   └── rat_evolution.dart
├── screens/              # Telas do aplicativo
│   ├── dashboard_screen.dart
│   ├── home_screen.dart
│   ├── friends_screen.dart
│   └── ...
├── widgets/              # Widgets reutilizáveis
└── utils/                # Utilitários
```

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Autor

**Diego**
- Email: diegoribeiro359@gmail.com
- GitHub: [@ZikaDaZarteS](https://github.com/ZikaDaZarteS)

## 🙏 Agradecimentos

- Comunidade Flutter
- Firebase pela infraestrutura
- Todos os contribuidores do projeto

---

⭐ Se este projeto te ajudou, considere dar uma estrela no repositório!
