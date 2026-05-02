import 'package:es_control/features/authentication/domain/entities/user_entity.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

extension ThemeExtension on BuildContext {
  //detectar el modo socuro
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  //color de texto automatico
  Color get textColor => isDark ? Colors.white : AppTheme.navyBlue;
  Color get subTextColor => isDark ? Colors.white70 : Colors.black87;

  Color get iconColor => isDark ? AppTheme.yellowDecorative : AppTheme.navyBlue;
  Color get subIconColor => isDark ? Colors.white54 : Colors.grey;

  Color get cardColor => Theme.of(this).cardColor;

  //----------------------------

  UserEntity? get user => watch<AuthProvider>().user;

  String get churchName {
    final church = user?.churchId;
    return (church != null && church.isNotEmpty) ? church : "Sin asignar";
  }

  String get userEmail {
    final email = user?.email;
    return (email != null && email.isNotEmpty) ? email : "correo@ejemplo.com";
  }
}
