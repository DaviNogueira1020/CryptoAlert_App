import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/services/api_service.dart';

// Tela principal do app. Mostra a tabela de criptos com preço e variação 24h.
// Os dados vêm do backend (/market/overview), não são mais hardcoded.
class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  List<Map<String, dynamic>> _assets = [];
  bool _loading = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // Chama o backend e atualiza a lista de ativos na tela.
  // Chamado no initState e pelo pull-to-refresh.
  Future<void> _carregar() async {
    setState(() {
      _loading = true;
      _erro = null;
    });
    try {
      final data = await ApiService.getMarketOverview();
      setState(() {
        _assets = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _loading = false;
      });
    }
  }

  // Monta uma célula da tabela. O leading é o ícone opcional à esquerda do texto.
  Widget _buildCell(String text, {Widget? leading, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[leading, const SizedBox(width: 6)],
          Text(
            text,
            style: TextStyle(color: color ?? Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Linha de cabeçalho da tabela.
  TableRow _buildHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFF111827)),
      children: [
        _buildCell('#'),
        _buildCell('Coin'),
        _buildCell('Price'),
        _buildCell('24h'),
      ],
    );
  }

  // Monta uma linha da tabela a partir dos dados de um ativo.
  // Se change_24h ainda for null (backend em desenvolvimento), mostra traço.
  TableRow _buildRow(int index, Map<String, dynamic> asset) {
    final name = asset['name'] ?? asset['symbol'] ?? '—';
    final price = asset['price_usd'];
    final change = asset['change_24h'];
    final imageUrl = asset['image_url'] as String?;

    final priceText = price != null
        ? '\$${(price as num).toStringAsFixed(2)}'
        : '—';

    final changeText = change != null
        ? '${(change as num) >= 0 ? '+' : ''}${(change as num).toStringAsFixed(2)}%'
        : '—';

    final isPositive = change != null && (change as num) >= 0;
    final changeColor = change == null
        ? Colors.grey
        : (isPositive ? Colors.green : Colors.red);

    // Tenta carregar a imagem da cripto pelo URL que o backend fornece.
    Widget? leadingIcon;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      leadingIcon = Image.network(
        imageUrl,
        width: 20,
        height: 20,
        errorBuilder: (_, __, ___) => const SizedBox(),
      );
    }

    return TableRow(children: [
      _buildCell('${index + 1}'),
      _buildCell(name, leading: leadingIcon),
      _buildCell(priceText),
      _buildCell(
        changeText,
        leading: change != null
            ? Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: changeColor,
                size: 14,
              )
            : null,
        color: changeColor,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF06B6D4)),
                  )
                : _erro != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Erro ao carregar dados',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            const SizedBox(height: 12),
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
                    : RefreshIndicator(
                        // Puxar pra baixo recarrega os dados do backend.
                        onRefresh: _carregar,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: SizedBox(
                              width: 460,
                              child: Container(
                                color: const Color(0xFF0F1B3D),
                                child: Table(
                                  border: TableBorder.all(
                                    color: const Color(0xFF22D3EE),
                                  ),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    _buildHeader(),
                                    ..._assets.asMap().entries.map(
                                          (e) => _buildRow(e.key, e.value),
                                        ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
          const Footer(initialBottonClicked: 1),
        ],
      ),
    );
  }
}
