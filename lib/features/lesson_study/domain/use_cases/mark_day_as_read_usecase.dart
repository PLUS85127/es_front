import '../repositories/lesson_repository.dart';

class MarkDayAsReadUseCase {
  final LessonRepository repository;
  MarkDayAsReadUseCase(this.repository);

  Future<void> execute(String token, String qId, String lId, String dId) async {
    return await repository.markDayAsRead(token, qId, lId, dId);
  }
}
