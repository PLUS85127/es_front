import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyLessonTitle extends StatelessWidget {
  final String title;
  final double fontSize;

  const StudyLessonTitle({
    super.key,
    required this.title,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: fontSize + 4,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
