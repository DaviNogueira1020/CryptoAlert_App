import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/presentation/widgets/ticker_bar.dart';
import 'package:mobile/services/alertasServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Conteúdo da tela de perfil, usado dentro do MainShell (sem Header/Footer próprios).
// Recebe "onTabSelected" para poder trocar de aba ao clicar nos cards de alertas.
class PerfilPageContent extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;
  const PerfilPageContent({super.key, this.onTabSelected});

  @override
  State<PerfilPageContent> createState() => _PerfilPageState();
}

// Versão completa da tela com Header e Footer, usada quando acessada via navegação direta
class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0B0F1A),
      body: Column(
        children: [
          Header(),
          TickerBar(),
          Expanded(child: PerfilPageContent()),
          Footer(initialBottonClicked: 3),
        ],
      ),
    );
  }
}

class _PerfilPageState extends State<PerfilPageContent> {
  // Controlador para o campo de usuário, com listener para salvar automaticamente a cada mudança
  final _usuarioController = TextEditingController();
  bool _notifApp = true;
  bool _notifEmail = true;

// Chave usada para salvar o nome do usuário 
  static const _keyUsuario = 'perfil_usuario';

// Ao iniciar, carrega o nome salvo e configura o listener para salvar a cada mudança
  @override
  void initState() {
    super.initState();
    _carregarUsuario();
    _usuarioController.addListener(_salvarUsuario);
  }

  // Lê o nome salvo anteriormente e preenche o campo ao abrir a tela
  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString(_keyUsuario) ?? '';
    if (mounted) setState(() => _usuarioController.text = nome);
  }

  // Salva o nome automaticamente a cada tecla digitada (sem precisar clicar em salvar)
  Future<void> _salvarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsuario, _usuarioController.text);
  }

//Atuiliza a tela quando as dependências mudam 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

// Remove o listener e o controlador para evitar vazamento de memória
  @override
  void dispose() {
    _usuarioController.removeListener(_salvarUsuario);
    _usuarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 43, right: 43, top: 16),
      child: SizedBox(
        width: 308,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.person_outline, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Meu perfil',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Gerencie suas informações e preferências',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Informações Pessoais
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1B3E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF22D3EE), width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Informações Pessoais',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Campo de usuário, que salva automaticamente a cada mudança
                        const SizedBox(height: 24),
                        const Text('USUÁRIO', style: TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 1.5)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _usuarioController,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: '[Usuário]',
                            hintStyle: const TextStyle(color: Colors.white38, fontSize: 16),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 12, right: 8),
                              child: Icon(Icons.person_outline, color: Colors.white60, size: 22),
                            ),
                            prefixIconConstraints: const BoxConstraints(),
                            filled: true,
                            fillColor: const Color(0xFF0D1B3E),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF22D3EE), width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Os cards de contagem se atualizam automaticamente quando alertas mudam
                  ValueListenableBuilder<int>(
                    valueListenable: AlertasService.tick,
                    builder: (context, _, __) => Row(
                      children: [
                        Expanded(
                          // Ao clicar leva para a aba de alertas
                          child: GestureDetector(
                            onTap: () => widget.onTabSelected?.call(0),
                            child: _StatCard(
                              label: 'Alertas criados',
                              value: '${AlertasService.totalAlertas}',
                              icon: Icons.notifications_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => widget.onTabSelected?.call(0),
                            child: _StatCard(
                              label: 'Alertas ativos',
                              value: '${AlertasService.alertasAtivos}',
                              icon: Icons.shield_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _StatCard(
                    label: 'Membro desde',
                    value: 'abr. de 2026',
                    icon: Icons.person_outline,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 20),

                  // Configurações
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1B3D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF22D3EE).withOpacity(0.4)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Configurações',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _NotifRow(
                          title: 'Notificação pelo aplicativo',
                          subtitle: 'Receba notificações sobre seus alertas',
                          value: _notifApp,
                          onChanged: (v) => setState(() => _notifApp = v),
                        ),
                        const Divider(color: Colors.white10, height: 24),
                        _NotifRow(
                          title: 'Notificação por e-mail',
                          subtitle: 'Receba e-mails quando seus alertas para fãs',
                          value: _notifEmail,
                          onChanged: (v) => setState(() => _notifEmail = v),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF22D3EE),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            child: const Text('Salvar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ajuda
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1B3D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF22D3EE).withOpacity(0.4)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Precisa de ajuda? Consulte a nossa documentação ou nosso suporte',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              // Botão de documentação 
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF22D3EE),
                                  side: const BorderSide(color: Color(0xFF22D3EE)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Documentação'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              // Botão de suporte
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF22D3EE),
                                  side: const BorderSide(color: Color(0xFF22D3EE)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Suporte'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
// Card  para exibir as estatísticas de alertas criados e ativos
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool fullWidth;

  const _StatCard({required this.label, required this.value, required this.icon, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(icon, color: Colors.white38, size: 22),
        ],
      ),
    );
  }
}

// Widget que exibe cada linha de configuração de notificação como efeito visual do botão de ativar/desativar
class _NotifRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifRow({required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: value ? const Color(0xFF22D3EE).withOpacity(0.15) : Colors.white10,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: value ? const Color(0xFF22D3EE) : Colors.white24),
            ),
            child: Text(
              'Ativo',
              style: TextStyle(
                color: value ? const Color(0xFF22D3EE) : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
