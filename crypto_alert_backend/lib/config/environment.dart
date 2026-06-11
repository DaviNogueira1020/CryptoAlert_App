import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:crypto_alert_backend/core/exceptions/not_found_exception.dart';

class Environment {
  static final DotEnv _env = DotEnv()..load();

  static String _getVar(String key) {
    // 1. Tenta pegar do Sistema Operacional (Railway/Docker)
    // 2. Se for nulo, tenta pegar do arquivo .env (Local)
    final value = Platform.environment[key] ?? _env[key];
    
    if (value == null || value.isEmpty) {
      throw NotFoundException('Variável de ambiente ausente: $key');
    }
    return value;
  }

  static String get dbHost => _env['DB_HOST']!;
  static int get dbPort => int.parse(_env['DB_PORT']!);
  static String get dbName => _env['DB_NAME']!;
  static String get dbUser => _env['DB_USER']!;
  static String get dbPassword => _env['DB_PASSWORD']!;
}