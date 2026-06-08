import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/presentation/widgets/coin_detail_screen.dart';

class CoinData {
  final String rank;
  final String name;
  final String symbol;
  final String price;
  final String change24h;
  final bool isPositive;

  const CoinData({
    required this.rank,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.isPositive,
  });
}

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
  CoinData? _selectedCoin;

  final List<CoinData> _coins = const [
    CoinData(
        rank: "1",
        name: "Bitcoin",
        symbol: "BTC",
        price: "\$85,000",
        change24h: "+2.5%",
        isPositive: true),
    CoinData(
        rank: "2",
        name: "Ethereum",
        symbol: "ETH",
        price: "\$2,500",
        change24h: "+1.2%",
        isPositive: true),
    CoinData(
        rank: "3",
        name: "Solana",
        symbol: "SOL",
        price: "\$145",
        change24h: "-3.8%",
        isPositive: false),
    CoinData(
        rank: "4",
        name: "Cardano",
        symbol: "ADA",
        price: "\$0.75",
        change24h: "+0.5%",
        isPositive: true),
    CoinData(
        rank: "5",
        name: "XRP",
        symbol: "XRP",
        price: "\$2.10",
        change24h: "-1.1%",
        isPositive: false),
    CoinData(
        rank: "6",
        name: "Dogecoin",
        symbol: "DOGE",
        price: "\$0.18",
        change24h: "+7.4%",
        isPositive: true),
  ];

  List<CoinData> get _filteredCoins {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _coins;
    return _coins
        .where((c) =>
            c.name.toLowerCase().contains(query) ||
            c.symbol.toLowerCase().contains(query))
        .toList();
  }

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

  Widget buildPainelHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                  style:
                      const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => setState(() => _lastUpdate = DateTime.now()),
            icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
            label: const Text(
              'Atualizar',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        border: Border(bottom: BorderSide(color: Color(0xFF22D3EE))),
      ),
      child: Row(
        children: [
          SizedBox(width: 44, child: _headerCell("#")),
          Expanded(child: _headerCell("Moeda")),
          Expanded(child: _headerCell("Preço")),
          Expanded(child: _headerCell("24 Horas")),
        ],
      ),
    );
  }

  Widget _buildCoinRow(CoinData coin) {
    final changeColor = coin.isPositive ? Colors.green : Colors.red;

    return InkWell(
      onTap: () => setState(() => _selectedCoin = coin),
      splashColor: const Color(0xFF22D3EE).withOpacity(0.1),
      highlightColor: const Color(0xFF22D3EE).withOpacity(0.05),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF1E3A5F))),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 44,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  coin.rank,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                ),
              ),
            ),

            // Nome + ícone — alinhado à esquerda com padding pra respirar do #
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10), // espaço extra do lado do #
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7931A).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.currency_bitcoin,
                          color: Color(0xFFF7931A), size: 16),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coin.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        Text(coin.symbol,
                            style: const TextStyle(
                                color: Color(0xFF6B7280), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Preço
            Expanded(
              child: Text(
                coin.price,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),

            // Variação
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    coin.isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: changeColor,
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    coin.change24h,
                    style: TextStyle(
                        color: changeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTable() {
    final coins = _filteredCoins;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B3D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF22D3EE), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            _buildTableHeader(),
            if (coins.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Nenhuma moeda encontrada',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              )
            else
              ...coins.map(_buildCoinRow),
          ],
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
          Expanded(
            child: SingleChildScrollView(
              child: _selectedCoin != null
                  ? CoinDetailScreen(
                      rank: _selectedCoin!.rank,
                      coin: _selectedCoin!.name,
                      symbol: _selectedCoin!.symbol,
                      price: _selectedCoin!.price,
                      change24h: _selectedCoin!.change24h,
                      isPositive: _selectedCoin!.isPositive,
                      onBack: () => setState(() => _selectedCoin = null),
                    )
                  : Column(
                      children: [
                        buildPainelHeader(),
                        buildSearchBar(),
                        buildTable(),
                        const SizedBox(height: 16),
                      ],
                    ),
            ),
          ),
          const Footer(initialBottonClicked: 1),
        ],
      ),
    );
  }
}
