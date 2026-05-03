import '../../../authentication/domain/entities/user_entity.dart';
import '../repositories/admin_repository.dart';

class SearchUserUseCase {
  final AdminRepository repository;

  SearchUserUseCase(this.repository);

  Future<UserEntity?> execute(String token, String email) async {
    return await repository.searchUserByEmail(token, email);
  }
}
