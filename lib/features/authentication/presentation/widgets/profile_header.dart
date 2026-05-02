import 'package:flutter/material.dart';
import 'package:es_control/core/theme/theme_extension.dart';
import 'package:es_control/features/authentication/domain/entities/user_entity.dart';
import 'role_badge.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userLastName;
  final UserRole role;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userLastName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: context.isDark
              ? Colors.white10
              : Colors.grey.shade200,
          child: Icon(
            Icons.person,
            size: 50,
            color: context.isDark ? Colors.white60 : Colors.grey,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "$userName $userLastName".trim(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        RoleBadge(role: role),
      ],
    );
  }
}
