import '../entities/quarterly.dart';
import '../repositories/lesson_repository.dart';

class GetQuarterliesUseCase {
  final LessonRepository repository;
  GetQuarterliesUseCase(this.repository);

  Future<List<Quarterly>> execute(String lang) async {
    return await repository.getQuarterlies(lang);
  }
}
