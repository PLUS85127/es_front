import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.token,
    required super.role,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.churchId,
    //super.groupName,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    String? existingToken,
  }) {
    final userData = json['user'] ?? json;

    String? sanitize(dynamic value) {
      if (value == null) return null;
      final str = value.toString().trim();
      return str.isNotEmpty ? str : null;
    }

    return UserModel(
      id: sanitize(userData['_id']) ?? sanitize(userData['id']) ?? '',
      token: existingToken ?? sanitize(json['token']) ?? '',
      role: _parseRole(userData['role'] ?? json['role']),
      firstName: sanitize(userData['firstName']) ?? 'Usuario',
      lastName: sanitize(userData['lastName']) ?? '',
      email: sanitize(userData['email']) ?? '',
      churchId: sanitize(userData['churchId']),
    );
  }

  static UserRole _parseRole(String? roleStr) {
    switch (roleStr?.toUpperCase()) {
      case 'PASTOR':
        return UserRole.pastor;
      case 'DIRECTOR':
        return UserRole.director;
      case 'LEADER':
        return UserRole.leader;
      case 'MEMBER':
      default:
        return UserRole.member;
    }
  }
}
