import 'package:flutter/material.dart';
import '../providers/lesson_provider.dart';

class StudyFontSizeToolbar extends StatelessWidget {
  final LessonProvider provider;

  const StudyFontSizeToolbar({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.text_decrease, color: Colors.grey),
          onPressed: () => provider.setFontSize(
            provider.currentFontSize > 14 ? provider.currentFontSize - 2 : 14,
          ),
        ),
        Text(
          "${provider.currentFontSize.toInt()}",
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.text_increase, color: Colors.grey),
          onPressed: () => provider.setFontSize(
            provider.currentFontSize < 30 ? provider.currentFontSize + 2 : 30,
          ),
        ),
      ],
    );
  }
}
