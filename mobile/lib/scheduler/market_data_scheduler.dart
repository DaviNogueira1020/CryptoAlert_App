import 'dart:async';
import 'package:crypto_alert_backend/modules/market_data/market_data_updater_service.dart';

class MarketDataScheduler {
  final MarketDataUpdaterService _updaterService = MarketDataUpdaterService();

  Timer? _timer;

  void start(){
    print('[MARKET DATA SCHEDULER] Starting...');

    _timer = Timer.periodic(
      const Duration(minutes: 5),
      (_) async{
        print('[MARKET DATA SCHEDULER] Updating snapshots...');
        await _updaterService.updateMarketSnapshots();
      },
    );
  }

  void stop(){
    _timer?.cancel();
  }
}