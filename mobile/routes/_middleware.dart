import 'package:dart_frog/dart_frog.dart';
import 'package:crypto_alert_backend/middlewares/error_middleware.dart' as error;

Handler middleware(Handler handler) {
  return error.middleware(handler);
}