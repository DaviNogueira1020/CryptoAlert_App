import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/scheduler/alerts_scheduler.dart';
import 'package:crypto_alert_backend/scheduler/market_data_scheduler.dart';

import '../.dart_frog/server.dart' as generated;

Future<void> main() async{
  final alertsScheduler = AlertsScheduler();
  final marketDataScheduler = MarketDataScheduler();

  marketDataScheduler.start();
  alertsScheduler.start();

  final handler = generated.buildRootHandler();

  final port = int.parse(
    Platform.environment['PORT'] ?? '8080',
  );

  final server = await serve(
    handler,
    InternetAddress.anyIPv4,
    port,
  );

  print('Server listening on port ${server.port}');
}