import 'dart:convert';
import 'package:es_control/core/network/api_conf.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/quarterly.dart';
import '../models/quarterly_model.dart';
import '../../domain/entities/lesson.dart';
import '../models/lesson_model.dart';
import '../../domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  //10.64.226.87  10.64.226.87

  @override
  // obtiene la lista de trimestres disponibles
  Future<List<Quarterly>> getQuarterlies(String lang) async {
    final url = '${ApiConfig.quarterlies}?lang=$lang';

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => QuarterlyModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al conectar con el backend');
      }
    } catch (e) {
      throw Exception('Error:$e');
    }
  }

  //obtener lecciones de un trimestre específico
  Future<List<Lesson>> getLessons(
    String quarterlyId, {
    String lang = "es",
  }) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.quarterlies}/$quarterlyId/lessons?lang=$lang'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LessonModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener lecciones');
    }
  }

  //obtener la lectura de un día específico
  Future<Map<String, dynamic>> getDayRead(
    String quarterlyId,
    String lessonId,
    String dayId, {
    String lang = "es",
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.quarterlies}/$quarterlyId/lessons/$lessonId/days/$dayId/read?lang=$lang',
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener la lectura');
    }
  }

  @override
  Future<bool> markDayAsRead(
    String token,
    String lang,
    String quarterlyId,
    String lessonId,
    String dayId,
  ) async {
    final url = '${ApiConfig.baseUrl}/progress/toggle';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'lang': lang,
          'qId': quarterlyId,
          'lId': lessonId,
          'dId': dayId,
        }),
      );
      return (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> finishWeek(
    String token,
    String quarterlyId,
    String lessonId,
  ) async {
    final url = '${ApiConfig.baseUrl}/progress/finish-week';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'qId': quarterlyId, 'lId': lessonId}),
      );
      return (response.statusCode == 200);
    } catch (e) {
      return false;
    }
  }
}
