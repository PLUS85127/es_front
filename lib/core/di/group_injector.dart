import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/groups/data/datasources/group_remote_data_source.dart';
import '../../features/groups/data/repositories/group_repository_impl.dart';
import '../../features/groups/domain/repositories/group_repository.dart';

import '../../features/groups/domain/use_cases/join_group_usecase.dart';
import '../../features/groups/domain/use_cases/get_my_groups_usecase.dart';
import '../../features/groups/domain/use_cases/create_group_usecase.dart';
import '../../features/groups/domain/use_cases/get_group_members_usecase.dart';
import '../../features/groups/domain/use_cases/leave_group_usecase.dart';
import '../../features/groups/domain/use_cases/mark_attendance_usecase.dart';
import '../../features/groups/domain/use_cases/get_attendance_usecase.dart';

import '../../features/groups/presentation/provider/group_provider.dart';

final sl = GetIt.instance;

Future<void> initGroup(GetIt sl) async {
  //datasource
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  //repositorio
  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(remoteDataSource: sl<GroupRemoteDataSource>()),
  );

  //casos de uso
  sl.registerLazySingleton(() => JoinGroupUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(() => GetMyGroupsUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(() => CreateGroupUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(() => GetGroupMembersUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(() => LeaveGroupUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(() => MarkAttendanceUseCase(sl<GroupRepository>()));
  sl.registerLazySingleton(() => GetAttendanceUseCase(sl<GroupRepository>()));

  //provider
  sl.registerFactory(
    () => GroupProvider(
      joinGroupUseCase: sl<JoinGroupUseCase>(),
      getMyGroupsUseCase: sl<GetMyGroupsUseCase>(),
      createGroupUseCase: sl<CreateGroupUseCase>(),
      getGroupMembersUseCase: sl<GetGroupMembersUseCase>(),
      leaveGroupUseCase: sl<LeaveGroupUseCase>(),
      markAttendanceUseCase: sl<MarkAttendanceUseCase>(),
      getAttendanceUseCase: sl<GetAttendanceUseCase>(),
    ),
  );
}
