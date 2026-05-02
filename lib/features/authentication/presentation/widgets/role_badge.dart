import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/theme_extension.dart';
import 'package:es_control/features/authentication/domain/entities/user_entity.dart';

class RoleBadge extends StatelessWidget {
  final UserRole role;
  const RoleBadge({super.key, required this.role});

  Color _getRoleColor(UserRole role, BuildContext context) {
    switch (role) {
      case UserRole.pastor:
        return Colors.purple;
      case UserRole.director:
      case UserRole.leader:
        return Colors.orange;
      case UserRole.member:
      default:
        return context.iconColor;
    }
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.pastor:
        return 'Pastor';
      case UserRole.director:
        return 'Director(a)';
      case UserRole.leader:
        return 'Lider de Grupo';
      case UserRole.member:
      default:
        return 'Miembro';
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(role, context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: roleColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: roleColor),
      ),
      child: Text(
        _getRoleName(role).toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: roleColor,
        ),
      ),
    );
  }
}
