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
    super.studyDays = 0,
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
      id:
          sanitize(userData['_id']) ??
          sanitize(userData['Id']) ??
          //sanitize(userData['_id']) ??
          '',
      token: existingToken ?? sanitize(json['token']) ?? '',
      role: _parseRole(userData['Role'] ?? userData['role'] ?? json['role']),
      firstName:
          sanitize(userData['FirstName']) ??
          sanitize(userData['firstName']) ??
          'Usuario',
      lastName:
          sanitize(userData['LastName']) ??
          sanitize(userData['lastName']) ??
          '',
      email: sanitize(userData['Email']) ?? sanitize(userData['email']) ?? '',
      churchId:
          sanitize(userData['ChurchId']) ??
          sanitize(userData['churchId']) ??
          '',
      studyDays: userData['StudyDays'] ?? userData['studyDays'] ?? 0,
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
