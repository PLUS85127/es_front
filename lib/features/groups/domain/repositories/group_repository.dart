import '../entities/group_entity.dart';

abstract class GroupRepository {
  Future<List<GroupEntity>> getMyGroups(String token);

  Future<GroupEntity> createGroup(String token, String name, int leaderId);

  Future<bool> joinGroup(String token, String code);
}
