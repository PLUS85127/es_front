import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_data_source.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;
  GroupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<GroupEntity>> getMyGroups(String token) async {
    return await remoteDataSource.getMyGroups(token);
  }

  @override
  Future<GroupEntity> createGroup(
    String token,
    String name,
    int leaderId,
  ) async {
    return await remoteDataSource.createGroup(token, name, leaderId);
  }

  @override
  Future<bool> joinGroup(String token, String code) async {
    return await remoteDataSource.joinGroup(token, code);
  }
}
