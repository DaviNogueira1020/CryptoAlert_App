import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/presentation/widgets/ticker_bar.dart';
import 'package:mobile/models/alerta_model.dart';
import 'package:mobile/services/alertasServices.dart';

class NovoAlertaPage extends StatefulWidget {
  const NovoAlertaPage({super.key});

  @override
  State<NovoAlertaPage> createState() => _NovoAlertaPageState();
}

class _NovoAlertaPageState extends State<NovoAlertaPage> {
  bool _condicaoCima = true;
  String _prioridade = 'Alta';
  String _tipoNotificacao = 'Sistema';
  String _repeticao = 'Diariamente';

  final _criptoController = TextEditingController();
  final _tipoAlertaController = TextEditingController();
  final _porcentualController = TextEditingController();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();

  bool get _podeSalvar =>
      _criptoController.text.trim().isNotEmpty &&
      _porcentualController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _criptoController.addListener(() => setState(() {}));
    _porcentualController.addListener(() => setState(() {}));
  }

  void _salvar() {
    if (_criptoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a cripto moeda'), backgroundColor: Colors.red),
      );
      return;
    }
    AlertasService.adicionar(Alerta(
      cripto: _criptoController.text.trim(),
      tipoAlerta: _tipoAlertaController.text.trim(),
      porcentual: _porcentualController.text.trim(),
      condicaoCima: _condicaoCima,
      titulo: _tituloController.text.trim(),
      prioridade: _prioridade,
      tipoNotificacao: _tipoNotificacao,
      repeticao: _repeticao,
      descricao: _descricaoController.text.trim(),
      data: _dataController.text.trim(),
      hora: _horaController.text.trim(),
    ));
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _criptoController.dispose();
    _tipoAlertaController.dispose();
    _porcentualController.dispose();
    _tituloController.dispose();
    _descricaoController.dispose();
    _dataController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF22D3EE)),
      ),
    );
  }

  Widget _sectionTitle(int number, String title) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF6366F1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _dropdownField(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: const Color(0xFF1E293B),
            underline: const SizedBox(),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Column(
        children: [
          const Header(),
          const TickerBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: SizedBox(
                width: 340,
                height: 530,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1B3D),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF22D3EE).withOpacity(0.5)),
                  ),
                  child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Novo Alerta',
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(height: 32),

                    _sectionTitle(1, 'Informações básicas'),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(text: const TextSpan(children: [
                                TextSpan(text: 'Cripto moeda', style: TextStyle(color: Colors.white54, fontSize: 12)),
                                TextSpan(text: ' *', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 12, fontWeight: FontWeight.bold)),
                              ])),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _criptoController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration(''),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tipo de alerta', style: TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _tipoAlertaController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration(''),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(text: const TextSpan(children: [
                                TextSpan(text: 'Percentual', style: TextStyle(color: Colors.white54, fontSize: 12)),
                                TextSpan(text: ' *', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 12, fontWeight: FontWeight.bold)),
                              ])),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _porcentualController,
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.number,
                                inputFormatters: [_PercentFormatter()],
                                decoration: _inputDecoration('0 - 100%'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Condição', style: TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _condicaoCima = true),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: _condicaoCima ? const Color(0xFF22D3EE) : const Color(0xFF1E293B),
                                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                          border: Border.all(color: Colors.white10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Cima', style: TextStyle(color: _condicaoCima ? Colors.black : Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                                            Icon(Icons.arrow_upward, size: 14, color: _condicaoCima ? Colors.black : Colors.white),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _condicaoCima = false),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: !_condicaoCima ? const Color(0xFF22D3EE) : const Color(0xFF1E293B),
                                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                                          border: Border.all(color: Colors.white10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Baixo', style: TextStyle(color: !_condicaoCima ? Colors.black : Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                                            Icon(Icons.arrow_downward, size: 14, color: !_condicaoCima ? Colors.black : Colors.white),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    _sectionTitle(2, 'Configurações avançadas'),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Título', style: TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _tituloController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration(''),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _dropdownField('Prioridade', _prioridade, ['Alta', 'Média', 'Baixa'], (v) => setState(() => _prioridade = v!))),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _dropdownField('Tipo de notificação', _tipoNotificacao, ['Sistema', 'Email', 'SMS'], (v) => setState(() => _tipoNotificacao = v!))),
                        const SizedBox(width: 12),
                        Expanded(child: _dropdownField('Repetição', _repeticao, ['Diariamente', 'Semanalmente', 'Mensalmente', 'Nunca'], (v) => setState(() => _repeticao = v!))),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text('Descrição', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _descricaoController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 4,
                      decoration: _inputDecoration(''),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Data', style: TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _dataController,
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.number,
                                inputFormatters: [_DateFormatter()],
                                decoration: _inputDecoration('DD/MM/YYYY'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Hora', style: TextStyle(color: Colors.white54, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _horaController,
                                style: const TextStyle(color: Colors.white),
                                keyboardType: TextInputType.number,
                                inputFormatters: [_TimeFormatter()],
                                decoration: _inputDecoration('HH:MM'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white54,
                              side: const BorderSide(color: Colors.white24),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _podeSalvar ? _salvar : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF22D3EE),
                              disabledBackgroundColor: const Color(0xFF22D3EE).withOpacity(0.3),
                              foregroundColor: Colors.black,
                              disabledForegroundColor: Colors.black45,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            child: const Text('Salvar Alerta'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
          const Footer(initialBottonClicked: 0),
        ],
      ),
    );
  }
}

class _PercentFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    final value = int.parse(digits);
    if (value > 100) return oldValue;
    final formatted = '$value%';
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      final d = int.parse(digits[i]);

      // Limita primeiro dígito do dia a 0-3
      if (i == 0 && d > 3) return oldValue;
      // Limita dia a 01-31
      if (i == 1 && digits.length >= 2) {
        final dd = int.parse(digits.substring(0, 2));
        if (dd < 1 || dd > 31) return oldValue;
      }
      // Limita primeiro dígito do mês a 0-1
      if (i == 2 && d > 1) return oldValue;
      // Limita mês a 01-12
      if (i == 3 && digits.length >= 4) {
        final mm = int.parse(digits.substring(2, 4));
        if (mm < 1 || mm > 12) return oldValue;
      }

      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _TimeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write(':');
      final d = int.parse(digits[i]);

      // Limita primeiro dígito da hora a 0-2
      if (i == 0 && d > 2) return oldValue;
      // Limita hora a 00-23
      if (i == 1 && digits.length >= 2) {
        final hh = int.parse(digits.substring(0, 2));
        if (hh > 23) return oldValue;
      }
      // Limita primeiro dígito dos minutos a 0-5
      if (i == 2 && d > 5) return oldValue;

      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
