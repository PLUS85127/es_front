import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_data_source.dart';
import '../../../authentication/domain/entities/user_entity.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({required this.remoteDataSource});

  //ver mi grupo
  @override
  Future<List<GroupEntity>> getMyGroups(String token) async {
    try {
      return await remoteDataSource.getMyGroups(token);
    } catch (e) {
      return [];
    }
  }

  //crear grupo
  @override
  Future<String?> createGroup(String token, String name, int leaderId) async {
    try {
      return await remoteDataSource.createGroup(token, name, leaderId);
    } catch (e) {
      return null;
    }
  }

  //unirse a grupo
  @override
  Future<bool> joinGroup(String token, String code) async {
    try {
      return await remoteDataSource.joinGroup(token, code);
    } catch (e) {
      return false;
    }
  }

  //ver miembros de grupo
  @override
  Future<List<UserEntity>> getGroupMembers(String token, String groupId) async {
    try {
      return await remoteDataSource.getGroupMembers(token, groupId);
    } catch (e) {
      return [];
    }
  }

  //salir de grupo
  @override
  Future<bool> leaveGroup(String token, String groupId) async {
    try {
      return await remoteDataSource.leaveGroup(token, groupId);
    } catch (e) {
      return false;
    }
  }

  //ver asistencia
  @override
  Future<Map<String, dynamic>> getAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
  ) async {
    try {
      return await remoteDataSource.getAttendance(
        token,
        groupId,
        quarterlyId,
        lessonId,
      );
    } catch (e) {
      return {};
    }
  }

  //marcar asistencia
  @override
  Future<bool> markAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
    List<int> presentUserIds,
    int visits,
  ) async {
    try {
      return await remoteDataSource.markAttendance(
        token,
        groupId,
        quarterlyId,
        lessonId,
        presentUserIds,
        visits,
      );
    } catch (e) {
      return false;
    }
  }
}
