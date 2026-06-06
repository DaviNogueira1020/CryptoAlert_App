import 'package:dotenv/dotenv.dart';

class Environment {
  static final DotEnv _env = DotEnv()..load();

  static String get dbHost => _env['DB_HOST']!;
  static int get dbPort => int.parse(_env['DB_PORT']!);
  static String get dbName => _env['DB_NAME']!;
  static String get dbUser => _env['DB_USER']!;
  static String get dbPassword => _env['DB_PASSWORD']!;
}