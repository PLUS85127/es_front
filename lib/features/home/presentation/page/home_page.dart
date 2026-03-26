import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/core/routes/app_router.dart';
import 'package:provider/provider.dart';
//import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final String displayName = authProvider.firstName ?? 'Usuario';

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
            child: Text(
              "Hola, $displayName",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.navyBlue,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  //targeta principal de la lección del día de hoy
                  _buildMainLessonCard(context),
                  const SizedBox(height: 30),

                  //lecciones para los días de la semana
                  _buildDaysGrid(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainLessonCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.lessonDetail,
          arguments: {
            //datos solo de prueba
            'qId': '2026-02',
            'lId': '01',
            'dId': '01',
            'title': "Lección de Hoy",
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "Lección de Hoy",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppTheme.navyBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaysGrid(BuildContext context) {
    final List<Map<String, String>> diasSemana = [
      {"name": "Sábado", "id": "01"},
      {"name": "Domingo", "id": "02"},
      {"name": "Lunes", "id": "03"},
      {"name": "Martes", "id": "04"},
      {"name": "Miércoles", "id": "05"},
      {"name": "Jueves", "id": "06"},
      {"name": "Viernes", "id": "07"},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.85,
      ),
      itemCount: diasSemana.length,
      itemBuilder: (context, index) =>
          _buildDayCard(context, diasSemana[index]),
    );
  }

  Widget _buildDayCard(BuildContext context, Map<String, String> dia) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.lessonDetail,
          arguments: {
            'qId': '2026-01',
            'lId': '01',
            'dId': dia['id'],
            'title': "Lección de ${dia['name']}",
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.03)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dia['name']!,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: AppTheme.navyBlue,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Estudiar",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
