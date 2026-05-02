import 'package:es_control/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class LessonNoteInput extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;

  const LessonNoteInput({
    super.key,
    this.initialValue = "",
    required this.onChanged,
  });

  @override
  State<LessonNoteInput> createState() => _LessonNoteInputState();
}

class _LessonNoteInputState extends State<LessonNoteInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.iconColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: context.subTextColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: context.iconColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.edit_note, color: AppTheme.navyBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Tu respuesta",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.iconColor,
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            maxLines: null,
            minLines: 3,
            style: GoogleFonts.poppins(fontSize: 16, color: context.textColor),
            decoration: InputDecoration(
              hintText: "Escribe tu respuesta aquí...",
              hintStyle: GoogleFonts.poppins(
                color: context.subTextColor.withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
        ],
      ),
    );
  }
}
