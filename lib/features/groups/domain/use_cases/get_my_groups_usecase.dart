import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class GetMyGroupsUseCase {
  final GroupRepository repository;

  GetMyGroupsUseCase(this.repository);

  Future<List<GroupEntity>> execute(String token) async {
    return await repository.getMyGroups(token);
  }
}
