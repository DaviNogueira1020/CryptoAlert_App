import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/ticker_bar.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/presentation/pages/alerts/novo_alerta_page.dart';
import 'package:mobile/services/alertasServices.dart';
import 'package:mobile/models/alerta_model.dart';

class AlertasPageContent extends StatefulWidget {
  const AlertasPageContent({super.key});

  @override
  State<AlertasPageContent> createState() => _AlertasPageContentState();
}

class _AlertasPageContentState extends State<AlertasPageContent> {
  List<Alerta> get _alertas => AlertasService.alertas;

  Future<void> _confirmarRemocao(int index) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF0F1B3D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              const Text('Deletar Alerta',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Tem certeza que deseja deletar este alerta?',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white54,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Deletar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmado == true) {
      AlertasService.remover(index);
    }
  }

  void _abrirNovoAlerta() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NovoAlertaPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 313,
        child: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Text('Meus Alertas',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _abrirNovoAlerta,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Novo Alerta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22D3EE),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Gere seus alertas  de preço de\ncriptomoedas',
              style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 24),
          // ValueListenableBuilder escuta o "tick" do AlertasService.
          // Toda vez que um alerta é adicionado, removido ou alterado, essa parte se redesenha.
          ValueListenableBuilder<int>(
            valueListenable: AlertasService.tick,
            builder: (_, __, ___) => SizedBox(
              height: 392,
              child: _alertas.isEmpty ? _emptyState() : _listaAlertas(),
            ),
          ),
        ],
      ),
    ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B3D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_outlined, color: Colors.white38, size: 60),
          SizedBox(height: 16),
          Text('Nenhum alerta criado ainda',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text('Clique em "Novo Alerta" para começar',
              style: TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _listaAlertas() {
    return ListView.separated(
      itemCount: _alertas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final a = _alertas[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1B3D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF22D3EE).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF22D3EE).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    a.condicaoCima ? Icons.arrow_upward : Icons.arrow_downward,
                    color: a.condicaoCima ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.titulo.isNotEmpty ? a.titulo : a.cripto,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('${a.cripto}  •  ${a.condicaoCima ? "Cima" : "Baixo"}  •  ${a.porcentual}',
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    Text('${a.prioridade}  •  ${a.repeticao}',
                        style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => AlertasService.toggleAtivo(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: a.ativo ? const Color(0xFF22D3EE).withOpacity(0.15) : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: a.ativo ? const Color(0xFF22D3EE) : Colors.white24),
                  ),
                  child: Text(
                    a.ativo ? 'Ativo' : 'Inativo',
                    style: TextStyle(
                      color: a.ativo ? const Color(0xFF22D3EE) : Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 20),
                onPressed: () => _confirmarRemocao(i),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Versão completa da tela com Header e Footer, usada quando acessada via navegação direta
class AlertasPage extends StatelessWidget {
  const AlertasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: const Column(
        children: [
          Header(),
          TickerBar(),
          Expanded(child: AlertasPageContent()),
          Footer(initialBottonClicked: 0),
        ],
      ),
    );
  }
}