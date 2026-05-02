import 'package:es_control/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label; //es el texto flotante
  final IconData icon; //para usar iconos
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false, //por defecto no es contraseña
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      style: TextStyle(color: context.textColor),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: context.subTextColor),
        prefixIcon: Icon(icon, color: context.iconColor),

        //fondo dimanico
        filled: true,
        fillColor: context.cardColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.iconColor.withOpacity(0.3)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.iconColor, width: 2),
        ),
      ),
    );
  }
}
