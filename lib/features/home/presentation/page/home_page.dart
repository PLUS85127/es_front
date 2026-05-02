import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/core/routes/app_router.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:es_control/features/lesson_study/presentation/providers/lesson_provider.dart';
import '../widgets/day_card.dart';
import '../../../../core/theme/theme_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  void _loadInitialData() async {
    final lp = context.read<LessonProvider>();
    await lp.fetchQuarterlies();

    if (lp.currentQuarterly != null) {
      await lp.fetchLessons(lp.currentQuarterly!.quarterlyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final String displayName = authProvider.user?.firstName ?? 'Usuario';

    final textColor = context.textColor;
    final subTextColor = context.subTextColor;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
              child: Text(
                "Hola, $displayName",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Selecciona el día de estudio:",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: subTextColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _buildDaysGrid(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysGrid(BuildContext context) {
    final List<Map<String, String>> daysWeek = [
      {"name": "Sábado", "id": "01"},
      {"name": "Domingo", "id": "02"},
      {"name": "Lunes", "id": "03"},
      {"name": "Martes", "id": "04"},
      {"name": "Miércoles", "id": "05"},
      {"name": "Jueves", "id": "06"},
      {"name": "Viernes", "id": "07"},
    ];

    final lp = context.watch<LessonProvider>();
    final currentQ = lp.currentQuarterly;
    final currentLesson = lp.currentLesson;

    if (currentQ != null &&
        currentLesson == null &&
        !lp.isLoading &&
        lp.lessons.isNotEmpty) {
      Future.microtask(() => lp.fetchLessons(currentQ.quarterlyId));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.3,
      ),
      itemCount: daysWeek.length,
      itemBuilder: (context, index) {
        final dia = daysWeek[index];
        final bool isEnabled = (currentLesson != null && currentQ != null);

        return DayCard(
          name: dia['name']!,
          isEnabled: isEnabled,
          onTap: isEnabled
              ? () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.lessonDetail,
                    arguments: {
                      'qId': currentQ.quarterlyId,
                      'lId': currentLesson.lessonId,
                      'dId': dia['id'],
                      'title': "Lección de ${dia['name']}",
                    },
                  );
                }
              : null,
        );
      },
    );
  }
}
