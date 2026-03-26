// lib/core/network/api_conf.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl =>
      dotenv.env['API_URL'] ?? 'http:// 10.64.226.87:3000/api/v1';

  static String get auth => '$baseUrl/auth';
  static String get quarterlies => '$baseUrl/quarterlies';
  static String get lessons => '$baseUrl/lessons';
}
