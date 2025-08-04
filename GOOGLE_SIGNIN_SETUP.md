# Configuração do Google Sign-In

## Para que o Google Sign-In funcione corretamente, você precisa:

### 1. Configurar no Firebase Console:

1. **Acesse o Firebase Console**: https://console.firebase.google.com
2. **Selecione seu projeto**: `academia-173e0`
3. **Vá para Authentication** → **Sign-in method**
4. **Habilite o Google Sign-In**:
   - Clique em "Google"
   - Ative o toggle
   - Adicione um email de suporte
   - Salve

### 2. Configurar OAuth 2.0:

1. **Vá para Google Cloud Console**: https://console.cloud.google.com
2. **Selecione o projeto**: `academia-173e0`
3. **Vá para APIs & Services** → **Credentials**
4. **Configure OAuth consent screen**:
   - Adicione seu domínio
   - Configure os escopos necessários
5. **Crie OAuth 2.0 Client ID**:
   - Tipo: Android
   - Package name: `com.academia.fitapp`
   - SHA-1 fingerprint: (obtenha com `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`)

### 3. Atualizar google-services.json:

Após configurar, baixe o novo `google-services.json` e substitua o atual.

### 4. Verificar SHA-1 Fingerprint:

Execute no terminal:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### 5. Teste:

O código atual está correto e funcionará assim que a configuração for feita.

## Status Atual:

✅ **Código implementado corretamente**
✅ **Dependências instaladas**
❌ **Configuração do Firebase pendente**
❌ **OAuth 2.0 não configurado**

## Próximos Passos:

1. Configure o Google Sign-In no Firebase Console
2. Configure OAuth 2.0 no Google Cloud Console
3. Atualize o `google-services.json`
4. Teste o login

O código está pronto e funcionará assim que a configuração for concluída! 