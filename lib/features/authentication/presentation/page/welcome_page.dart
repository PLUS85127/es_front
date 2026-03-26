import 'package:flutter/material.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/core/routes/app_router.dart'; // Usando tus constantes de ruta
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Parte superior: Logo con más aire
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Hero(
                    // Animación sutil para el logo
                    tag: 'logo',
                    child: SvgPicture.asset(
                      'assets/images/logo_es_sabatica.svg',
                      width: 200,
                      placeholderBuilder: (context) =>
                          const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),

            // Parte inferior: Panel redondeado estético
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bienvenido a ES Control",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.navyBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Sigue tu progreso de Escuela Sabática de forma profesional.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Botón de Inicio de Sesión
                      _buildWelcomeButton(
                        context: context,
                        label: "Iniciar sesión",
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.login),
                      ),

                      const SizedBox(height: 20),

                      // Botón de Registro tipo link
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.register),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.navyBlue,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "¿No tienes cuenta? ",
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: "Regístrate",
                                style: GoogleFonts.poppins(
                                  color: AppTheme.navyBlue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navyBlue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
