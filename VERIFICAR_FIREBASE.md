# 🔍 Verificação da Configuração do Firebase

## Passo 1: Verificar Firebase Console

### 1.1 Acessar o Console
1. Vá para: https://console.firebase.google.com/
2. Selecione o projeto: `academia-173e0`

### 1.2 Verificar Authentication
1. No menu lateral, clique em **Authentication**
2. Clique em **Sign-in method**
3. **VERIFIQUE** se **Email/Password** está habilitado
4. Se não estiver, clique em **Email/Password** e habilite

### 1.3 Verificar Domínios Autorizados (Web)
1. Em **Authentication**, clique em **Settings**
2. Vá para a aba **Authorized domains**
3. **ADICIONE** `localhost` se não estiver listado
4. **ADICIONE** seu domínio de produção se necessário

## Passo 2: Verificar Configuração do Projeto

### 2.1 Verificar Configuração Android
1. Vá para **Project Settings** (ícone de engrenagem)
2. Clique em **General**
3. Role para baixo até **Your apps**
4. Verifique se o app Android está configurado
5. Se não estiver, clique em **Add app** > **Android**
6. Use o package name: `com.academia.fitapp`

### 2.2 Verificar Configuração Web
1. Em **Project Settings** > **General**
2. Verifique se o app Web está configurado
3. Se não estiver, clique em **Add app** > **Web app**
4. Use o nome: `fitapp-web`

## Passo 3: Testar no App

### 3.1 Executar o App
```bash
flutter run
```

### 3.2 Usar o Botão de Teste
1. Abra o app
2. Clique no botão **"Testar Firebase"** (amarelo)
3. Verifique os logs no console
4. Verifique a mensagem que aparece no app

### 3.3 Logs Esperados
```
🚀 Iniciando Firebase...
✅ Firebase inicializado com sucesso
✅ Firebase Auth disponível
🧪 Iniciando teste do Firebase...
✅ Firebase Auth disponível
📱 App: [DEFAULT]
🔑 Projeto: academia-173e0
🌐 Auth Domain: academia-173e0.firebaseapp.com
👤 Usuário atual: Nenhum
📝 Tentando criar usuário de teste...
✅ Usuário de teste criado com sucesso!
🗑️ Usuário de teste deletado
```

## Passo 4: Problemas Comuns

### 4.1 Erro: "Email/Password sign-in is not enabled"
**Solução**: Habilite Email/Password no Firebase Console

### 4.2 Erro: "Domain not authorized"
**Solução**: Adicione `localhost` nos domínios autorizados

### 4.3 Erro: "Invalid API key"
**Solução**: Verifique se `google-services.json` está correto

### 4.4 Erro: "Network request failed"
**Solução**: Verifique conexão com internet

## Passo 5: Comandos de Debug

```bash
# Limpar cache
flutter clean

# Reinstalar dependências
flutter pub get

# Executar com logs detalhados
flutter run --verbose

# Verificar dispositivos
flutter devices

# Verificar configuração
flutter doctor
```

## Passo 6: Verificar Arquivos

### 6.1 Verificar google-services.json
```json
{
  "project_info": {
    "project_number": "707846215547",
    "project_id": "academia-173e0"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:707846215547:android:886fdbb836e887618f0fde",
        "android_client_info": {
          "package_name": "com.academia.fitapp"
        }
      }
    }
  ]
}
```

### 6.2 Verificar firebase_options.dart
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyBnfupeGpyziAikPPcmw6acspzMr33Efbc',
  appId: '1:707846215547:android:886fdbb836e887618f0fde',
  messagingSenderId: '707846215547',
  projectId: 'academia-173e0',
  storageBucket: 'academia-173e0.appspot.com',
);
```

## Passo 7: Teste Final

1. Execute o app
2. Clique em "Testar Firebase"
3. Se aparecer "✅ Firebase está funcionando corretamente!", o problema está resolvido
4. Se aparecer erro, verifique os logs e siga as instruções acima 