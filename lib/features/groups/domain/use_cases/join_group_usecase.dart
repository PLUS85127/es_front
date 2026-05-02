import '../repositories/group_repository.dart';

class JoinGroupUseCase {
  final GroupRepository repository;

  JoinGroupUseCase(this.repository);

  Future<bool> execute(String token, String code) async {
    return await repository.joinGroup(token, code);
  }
}
