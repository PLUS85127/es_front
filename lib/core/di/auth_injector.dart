import 'package:es_control/features/authentication/domain/use_cases/get_me_usecase.dart';
import 'package:get_it/get_it.dart';
import '../../features/authentication/data/datasources/auth_remote_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/use_cases/login_usecase.dart';
import '../../features/authentication/domain/use_cases/register_usecase.dart';
import '../../features/authentication/presentation/provider/auth_provider.dart';
import '../../features/authentication/domain/use_cases/logout_usecase.dart';

void initAuth(GetIt sl) {
  //datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  //repositorio
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  //casos de uso
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetMeUseCase(sl()));

  //provider
  sl.registerFactory(
    () => AuthProvider(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getMeUseCase: sl(),
    ),
  );
}
