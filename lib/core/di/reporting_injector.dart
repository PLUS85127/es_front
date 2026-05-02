import 'package:get_it/get_it.dart';
import '../../features/reporting/data/datasource/reporting_remote_data_source.dart';
import '../../features/reporting/data/repositories/reporting_repository_impl.dart';
import '../../features/reporting/domain/repositories/reporting_repository.dart';
import '../../features/reporting/domain/use_cases/get_my_stats_usecase.dart';
import '../../features/reporting/presentation/provider/stats_provider.dart';

void initReporting(GetIt sl) {
  //datasource
  sl.registerLazySingleton<ReportingRemoteDataSource>(
    () => ReportingRemoteDataSource(),
  );

  //repositoio
  sl.registerLazySingleton<ReportingRepository>(
    () => ReportingRepositoryImpl(remoteDataSource: sl()),
  );

  //casos de uso
  sl.registerLazySingleton(() => GetMyStatsUseCase(sl()));

  //providers
  sl.registerFactory(() => StatsProvider(getMyStatsUseCase: sl()));
}
