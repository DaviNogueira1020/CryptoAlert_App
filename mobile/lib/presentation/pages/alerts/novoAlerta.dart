import 'package:flutter/material.dart';
import 'package:mobile/presentation/pages/alerts/alertaModel.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';

class NovoAlerta extends StatefulWidget {
  final Alerta? alerta;

  const NovoAlerta({super.key, this.alerta});

  @override
  State<NovoAlerta> createState() => _NovoAlertaState();
}

class _NovoAlertaState extends State<NovoAlerta> {
  final _formKey = GlobalKey<FormState>();

  String _criptomoeda = 'BTC';
  String _tipoAlerta = 'Preço';
  final _percentualController = TextEditingController();
  String _condicao = 'Alta';

  final _tituloController = TextEditingController();
  String _prioridade = 'Alta';
  String _tipoNotificacao = 'Sistema';
  String _repeticao = 'Diariamente';
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();

  @override
  void dispose() {
    _percentualController.dispose();
    _tituloController.dispose();
    _descricaoController.dispose();
    _dataController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.alerta != null) {
      _criptomoeda = widget.alerta!.moeda;
      _percentualController.text = widget.alerta!.precoAlvo.toString();
      _tituloController.text = widget.alerta!.titulo;
      _descricaoController.text = widget.alerta!.descricao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111622),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.blueAccent.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Novo Alerta',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Criptomoeda',
                                  labelStyle: TextStyle(color: Colors.white54)),
                              onChanged: (val) =>
                                  setState(() => _criptomoeda = val),
                              initialValue: _criptomoeda,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _tipoAlerta,
                              dropdownColor: const Color(0xFF1E293B),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Tipo de alerta',
                                  labelStyle: TextStyle(color: Colors.white54)),
                              items: ['Preço', 'Volume', 'Notícias']
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _tipoAlerta = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _percentualController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Percentual de queda',
                                  hintText: '10%',
                                  hintStyle: TextStyle(color: Colors.white24),
                                  labelStyle: TextStyle(color: Colors.white54)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: _condicao == 'Alta'
                                            ? Colors.blueAccent
                                            : Colors.transparent),
                                    onPressed: () =>
                                        setState(() => _condicao = 'Alta'),
                                    child: const Text('Cria',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: _condicao == 'Baixa'
                                            ? Colors.blueAccent
                                            : Colors.transparent),
                                    onPressed: () =>
                                        setState(() => _condicao = 'Baixa'),
                                    child: const Text('Baixo',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _tituloController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Título',
                                  hintText: 'Ex: Alerta do Bitcoin',
                                  hintStyle: TextStyle(color: Colors.white24),
                                  labelStyle: TextStyle(color: Colors.white54)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _prioridade,
                              dropdownColor: const Color(0xFF1E293B),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Prioridade',
                                  labelStyle: TextStyle(color: Colors.white54)),
                              items: ['Alta', 'Média', 'Baixa']
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _prioridade = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _tipoNotificacao,
                              dropdownColor: const Color(0xFF1E293B),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Tipo de notificação',
                                  labelStyle: TextStyle(color: Colors.white54)),
                              items: ['Sistema', 'E-mail', 'Push']
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _tipoNotificacao = val!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _repeticao,
                              dropdownColor: const Color(0xFF1E293B),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Repetição',
                                  labelStyle: TextStyle(color: Colors.white54)),
                              items: ['Diariamente', 'Uma vez', 'Sempre']
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _repeticao = val!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descricaoController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: 'Descrição',
                            hintText: 'Digite detalhes do alerta...',
                            hintStyle: TextStyle(color: Colors.white24),
                            labelStyle: TextStyle(color: Colors.white54)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dataController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Data',
                                  hintText: 'dd/mm/aaaa',
                                  hintStyle: TextStyle(color: Colors.white24),
                                  labelStyle: TextStyle(color: Colors.white54)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _horaController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  labelText: 'Hora',
                                  hintText: '--:--',
                                  hintStyle: TextStyle(color: Colors.white24),
                                  labelStyle: TextStyle(color: Colors.white54)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF651FFF)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String cleanText = _percentualController.text
                                  .replaceAll('%', '')
                                  .trim();
                              double valorAlvo =
                                  double.tryParse(cleanText) ?? 0.0;

                              Navigator.pop(
                                context,
                                Alerta(
                                  moeda: _criptomoeda,
                                  precoAlvo: valorAlvo,
                                  titulo: _tituloController.text,
                                  descricao: _descricaoController.text,
                                ),
                              );
                            }
                          },
                          child: const Text('Salvar Alerta',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
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
