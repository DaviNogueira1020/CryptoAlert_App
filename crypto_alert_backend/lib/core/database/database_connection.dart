import 'package:postgres/postgres.dart';
import 'package:crypto_alert_backend/config/environment.dart';

class DatabaseConnection {
  static Connection? _connection;

  static Future<Connection> getConnection() async {
    if (_connection != null && _connection!.isOpen) {
      return _connection!;
    }

    final isLocal = Environment.dbHost == 'localhost' || Environment.dbHost == '127.0.0.1';

    _connection = await Connection.open(
      Endpoint(
        host: Environment.dbHost,
        port: Environment.dbPort,
        database: Environment.dbName,
        username: Environment.dbUser,
        password: Environment.dbPassword,
      ),
      settings: ConnectionSettings(
        sslMode: isLocal ? SslMode.disable : SslMode.require, 
      ),
    );

    return _connection!;
  }

  static Future<void> close() async {
    await _connection?.close();
    _connection = null;
  }
}