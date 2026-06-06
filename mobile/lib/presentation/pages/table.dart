import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';

class TableScreen extends StatefulWidget {
  final Color textColor;

  const TableScreen({
    this.textColor = Colors.white,
    super.key,
  });

  @override
  State<TableScreen> createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  DateTime _lastUpdate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final h = _lastUpdate.hour.toString().padLeft(2, '0');
    final m = _lastUpdate.minute.toString().padLeft(2, '0');
    final s = _lastUpdate.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  // ─── Painel de cotações (parte de cima) ───────────────────────────────────

  Widget buildPainelHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título + última atualização
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Painel de cotações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Última atualização: $_formattedTime',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Botão Atualizar
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _lastUpdate = DateTime.now();
              });
            },
            icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
            label: const Text(
              'Atualizar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF22D3EE), width: 1.5),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(color: Color(0xFF6B7280)),
          prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          setState(() {}); // filtra a tabela se quiser
        },
      ),
    );
  }

  // ─── Células e linhas da tabela (igual ao seu código original) ────────────

  Widget buildCell(String text, {Widget? leading, Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: TextStyle(color: color ?? widget.textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  TableRow buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xff111827)),
      children: [
        buildCell("#"),
        buildCell("Moeda"),
        buildCell("Preço"),
        buildCell("24 Horas"),
      ],
    );
  }

  TableRow buildDataRow(
    String rank,
    String coin,
    String price,
    String change24h,
    bool isPositive, {
    String? coinSvg,
    String? changeSvg,
  }) {
    return TableRow(
      children: [
        buildCell(rank),
        buildCell(
          coin,
          leading: coinSvg == null
              ? Icon(Icons.currency_bitcoin, color: widget.textColor, size: 18)
              : SvgPicture.asset(coinSvg, width: 18, height: 18),
        ),
        buildCell(price),
        buildCell(
          change24h,
          leading: changeSvg == null
              ? Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 18,
                )
              : SvgPicture.asset(
                  changeSvg,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    isPositive ? Colors.green : Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
          color: isPositive ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget buildTable() {
    return Center(
      child: SizedBox(
        width: 460,
        child: Container(
          color: const Color(0xff0F1B3D),
          child: Table(
            border: TableBorder.all(color: const Color(0xff22D3EE), width: 1),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              buildHeaderRow(),
              buildDataRow("1", "Bitcoin", "\$85,000", "+2.5%", true),
              buildDataRow("2", "Ethereum", "\$2,500", "+1.2%", true),
              buildDataRow("3", "Solana", "\$145", "-3.8%", false),
              buildDataRow("4", "Cardano", "\$0.75", "+0.5%", true),
              buildDataRow("5", "XRP", "\$2.10", "-1.1%", false),
              buildDataRow("6", "Dogecoin", "\$0.18", "+7.4%", true),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Column(
        children: [
          const Header(),

          // ── Parte nova ──
          buildPainelHeader(),
          buildSearchBar(),
          // ────────────────

          Expanded(child: buildTable()),

          const Footer(initialBottonClicked: 1),
        ],
      ),
    );
  }
}
