import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<UserEntity> execute(String email, String password) async {
    if (!email.contains('@')) {
      throw Exception('Email debe contener @');
    }
    return await repository.login(email, password);
  }
}
