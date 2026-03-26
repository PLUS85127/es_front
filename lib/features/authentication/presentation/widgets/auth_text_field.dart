import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label; //es el texto flotante
  final IconData icon; //para usar iconos
  final bool isPassword; //es contraseña ¿se oculta o no se oculta?
  final TextEditingController?
  controller; // controlador que maneja el texto ingresado
  final String? Function(String?)? validator; //validar el texto igresado

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
    final theme = Theme.of(context); //obtener el tema actual de la app
    final TextEditingController? controller = this.controller;
    final primaryColor = theme.colorScheme.primary; //color primario
    final textColor =
        theme.textTheme.bodyMedium?.color; //color de texto segun el tema

    return TextFormField(
      controller: controller, //controlador para obtener el texto ingresado
      obscureText: isPassword, //si es contraseña se oculta el texto
      validator: validator, //para validar el texto ingresado
      style: TextStyle(color: textColor),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor?.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: primaryColor),

        //fondo dimanico
        filled: true,
        fillColor: theme.brightness == Brightness.light
            ? Colors.grey[100]
            : Colors.white.withOpacity(0.1),

        //borde que cambie segun el enfoque (sin linea visible)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        //borde cuando no está enfocado
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),

        //borde cuando está enfocado
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
