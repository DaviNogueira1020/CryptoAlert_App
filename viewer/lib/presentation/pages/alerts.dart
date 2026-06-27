import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/banco_de_dados.dart';

// Tela de alertas do usuário. Mostra a lista de alertas criados,
// permite criar novos, ativar/desativar e deletar.
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Map<String, dynamic>> _alerts = [];
  bool _loading = true;
  String? _erro;

  // Campos do formulário de criação de alerta.
  final _symbolController = TextEditingController();
  final _targetController = TextEditingController();
  String _selectedType = 'above';

  // Pega a key do usuário salva localmente pelo banco_de_dados.dart.
  // É essa key que o backend usa pra identificar o dono dos alertas.
  String? get _userKey => BancoDeDados().keySalva();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  // Busca os alertas do usuário no backend.
  Future<void> _carregar() async {
    final key = _userKey;
    if (key == null) return;
    setState(() {
      _loading = true;
      _erro = null;
    });
    try {
      final data = await ApiService.getAlerts(key);
      setState(() {
        _alerts = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loading = false;
      });
    }
  }

  // Valida os campos e envia o novo alerta pro backend.
  Future<void> _criarAlerta() async {
    final key = _userKey;
    if (key == null) return;

    final symbol = _symbolController.text.trim().toUpperCase();
    final targetText = _targetController.text.trim();

    if (symbol.isEmpty || targetText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha símbolo e valor alvo')),
      );
      return;
    }

    final target = double.tryParse(targetText);
    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor alvo inválido')),
      );
      return;
    }

    try {
      await ApiService.createAlert(
        key,
        symbol: symbol,
        target: target,
        type: _selectedType,
      );
      _symbolController.clear();
      _targetController.clear();
      Navigator.pop(context);
      _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar: $e')),
      );
    }
  }

  // Remove o alerta e recarrega a lista.
  Future<void> _deletar(String id) async {
    final key = _userKey;
    if (key == null) return;
    try {
      await ApiService.deleteAlert(key, id);
      _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar: $e')),
      );
    }
  }

  // Inverte o estado ativo/inativo do alerta.
  Future<void> _toggle(String id, bool ativoAtual) async {
    final key = _userKey;
    if (key == null) return;
    try {
      await ApiService.toggleAlert(key, id, !ativoAtual);
      _carregar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  // Abre o modal de criação de alerta.
  void _abrirModalCriar() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          backgroundColor: const Color(0xFF0F1B3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF06B6D4), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Novo Alerta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _symbolController,
                  style: const TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.characters,
                  decoration: _inputDecoration('Símbolo (ex: BTCUSDT)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _targetController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Valor alvo (ex: 65000)'),
                ),
                const SizedBox(height: 12),
                // Botões pra escolher se o alerta é quando o preço sobe ou cai.
                Row(children: [
                  const Text('Tipo:', style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 12),
                  _typeButton('above', 'Acima', setModalState),
                  const SizedBox(width: 8),
                  _typeButton('below', 'Abaixo', setModalState),
                ]),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _criarAlerta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Criar Alerta',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Estilo padrão dos campos de texto do modal.
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF06B6D4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
    );
  }

  // Botão de seleção de tipo (acima/abaixo).
  // setModalState atualiza o visual dentro do Dialog.
  Widget _typeButton(
      String value, String label, StateSetter setModalState) {
    final selected = _selectedType == value;
    return GestureDetector(
      onTap: () => setModalState(() => _selectedType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF6366F1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  // Card de cada alerta na lista. Mostra símbolo, valor alvo, tipo,
  // um toggle pra ativar/desativar e botão de deletar.
  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final ativo = alert['active'] == true;
    final symbol = alert['symbol'] ?? '—';
    final target = alert['target'];
    final type = alert['type'] ?? '—';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ativo ? const Color(0xFF06B6D4) : Colors.grey.shade800,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Alvo: \$${target?.toString() ?? '—'}  •  ${type == 'above' ? '↑ Acima' : '↓ Abaixo'}',
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: ativo,
            activeColor: const Color(0xFF06B6D4),
            onChanged: (_) => _toggle(alert['id'], ativo),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _deletar(alert['id']),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      // Botão flutuante no canto inferior direito pra abrir o modal de criação.
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirModalCriar,
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const Header(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meus Alertas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_alerts.length} alerta(s)',
                  style: const TextStyle(color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF06B6D4),
                    ),
                  )
                : _erro != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Erro ao carregar alertas',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            TextButton(
                              onPressed: _carregar,
                              child: const Text(
                                'Tentar novamente',
                                style: TextStyle(color: Color(0xFF06B6D4)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _alerts.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum alerta cadastrado.\nToque em + para criar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 15,
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _carregar,
                            child: ListView.builder(
                              itemCount: _alerts.length,
                              itemBuilder: (_, i) =>
                                  _buildAlertCard(_alerts[i]),
                            ),
                          ),
          ),
          const Footer(initialBottonClicked: 2),
        ],
      ),
    );
  }
}
