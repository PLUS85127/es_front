import '../../../authentication/domain/entities/user_entity.dart';

abstract class AdminRepository {
  //GET /search?emil
  Future<UserEntity?> searchUserByEmail(String token, String email);

  //PATCH /assign-role
  Future<bool> assignRole(String token, int targetUserId, UserRole newRole);

  //PATCH /transfer-church
  Future<bool> transferUserChurch(
    String token,
    int targetUserId,
    int newChurchId,
  );
}
