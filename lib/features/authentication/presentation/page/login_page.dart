import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart'; // Necesario para context.read
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/features/authentication/presentation/widgets/auth_text_field.dart';
import 'package:es_control/core/routes/app_router.dart';
import '../provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Se escribe dispose, no disponse. Y devuelve void.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    try {
      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        // Navegamos al Main si el login es exitoso
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el estado de carga del provider
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Inicia con tu cuenta',
                    style: GoogleFonts.lato(
                      color: AppTheme.navyBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Únete a la comunidad de la Escuela Sabática',
                    style: GoogleFonts.lato(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SvgPicture.asset(
                    'assets/images/logo_es_sabatica.svg',
                    width: 140,
                    height: 140,
                    placeholderBuilder: (context) =>
                        const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 40),

                  _buildFieldLabel('Email'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _emailController, // Conectado al controlador
                    label: 'Ingrese su email',
                    icon: Icons.email,
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Requerido' : null,
                  ),

                  const SizedBox(height: 25),

                  _buildFieldLabel('Contraseña'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _passwordController, // Conectado al controlador
                    label: 'Ingrese su contraseña',
                    icon: Icons.lock,
                    isPassword: true,
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Requerido' : null,
                  ),

                  const SizedBox(height: 40),

                  // BOTÓN DE ACCIÓN CON INDICADOR DE CARGA
                  InkWell(
                    onTap: isLoading ? null : _handleLogin,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: isLoading ? Colors.grey : AppTheme.navyBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Sign In',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes cuenta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Text(
                          'Regístrate',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.navyBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
