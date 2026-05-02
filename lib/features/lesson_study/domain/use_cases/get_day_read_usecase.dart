import '../repositories/lesson_repository.dart';

class GetDayReadUseCase {
  final LessonRepository repository;
  GetDayReadUseCase(this.repository);

  Future<Map<String, dynamic>> execute(
    String qId,
    String lId,
    String dId,
    String lang,
  ) async {
    return await repository.getDayRead(qId, lId, dId, lang: lang);
  }
}
