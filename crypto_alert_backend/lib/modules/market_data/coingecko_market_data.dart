class CoinGeckoMarketData{
  final double? marketCap;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? change7d;
  final double? change30d;

  const CoinGeckoMarketData({
    this.marketCap,
    this.circulatingSupply,
    this.totalSupply,
    this.change7d,
    this.change30d,
  });

  factory CoinGeckoMarketData.fromJson(Map<String, dynamic> json){
    return CoinGeckoMarketData(
      marketCap: (json['market_cap'] as num?)?.toDouble(),
      circulatingSupply:
          (json['circulating_supply'] as num?)?.toDouble(),
      totalSupply:
           (json['total_supply'] as num?)?.toDouble(),
      change7d:
          (json['price_change_percentage_7d_in_currency'] as num?)
              ?.toDouble(),
      change30d:
          (json['price_change_percentage_30d_in_currency'] as num?)
              ?.toDouble(),
    );
  }
}