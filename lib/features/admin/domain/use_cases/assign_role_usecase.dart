import '../../../authentication/domain/entities/user_entity.dart';
import '../repositories/admin_repository.dart';

class AssignRoleUseCase {
  final AdminRepository repository;

  AssignRoleUseCase(this.repository);

  Future<bool> execute(String token, int targetUserId, UserRole newRole) async {
    return await repository.assignRole(token, targetUserId, newRole);
  }
}
