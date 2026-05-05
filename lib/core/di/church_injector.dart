import 'package:get_it/get_it.dart';
import '../../features/churches/data/datasources/church_remote_data_source.dart';
import '../../features/churches/data/repositories/church_repository_impl.dart';
import '../../features/churches/domain/repositories/church_repository.dart';
import '../../features/churches/domain/use_cases/create_church_usecase.dart';
import '../../features/churches/presentation/provider/church_provider.dart';

void initChurch(GetIt sl) {
  //datasource
  sl.registerLazySingleton<ChurchRemoteDataSource>(
    () => ChurchRemoteDataSourceImpl(client: sl()),
  );

  //repository
  sl.registerLazySingleton<ChurchRepository>(
    () => ChurchRepositoryImpl(remoteDataSource: sl()),
  );

  //use case
  sl.registerLazySingleton(() => CreateChurchUseCase(sl()));
  sl.registerFactory(() => ChurchProvider(createChurchUseCase: sl()));
}
