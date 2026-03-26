import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/core/routes/app_router.dart';
import '../providers/lesson_provider.dart';

class LessonsStudyPage extends StatefulWidget {
  const LessonsStudyPage({super.key});

  @override
  State<LessonsStudyPage> createState() => _LessonsStudyPageState();
}

class _LessonsStudyPageState extends State<LessonsStudyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonProvider>().fetchQuarterlies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Lecciones',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.navyBlue,
                ),
              ),
              const Divider(height: 20, thickness: 1, color: AppTheme.navyBlue),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<LessonProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.quarterlies.isEmpty) {
                      return Center(
                        child: Text(
                          "No hay trimestres disponibles",
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: provider.quarterlies.length,
                      itemBuilder: (context, index) {
                        final quarterly = provider.quarterlies[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.lessonList,
                              arguments: {
                                'qId': quarterly.quarterlyId,
                                'title': quarterly.title,
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.05),
                              ),
                              image: quarterly.coverUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(quarterly.coverUrl!),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.3),
                                        BlendMode.darken,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
