import '../repositories/group_repository.dart';

class LeaveGroupUseCase {
  final GroupRepository groupRepository;

  LeaveGroupUseCase(this.groupRepository);

  Future<bool> execute(String token, String groupId) async {
    return await groupRepository.leaveGroup(token, groupId);
  }
}
