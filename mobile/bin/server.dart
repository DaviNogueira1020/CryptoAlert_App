import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/scheduler/alerts_scheduler.dart';

import '../.dart_frog/server.dart' as generated;

Future<void> main() async{
  final scheduler = AlertsScheduler();

  scheduler.start();

  final handler = generated.buildRootHandler();

  final server = await serve(
    handler,
    InternetAddress.anyIPv4,
    8080,
  );

  print('Server listening on port ${server.port}');
}