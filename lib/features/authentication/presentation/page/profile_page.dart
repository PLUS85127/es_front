import 'package:es_control/features/authentication/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/theme_extension.dart';
import 'package:es_control/core/providers/theme_provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = authProvider.user;

    //final userGroupId = user?.groupId ?? "Sin asignar";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mi Perfil",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              context.isDark ? Icons.wb_sunny : Icons.nightlight_round,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 100,
        ),
        child: Column(
          children: [
            //nombre y rol
            ProfileHeader(
              userName: user?.firstName ?? "Usuario",
              userLastName: user?.lastName ?? "",
              role: user?.role ?? UserRole.member,
            ),

            const SizedBox(height: 40),

            ProfileInfoSection(
              title: "Datos Personales",
              items: [
                ProfileInfoItem(
                  label: "Nombre",
                  value:
                      "${user?.firstName ?? "Usuario"} ${user?.lastName ?? ""}"
                          .trim(),
                ),
                ProfileInfoItem(
                  label: "Correo",
                  value: user?.email.isNotEmpty == true
                      ? user!.email
                      : "Sin asignar",
                ),
                ProfileInfoItem(
                  label: "Contraseña",
                  value: "********",
                  icon: Icons.edit_outlined,
                ),
              ],
            ),

            const SizedBox(height: 20),

            //iglsia y grupo
            ProfileInfoSection(
              title: "Afiliación",
              items: [
                ProfileInfoItem(
                  label: "Iglesia",
                  value: user?.churchId?.isNotEmpty == true
                      ? user!.churchId!
                      : "Sin aSignar",
                ),
                const ProfileInfoItem(label: "Grupo", value: "Sin asignar"),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  authProvider.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Cerrar Sesión"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
