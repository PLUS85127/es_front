enum UserRole { member, leader, director, pastor }

class UserEntity {
  final String id;
  final String token;
  final UserRole role;
  final String firstName;
  final String lastName;
  final String email;
  final String? churchId;
  //final String? groupName;
  final int studyDays;

  UserEntity({
    required this.id,
    required this.token,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.churchId,
    //this.groupName,
    this.studyDays = 0,
  });
}
