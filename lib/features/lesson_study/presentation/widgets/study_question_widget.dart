import 'package:es_control/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:es_control/core/theme/app_theme.dart';
import '../providers/lesson_provider.dart';
import 'lesson_note_input.dart';

class StudyQuestionWidget extends StatelessWidget {
  final String innerHtml;
  final double fontSize;
  final String dayId;
  final LessonProvider provider;

  const StudyQuestionWidget({
    super.key,
    required this.innerHtml,
    required this.fontSize,
    required this.dayId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final questionKey = "${dayId}_${innerHtml.hashCode}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: context.iconColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.help_outline, color: context.iconColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Html(
                  data: innerHtml,
                  style: {
                    "body": Style(
                      fontSize: FontSize(fontSize - 2),
                      fontFamily: 'Poppins',
                      color: context.textColor,
                      margin: Margins.zero,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
        LessonNoteInput(
          initialValue: provider.getAnswer(questionKey),
          onChanged: (val) => provider.saveAnswerTemporarily(questionKey, val),
        ),
      ],
    );
  }
}
