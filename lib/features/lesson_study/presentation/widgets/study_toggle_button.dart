import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extension.dart';

class StudyToggleButton extends StatelessWidget {
  final bool isStudied;
  final bool isProcessing;
  final VoidCallback? onPressed;

  const StudyToggleButton({
    super.key,
    required this.isStudied,
    required this.isProcessing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = context.textColor;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isStudied ? Colors.green : defaultColor,
          side: BorderSide(
            color: isStudied ? Colors.green : defaultColor,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: isStudied
              ? Colors.green.withOpacity(0.1)
              : Colors.transparent,
        ),
        icon: isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(isStudied ? Icons.check_circle : Icons.circle_outlined),
        label: Text(
          isStudied ? "ESTUDIADO" : "MARCAR COMO ESTUDIADO",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
