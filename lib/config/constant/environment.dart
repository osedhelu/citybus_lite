import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static bool _initialized = false;

  static const List<String> _requiredVariables = ['API_URL'];

  static Future<void> initEnvironment() async {
    if (_initialized) return;

    try {
      if (kDebugMode) {
        await dotenv.load(fileName: 'assets/.env.development');
      } else {
        await dotenv.load(fileName: 'assets/.env.production');
      }
      for (final variable in _requiredVariables) {
        if (dotenv.env[variable] == null) {
          throw Exception('Variable crítica no encontrada: $variable');
        }
      }
      _initialized = true;
    } catch (e) {
      _initialized = true;
    }
  }

  // Variables de entorno con valores por defecto
  static String get apiUrl => dotenv.env['API_URL'] ?? '';
}
