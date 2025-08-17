import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedPlan = 'annual'; // 'annual' or 'monthly'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Assine o Pro',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Banner superior
            Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x1A2196F3), Color(0x1A9C27B0)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.fitness_center, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Aproveite todos os recursos premium!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Recursos Premium
            _buildSectionTitle('Recursos Premium'),
            const SizedBox(height: 16),
            _buildFeatureList(const [
              'Experiência sem anúncios',
              'Crie e participe de grupos ilimitados',
              'Acesse recursos exclusivos',
              'Grave vídeos de até 1 minuto',
              'Personalize o tema do aplicativo',
            ]),

            const SizedBox(height: 32),

            // Recursos de Administrador
            _buildSectionTitle('Recursos de Administrador'),
            const SizedBox(height: 16),
            _buildFeatureList(const [
              'Definir limites de pontuação',
              'Atribuir moderadores do grupo',
              'Exportar dados do grupo',
              'Análises avançadas',
              'Personalização completa',
            ]),

            const SizedBox(height: 32),

            // Planos de Assinatura
            _buildSectionTitle('Escolha seu Plano'),
            const SizedBox(height: 16),
            _buildSubscriptionPlans(),

            const SizedBox(height: 32),

            // Botão de Continuar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Links de rodapé
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _showRestoreDialog(),
                  child: const Text(
                    'Restaurar',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () => _showTermsDialog(),
                  child: const Text(
                    'Termos',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () => _showPrivacyDialog(),
                  child: const Text(
                    'Privacidade',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feature,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubscriptionPlans() {
    return Column(
      children: [
        // Plano Anual
        GestureDetector(
          onTap: () => setState(() => _selectedPlan = 'annual'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _selectedPlan == 'annual'
                  ? const Color(0x1A2196F3)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedPlan == 'annual'
                    ? Colors.blue
                    : const Color(0x4D000000),
                width: _selectedPlan == 'annual' ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedPlan == 'annual'
                        ? Colors.blue
                        : Colors.transparent,
                    border: Border.all(
                      color: _selectedPlan == 'annual'
                          ? Colors.blue
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: _selectedPlan == 'annual'
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anual',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'R\$ 144,99/ano (R\$ 12,08/mês)',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '33% de desconto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Plano Mensal
        GestureDetector(
          onTap: () => setState(() => _selectedPlan = 'monthly'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _selectedPlan == 'monthly'
                  ? const Color(0x1A2196F3)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedPlan == 'monthly'
                    ? Colors.blue
                    : const Color(0x4D000000),
                width: _selectedPlan == 'monthly' ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedPlan == 'monthly'
                        ? Colors.blue
                        : Colors.transparent,
                    border: Border.all(
                      color: _selectedPlan == 'monthly'
                          ? Colors.blue
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: _selectedPlan == 'monthly'
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mensal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'R\$ 17,99/mês',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _activateProFeatures() async {
    // Simular ativação dos recursos Pro
    // Salvar o status Pro no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fitapp_pro_active', true);
    await prefs.setString('fitapp_pro_plan', _selectedPlan);
    await prefs.setString('fitapp_pro_activation_date', DateTime.now().toIso8601String());
  }

  void _confirmSubscription() {
    final planName = _selectedPlan == 'annual' ? 'Anual' : 'Mensal';
    final price = _selectedPlan == 'annual'
        ? 'R\$ 144,99/ano'
        : 'R\$ 17,99/mês';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Assinatura'),
          content: Text('Deseja assinar o plano $planName por $price?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Simular ativação do Pro
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                await _activateProFeatures();
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('🎉 Assinatura $planName confirmada! FitApp Pro ativado com sucesso!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Ver Clubes Pro',
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop(); // Voltar da tela de assinatura
                          // Navegar para clubes
                        },
                      ),
                    ),
                  );
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restaurar Compra'),
          content: const SingleChildScrollView(
            child: Text(
              'Restaurar Compras\n\n'
              'Se você já adquiriu uma assinatura Pro anteriormente e não consegue acessar os recursos premium, use esta opção para restaurar sua compra.\n\n'
              'Como funciona:\n'
              '• Conecte-se à mesma conta (Google Play/App Store) usada na compra original\n'
              '• Toque em "Restaurar" e aguarde a verificação\n'
              '• Seus recursos premium serão reativados automaticamente\n\n'
              'Problemas comuns:\n'
              '• Verifique se está usando a mesma conta da compra\n'
              '• Certifique-se de ter conexão com a internet\n'
              '• Aguarde alguns minutos para sincronização\n\n'
              'Se o problema persistir, entre em contato com nosso suporte através do email: suporte@fitapp.com',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aqui seria implementada a lógica real de restauração
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verificando compras anteriores...'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Restaurar'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Termos de Uso'),
          content: const SingleChildScrollView(
            child: Text(
              'TERMOS DE USO - FITAPP\n\n'
              '1. ACEITAÇÃO DOS TERMOS\n'
              'Ao utilizar o FitApp, você concorda com estes termos de uso. Se não concordar, não utilize o aplicativo.\n\n'
              '2. DESCRIÇÃO DO SERVIÇO\n'
              'O FitApp é uma plataforma de fitness que oferece:\n'
              '• Sistema de check-ins e acompanhamento de treinos\n'
              '• Gamificação com evolução de personagem\n'
              '• Recursos sociais e clubes\n'
              '• Funcionalidades premium mediante assinatura\n\n'
              '3. CONTA DO USUÁRIO\n'
              '• Você é responsável por manter a segurança de sua conta\n'
              '• Não compartilhe suas credenciais de acesso\n'
              '• Notifique-nos imediatamente sobre uso não autorizado\n\n'
              '4. ASSINATURA PRO\n'
              '• A assinatura Pro oferece recursos adicionais\n'
              '• Renovação automática conforme plano escolhido\n'
              '• Cancelamento pode ser feito a qualquer momento\n'
              '• Reembolsos seguem políticas da loja de aplicativos\n\n'
              '5. CONTEÚDO DO USUÁRIO\n'
              '• Você mantém direitos sobre o conteúdo que publica\n'
              '• Concede-nos licença para usar o conteúdo no app\n'
              '• Não publique conteúdo ofensivo ou inadequado\n\n'
              '6. LIMITAÇÃO DE RESPONSABILIDADE\n'
              '• O app é fornecido "como está"\n'
              '• Não garantimos disponibilidade ininterrupta\n'
              '• Use por sua conta e risco\n\n'
              '7. MODIFICAÇÕES\n'
              'Podemos alterar estes termos a qualquer momento. Continuação do uso implica aceitação das mudanças.\n\n'
              'Última atualização: Janeiro 2024\n'
              'Contato: legal@fitapp.com',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Política de Privacidade'),
          content: const SingleChildScrollView(
            child: Text(
              'POLÍTICA DE PRIVACIDADE - FITAPP\n\n'
              '1. INFORMAÇÕES QUE COLETAMOS\n'
              'Coletamos as seguintes informações:\n'
              '• Dados de cadastro (nome, email, foto de perfil)\n'
              '• Dados de atividade física (check-ins, treinos, fotos)\n'
              '• Dados de localização (quando autorizado)\n'
              '• Dados de uso do aplicativo (analytics)\n\n'
              '2. COMO USAMOS SUAS INFORMAÇÕES\n'
              '• Fornecer e melhorar nossos serviços\n'
              '• Personalizar sua experiência\n'
              '• Comunicar atualizações e novidades\n'
              '• Garantir segurança da plataforma\n'
              '• Cumprir obrigações legais\n\n'
              '3. COMPARTILHAMENTO DE DADOS\n'
              'Não vendemos seus dados pessoais. Compartilhamos apenas:\n'
              '• Com outros usuários (conforme suas configurações)\n'
              '• Com prestadores de serviços (Firebase, analytics)\n'
              '• Quando exigido por lei\n\n'
              '4. SEGURANÇA\n'
              '• Utilizamos criptografia para proteger dados\n'
              '• Acesso restrito a funcionários autorizados\n'
              '• Monitoramento contínuo de segurança\n'
              '• Backup regular dos dados\n\n'
              '5. SEUS DIREITOS\n'
              'Você pode:\n'
              '• Acessar seus dados pessoais\n'
              '• Corrigir informações incorretas\n'
              '• Solicitar exclusão da conta\n'
              '• Exportar seus dados\n'
              '• Revogar consentimentos\n\n'
              '6. COOKIES E TECNOLOGIAS\n'
              '• Usamos cookies para melhorar a experiência\n'
              '• Analytics para entender uso do app\n'
              '• Você pode desabilitar nas configurações\n\n'
              '7. RETENÇÃO DE DADOS\n'
              '• Mantemos dados enquanto conta estiver ativa\n'
              '• Dados podem ser mantidos para fins legais\n'
              '• Exclusão permanente mediante solicitação\n\n'
              '8. ALTERAÇÕES\n'
              'Esta política pode ser atualizada. Notificaremos sobre mudanças significativas.\n\n'
              'Última atualização: Janeiro 2024\n'
              'Contato: privacidade@fitapp.com',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
