# Configuração do Firebase - Solução de Problemas

## Problemas Identificados

### 1. Verificar Configuração do Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto `academia-173e0`
3. Vá para **Authentication** > **Sign-in method**
4. Verifique se **Email/Password** está habilitado
5. Se não estiver, habilite-o

### 2. Verificar Configuração do Android

1. Verifique se o arquivo `google-services.json` está correto
2. Verifique se o `package_name` no arquivo corresponde ao `applicationId` no `build.gradle.kts`
3. Execute `flutter clean` e `flutter pub get`

### 3. Verificar Configuração da Web

1. Verifique se o domínio está autorizado no Firebase Console
2. Vá para **Authentication** > **Settings** > **Authorized domains**
3. Adicione `localhost` para desenvolvimento local

### 4. Comandos para Testar

```bash
# Limpar cache
flutter clean

# Reinstalar dependências
flutter pub get

# Executar no Android
flutter run

# Executar na Web
flutter run -d chrome
```

### 5. Logs de Debug

Os logs agora mostram:
- ✅ Firebase inicializado com sucesso
- ✅ Firebase Auth disponível
- 🔐 Tentando fazer login com email: [email]
- ❌ Erro Firebase Auth: [código] - [mensagem]

### 6. Possíveis Soluções

1. **Erro de rede**: Verifique conexão com internet
2. **Erro de configuração**: Verifique Firebase Console
3. **Erro de domínio**: Adicione domínio autorizado
4. **Erro de package**: Verifique `google-services.json`

### 7. Teste Manual

1. Abra o app
2. Tente criar uma conta com email válido e senha de 6+ caracteres
3. Verifique os logs no console
4. Se houver erro, verifique o código de erro no Firebase Console 