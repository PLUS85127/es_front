import '../entities/stats_entity.dart';
import '../repositories/reporting_repository.dart';

class GetMyStatsUseCase {
  final ReportingRepository repository;

  GetMyStatsUseCase(this.repository);

  Future<StatsEntity> execute(
    String token,
    String quarterlyId,
    String lessonId,
  ) async {
    return await repository.getMyStats(token, quarterlyId, lessonId);
  }
}
