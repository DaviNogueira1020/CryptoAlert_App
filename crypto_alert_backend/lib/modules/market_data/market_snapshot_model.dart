class MarketSnapshot{
  final String symbol;
  final double priceUsd;
  final double? change24h;
  final double? volume24h;
  final DateTime updatedAt;

  MarketSnapshot({
    required this.symbol,
    required this.priceUsd,
    this.change24h,
    this.volume24h,
    required this.updatedAt,
  });
}