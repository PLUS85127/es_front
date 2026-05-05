import '../repositories/lesson_repository.dart';

class MarkDayAsReadUseCase {
  final LessonRepository repository;
  MarkDayAsReadUseCase(this.repository);

  Future<bool> execute(
    String token,
    String lang,
    String qId,
    String lId,
    String dId,
  ) async {
    return await repository.markDayAsRead(token, lang, qId, lId, dId);
  }
}
