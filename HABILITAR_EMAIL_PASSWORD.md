# 🔧 Habilitar Email/Password no Firebase Console

## Problema Identificado

O erro mais comum é que **Email/Password** não está habilitado no Firebase Console.

## Solução Passo a Passo

### 1. Acessar Firebase Console
1. Vá para: https://console.firebase.google.com/
2. Faça login com sua conta Google
3. Selecione o projeto: `academia-173e0`

### 2. Habilitar Email/Password
1. No menu lateral esquerdo, clique em **Authentication**
2. Clique na aba **Sign-in method**
3. Procure por **Email/Password** na lista
4. Se estiver **desabilitado** (cinza), clique nele
5. **Habilite** o toggle switch
6. Clique em **Save**

### 3. Verificar Configuração
1. Após habilitar, você deve ver:
   - ✅ Email/Password habilitado
   - ✅ Status: Enabled
   - ✅ Email link (passwordless sign-in) opcional

### 4. Testar no App
1. Execute o app: `flutter run`
2. Clique no botão **"Testar Firebase"** (amarelo)
3. Deve aparecer: "✅ Firebase está configurado corretamente!"

## Verificação Visual

### Antes (Problema)
```
📋 Métodos disponíveis: []
⚠️ Email/Password pode não estar habilitado no Firebase Console
```

### Depois (Correto)
```
📋 Métodos disponíveis: [password]
✅ Email/Password está habilitado
```

## Outros Métodos de Autenticação (Opcional)

Se quiser adicionar outros métodos:

### Google Sign-In
1. Em **Sign-in method**, clique em **Google**
2. Habilite o toggle
3. Configure o projeto OAuth

### Anônimo
1. Em **Sign-in method**, clique em **Anonymous**
2. Habilite o toggle

## Problemas Comuns

### 1. "You don't have permission"
- Verifique se você é **Owner** ou **Editor** do projeto
- Peça acesso ao administrador do projeto

### 2. "Project not found"
- Verifique se está no projeto correto: `academia-173e0`
- Verifique se o projeto existe

### 3. "Authentication not available"
- Verifique se o Firebase está ativo
- Aguarde alguns minutos após a configuração

## Comandos para Testar

```bash
# Limpar e reinstalar
flutter clean
flutter pub get

# Executar app
flutter run

# Verificar logs
flutter logs
```

## Próximos Passos

Após habilitar Email/Password:

1. **Teste o app** - deve funcionar agora
2. **Crie uma conta** - use email válido e senha de 6+ caracteres
3. **Faça login** - com a conta criada
4. **Verifique logs** - para confirmar que está funcionando

## Suporte

Se ainda houver problemas:

1. Verifique os logs no console
2. Verifique se o projeto Firebase está ativo
3. Verifique se as configurações estão corretas
4. Tente criar um novo projeto Firebase se necessário 