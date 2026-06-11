import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/scheduler/alerts_scheduler.dart';
import 'package:crypto_alert_backend/scheduler/market_data_scheduler.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  print('[SCHEDULER] Starting background processes...');
  
  final alertsScheduler = AlertsScheduler();
  final marketDataScheduler = MarketDataScheduler();

  marketDataScheduler.start();
  alertsScheduler.start();

  // Inicia o servidor HTTP padrão do Dart Frog
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
  
  return server;
}