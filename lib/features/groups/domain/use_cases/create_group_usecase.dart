import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class CreateGroupUseCase {
  final GroupRepository repository;

  CreateGroupUseCase(this.repository);

  Future<String?> execute(String token, String name, int leaderId) async {
    return await repository.createGroup(token, name, leaderId);
  }
}
