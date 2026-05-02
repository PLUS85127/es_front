import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';

class GetLessonsUseCase {
  final LessonRepository repository;
  GetLessonsUseCase(this.repository);

  Future<List<Lesson>> execute(String quarterlyId, String lang) async {
    return await repository.getLessons(quarterlyId, lang: lang);
  }
}
