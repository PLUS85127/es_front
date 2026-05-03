import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  //buscar usuario por correo electrónico
  @override
  Future<UserEntity?> searchUserByEmail(String token, String email) async {
    try {
      return await remoteDataSource.searchUserByEmail(token, email);
    } catch (e) {
      return null;
    }
  }

  //asignar rol a usuario
  @override
  Future<bool> assignRole(
    String token,
    int targetUserId,
    UserRole newRole,
  ) async {
    try {
      final roleString = newRole.name.toString();
      return await remoteDataSource.assignRole(token, targetUserId, roleString);
    } catch (e) {
      return false;
    }
  }

  //transferir usuario a otra iglesia
  @override
  Future<bool> transferUserChurch(
    String token,
    int targetUserId,
    int newChurchId,
  ) async {
    try {
      return await remoteDataSource.transferUserChurch(
        token,
        targetUserId,
        newChurchId,
      );
    } catch (e) {
      return false;
    }
  }
}
