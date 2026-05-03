import '../../../authentication/domain/entities/user_entity.dart';
import '../repositories/group_repository.dart';

class GetGroupMembersUseCase {
  final GroupRepository groupRepository;

  GetGroupMembersUseCase(this.groupRepository);

  Future<List<UserEntity>> execute(String token, String groupId) async {
    return await groupRepository.getGroupMembers(token, groupId);
  }
}
