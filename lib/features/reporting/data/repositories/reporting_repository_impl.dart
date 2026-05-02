import '../../domain/entities/stats_entity.dart';
import '../../domain/repositories/reporting_repository.dart';
import '../datasource/reporting_remote_data_source.dart';

class ReportingRepositoryImpl implements ReportingRepository {
  final ReportingRemoteDataSource remoteDataSource;

  ReportingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StatsEntity> getMyStats(
    String token,
    String quarterlyId,
    String lessonId,
  ) async {
    return await remoteDataSource.getMyStats(token, quarterlyId, lessonId);
  }
}
