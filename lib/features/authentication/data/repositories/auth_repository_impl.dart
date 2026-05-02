import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    final data = await remoteDataSource.login(email, password);

    return UserModel.fromJson(data);
  }

  @override
  Future<void> register(Map<String, dynamic> userData) async {
    await remoteDataSource.register(userData);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UserEntity> getMe(String token) async {
    final data = await remoteDataSource.getMe(token);

    return UserModel.fromJson(data, existingToken: token);
  }
}
