import 'package:flutter/material.dart';

class CoinDetailScreen extends StatefulWidget {
  final String rank;
  final String coin;
  final String symbol;
  final String price;
  final String change24h;
  final bool isPositive;
  final VoidCallback onBack;

  const CoinDetailScreen({
    required this.rank,
    required this.coin,
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.isPositive,
    required this.onBack,
    super.key,
  });

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  final TextEditingController _amountController =
      TextEditingController(text: '1');

  double get _priceValue =>
      double.tryParse(
        widget.price.replaceAll('\$', '').replaceAll(',', ''),
      ) ??
      0;

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 1;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B3D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3A5F)),
      ),
      child: child,
    );
  }

  Widget _infoBox(String label, String value, {Color? valueColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                )),
          ],
        ),
      ),
    );
  }

  Widget _conversionRow(String currency, String value,
      {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(currency,
              style:
                  const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
          Text(value,
              style: TextStyle(
                color: highlight ? const Color(0xFF22D3EE) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              )),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              )),
        ],
      ),
    );
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final changeColor =
        widget.isPositive ? Colors.green : Colors.red;

    final double usd = _priceValue * _amount;
    final double brl = usd * 5.15;
    final double eur = usd * 0.92;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Voltar ────────────────────────────────────────────────────────
        GestureDetector(
          onTap: widget.onBack,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_ios_new,
                    color: Color(0xFF22D3EE), size: 14),
                SizedBox(width: 6),
                Text(
                  'Voltar ao Dashboard',
                  style: TextStyle(
                      color: Color(0xFF22D3EE), fontSize: 13),
                ),
              ],
            ),
          ),
        ),

        // ── Card principal ────────────────────────────────────────────────
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho: ícone + nome + botão
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7931A).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.currency_bitcoin,
                            color: Color(0xFFF7931A), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.coin,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Text(widget.symbol,
                              style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Criar alerta',
                        style:
                            TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Linha 1: preço + variação 24h
              Row(
                children: [
                  _infoBox('Preço atual (USD)', widget.price),
                  const SizedBox(width: 8),
                  _infoBox('Variação 24H', widget.change24h,
                      valueColor: changeColor),
                ],
              ),
              const SizedBox(height: 8),

              // Linha 2: máxima + mínima (estático por ora)
              Row(
                children: [
                  _infoBox('Máxima 24H', widget.price),
                  const SizedBox(width: 8),
                  _infoBox('Mínima 24H', widget.price),
                ],
              ),
              const SizedBox(height: 8),

              // Linha 3: variação 7d + 30d
              Row(
                children: [
                  _infoBox('Variação 7d', widget.change24h,
                      valueColor: changeColor),
                  const SizedBox(width: 8),
                  _infoBox('Variação 30d', widget.change24h,
                      valueColor: changeColor),
                ],
              ),
              const SizedBox(height: 8),

              // Capitalização (linha inteira)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Capitalização de mercado',
                        style: TextStyle(
                            color: Color(0xFF6B7280), fontSize: 11)),
                    SizedBox(height: 4),
                    Text('\$ 1,3 tri',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Card conversor ────────────────────────────────────────────────
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('\$ Conversor',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 2),
              Text('Quantidade de ${widget.coin}',
                  style: const TextStyle(
                      color: Color(0xFF6B7280), fontSize: 12)),
              const SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF111827),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFF1E3A5F)),
              _conversionRow('USD', '\$ ${usd.toStringAsFixed(2)}'),
              _conversionRow(
                  'BRL (R\$)', 'R\$ ${brl.toStringAsFixed(2)}',
                  highlight: true),
              _conversionRow('EUR (£)', '£ ${eur.toStringAsFixed(2)}'),
            ],
          ),
        ),

        // ── Card informações ──────────────────────────────────────────────
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informações sobre ${widget.coin}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 8),
              const Divider(color: Color(0xFF1E3A5F)),
              _infoRow('Volume 24H', '\$ 48 bi'),
              const Divider(color: Color(0xFF1E3A5F), height: 1),
              _infoRow('Oferta circulante', '20 M ${widget.symbol}'),
              const Divider(color: Color(0xFF1E3A5F), height: 1),
              _infoRow('Oferta total', '20 M ${widget.symbol}'),
            ],
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
