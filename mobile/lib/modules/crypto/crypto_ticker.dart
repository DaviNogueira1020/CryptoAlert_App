class CryptoTicker {
  final String symbol;
  final double price;
  final double? change24h;
  final double? volume24h;

  CryptoTicker({
    required this.symbol,
    required this.price,
    this.change24h,
    this.volume24h,
  });
}