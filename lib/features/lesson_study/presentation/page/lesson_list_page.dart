import 'package:es_control/features/lesson_study/domain/entities/quarterly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/core/routes/app_router.dart';
import '../providers/lesson_provider.dart';

class LessonListPage extends StatefulWidget {
  final String quarterlyId;
  final String title;

  const LessonListPage({
    super.key,
    required this.quarterlyId,
    required this.title,
  });

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonProvider>().fetchLessons(widget.quarterlyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(
            thickness: 1,
            color: Color(0xFFEEEEEE),
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Consumer<LessonProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.navyBlue),
                  );
                }

                if (provider.lessons.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay lecciones disponibles para este trimestre.",
                      style: GoogleFonts.poppins(color: Colors.black54),
                    ),
                  );
                }

                //lista de lecciones
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: provider.lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = provider.lessons[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 5,
                      ),
                      leading: Text(
                        "${index + 1}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navyBlue,
                        ),
                      ),
                      title: Text(
                        lesson.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.lessonDetail,
                          arguments: {
                            'qId': widget.quarterlyId,
                            'lId': lesson.lessonId,
                            'title': lesson.title,
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
