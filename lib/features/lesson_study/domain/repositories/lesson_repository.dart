import 'package:es_control/features/lesson_study/domain/entities/quarterly.dart';
import 'package:es_control/features/lesson_study/domain/entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Quarterly>> getQuarterlies(String lang);

  //marcar un dia como leido
  Future<void> markDayAsRead(
    String token,
    String quarterlyId,
    String lessonId,
    String dayId,
  );

  //obtener los cursos de una trimestre
  Future<List<Lesson>> getLessons(String quarterlyId, {String lang = "es"});
  Future<Map<String, dynamic>> getDayRead(
    String quarterlyId,
    String lessonId,
    String dayId, {
    String lang = "es",
  });

  Future<void> finishWeek(String token, String quarterlyId, String lessonId);
}
