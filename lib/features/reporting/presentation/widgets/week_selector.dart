import 'package:es_control/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/features/lesson_study/domain/entities/lesson.dart';

class WeekSelector extends StatelessWidget {
  final List<Lesson> lessons;
  final String? selectedLessonId;
  final String? currentLessonId;
  final Function(String) onLessonSelected;

  const WeekSelector({
    super.key,
    required this.lessons,
    required this.selectedLessonId,
    required this.currentLessonId,
    required this.onLessonSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          bool isSelected = selectedLessonId == lesson.lessonId;
          bool isToday = currentLessonId == lesson.lessonId;

          return GestureDetector(
            onTap: () => onLessonSelected(lesson.lessonId),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? context.iconColor : context.cardColor,
                borderRadius: BorderRadius.circular(18),
                border: isToday
                    ? Border.all(color: Colors.orange, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  "Semana ${index + 1}",
                  style: GoogleFonts.poppins(
                    color: isSelected
                        ? (context.isDark
                              ? AppTheme.darkBackground
                              : Colors.white)
                        : context.subTextColor,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
