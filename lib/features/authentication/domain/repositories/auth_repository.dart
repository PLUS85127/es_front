import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<void> register(Map<String, dynamic> userData);
  Future<void> logout();
  Future<UserEntity> getMe(String token);
}
