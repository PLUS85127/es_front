import 'dart:convert';
import 'dart:io';
import 'package:es_control/core/network/api_conf.dart';
import 'package:http/http.dart' as http;
import '../entities/quarterly.dart';
import '../../data/models/quarterly_model.dart';
import '../entities/lesson.dart';
import '../../data/models/lesson_model.dart';
import 'lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  //10.64.226.87  10.64.226.87

  @override
  // 1. Obtener la lista de trimestres disponibles
  Future<List<Quarterly>> getQuarterlies(String lang) async {
    final url = '${ApiConfig.quarterlies}?lang=$lang';
    //print("Conectando a $url");

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));
      //print("Respuesta recibida: ${response.statusCode}");

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

  // 2. Obtener lecciones de un trimestre específico
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

  // 3. Obtener la lectura de un día específico
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
      return json.decode(response.body); //devuelve el contenido de ReadJson
    } else {
      throw Exception('Error al obtener la lectura');
    }
  }
}
