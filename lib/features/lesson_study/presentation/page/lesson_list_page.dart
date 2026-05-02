import 'package:es_control/core/theme/theme_extension.dart';
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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: context.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(
            thickness: 1,
            color: context.subTextColor.withOpacity(0.2),
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Consumer<LessonProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: context.iconColor),
                  );
                }

                if (provider.lessons.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay lecciones disponibles para este trimestre.",
                      style: GoogleFonts.poppins(color: context.subTextColor),
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
                          color: context.iconColor,
                        ),
                      ),
                      title: Text(
                        lesson.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: context.textColor,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: context.subIconColor,
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
