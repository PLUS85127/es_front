import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:es_control/core/network/api_conf.dart';
import '../models/stats_model.dart';

class ReportingRemoteDataSource {
  Future<StatsModel> getMyStats(
    String token,
    String quarterlyId,
    String lessonId,
  ) async {
    ///api/v1/progress/my-stats/quarterlyId/
    final finalUrl =
        '${ApiConfig.baseUrl}/progress/my-stats/$quarterlyId/$lessonId';

    final response = await http.get(
      Uri.parse(finalUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return StatsModel.fromJson(jsonResponse['stats']);
    } else {
      final jsonResponse = json.decode(response.body);
      throw Exception(
        jsonResponse['message'] ?? 'Error al cargar las estadísticas',
      );
    }
  }
}
