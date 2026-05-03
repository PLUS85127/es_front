import '../repositories/lesson_repository.dart';

class FinishWeekUseCase {
  final LessonRepository lessonRepository;

  FinishWeekUseCase(this.lessonRepository);

  Future<void> execute(
    String token,
    String quarterlyId,
    String lessonId,
  ) async {
    await lessonRepository.finishWeek(token, quarterlyId, lessonId);
  }
}
