import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/admin/data/datasources/admin_remote_data_source.dart';
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/use_cases/search_user_usecase.dart';
import '../../features/admin/domain/use_cases/assign_role_usecase.dart';
import '../../features/admin/presentation/provider/admin_provider.dart';

void initAdmin(GetIt sl) {
  //datasource
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(client: http.Client()),
  );

  //repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl<AdminRemoteDataSource>()),
  );

  //use case
  sl.registerLazySingleton(() => SearchUserUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => AssignRoleUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(
    () => TransferUserChurchUseCase(sl<AdminRepository>()),
  );

  sl.registerFactory(
    () => AdminProvider(
      searchUserUseCase: sl<SearchUserUseCase>(),
      assignRoleUseCase: sl<AssignRoleUseCase>(),
      transferUserChurchUseCase: sl<TransferUserChurchUseCase>(),
    ),
  );
}
