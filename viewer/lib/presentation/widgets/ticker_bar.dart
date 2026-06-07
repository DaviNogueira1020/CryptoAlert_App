// Barra de cotações que passa da esquerda para a direita em loop contínuo.
// Usa o Ticker do Flutter para não parar quando o usuário clica na tela.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Cada item é: (nome, preço, subiu?, variação%)
const _tickerItems = [
  ('USDT', r'$0,999', true, '0,01%'),
  ('XRP', r'$1', false, '0,01%'),
  ('BND', r'$583', false, '0,02%'),
  ('BTC', r'$85.000', true, '2,50%'),
  ('ETH', r'$2.500', true, '1,20%'),
  ('SOL', r'$145', false, '3,80%'),
  ('ADA', r'$0,75', true, '0,50%'),
];

class TickerBar extends StatefulWidget {
  const TickerBar({super.key});

  @override
  State<TickerBar> createState() => _TickerBarState();
}

class _TickerBarState extends State<TickerBar> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  Ticker? _ticker;
  Duration _lastTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Aguarda o primeiro frame ser renderizado antes de iniciar o movimento
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTicker());
  }

  void _startTicker() {
    // O Ticker é chamado a cada frame do app (~60x por segundo)
    _ticker = createTicker((elapsed) {
      if (!_scrollController.hasClients) return;
      final delta = elapsed - _lastTime;
      _lastTime = elapsed;
      final px = delta.inMicroseconds / 1000 * 0.03; // velocidade em pixels por segundo
      final max = _scrollController.position.maxScrollExtent;
      final next = _scrollController.offset + px;

      // Quando chega na metade da lista duplicada, volta ao começo sem o usuário perceber
      if (next >= max / 2) {
        _scrollController.jumpTo(next - max / 2);
      } else {
        _scrollController.jumpTo(next);
      }
    });
    _ticker!.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildItem(String name, String price, bool up, String pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(width: 4),
          Text(price, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 2),
          Icon(up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: up ? Colors.green : Colors.red, size: 16),
          Text(pct, style: TextStyle(color: up ? Colors.green : Colors.red, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lista duplicada para que o loop seja contínuo e invisível
    final doubled = [..._tickerItems, ..._tickerItems];

    return Container(
      height: 32,
      color: const Color(0xFF0F172A),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(), // impede o usuário de rolar manualmente
        itemCount: doubled.length,
        itemBuilder: (_, i) {
          final (name, price, up, pct) = doubled[i];
          return _buildItem(name, price, up, pct);
        },
      ),
    );
  }
}
