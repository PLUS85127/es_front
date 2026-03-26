class UserModel {
  final String token;
  final String role;
  final String firstName;

  UserModel({required this.token, required this.role, required this.firstName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      role: json['role'],
      firstName: json['user']['firstName'],
    );
  }
}
