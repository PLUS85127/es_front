import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository repository;

  GetMeUseCase(this.repository);

  Future<UserEntity> execute(String token) async {
    return await repository.getMe(token);
  }
}
