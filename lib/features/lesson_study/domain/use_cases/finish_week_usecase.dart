import '../repositories/lesson_repository.dart';

class FinishWeekUseCase {
  final LessonRepository repository;

  FinishWeekUseCase(this.repository);

  Future<bool> execute(
    String token,
    String quarterlyId,
    String lessonId,
  ) async {
    return await repository.finishWeek(token, quarterlyId, lessonId);
  }
}
