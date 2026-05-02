import '../entities/stats_entity.dart';

abstract class ReportingRepository {
  Future<StatsEntity> getMyStats(
    String token,
    String quarterlyId,
    String lessonId,
  );
}
