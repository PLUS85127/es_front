import 'package:es_control/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:es_control/core/routes/app_router.dart';
import '../provider/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final authProvider = context.read<AuthProvider>();

    try {
      //que no vengan vacios
      if (_nameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        throw 'Por favor rellene todos los campos';
      }

      await authProvider.signUp(
        firstName: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: 'MEMBER',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Registro exitoso! Inicie sesión.'),
            backgroundColor: context.iconColor,
          ),
        );
        Navigator.pushNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Crea tu cuenta',
                    style: GoogleFonts.lato(
                      color: context.iconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SvgPicture.asset(
                    'assets/images/logo_es_sabatica.svg',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 30),

                  _buildLabel('Nombre'),
                  AuthTextField(
                    controller: _nameController,
                    label: 'Ingrese su nombre',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 15),

                  _buildLabel('Apellido'),
                  AuthTextField(
                    controller: _lastNameController,
                    label: 'Ingrese su apellido',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 15),

                  _buildLabel('Correo'),
                  AuthTextField(
                    controller: _emailController,
                    label: 'Ingrese su correo',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 15),

                  _buildLabel('Contraseña'),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Ingrese su contraseña',
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                  const SizedBox(height: 30),

                  InkWell(
                    onTap: isLoading ? null : _handleRegister,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: isLoading
                            ? context.subIconColor.withOpacity(0.3)
                            : context.iconColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: context.isDark
                                    ? AppTheme.darkBackground
                                    : Colors.white,
                              )
                            : Text(
                                'Registrate',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: context.isDark
                                      ? AppTheme.darkBackground
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            color: context.textColor,
          ),
        ),
      ),
    );
  }
}
