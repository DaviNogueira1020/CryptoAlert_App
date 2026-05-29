import 'package:postgres/postgres.dart';

class DatabaseConnection{
  static Connection? _connection;

  static Future<Connection> getConnection() async{
    if(_connection != null && _connection!.isOpen) {
      return _connection!;
    }

  _connection = await Connection.open(
    Endpoint(
      host: 'localhost',
      port: 5432,
      database: 'crypto_alert',
      username: 'postgres',
      password: '8756215',
    ),
    settings: const ConnectionSettings( //remind to change this before production
      sslMode: SslMode.disable,
    ),
  );

  return _connection!;
  }

  static Future<void> close() async{
    await _connection?.close();
    _connection = null;
  }
}