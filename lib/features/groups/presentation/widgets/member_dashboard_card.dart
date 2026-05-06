import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/theme_extension.dart';

class MemberDashboardCard extends StatelessWidget {
  final String memberName;
  final int studyDays;

  const MemberDashboardCard({
    super.key,
    required this.memberName,
    required this.studyDays,
  });

  Color _getProgressBarColor(int days) {
    if (days <= 2) {
      return Colors.red;
    } else if (days <= 4) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    //calcular el progreso
    final double progress = (studyDays / 7).clamp(0, 1);
    final Color progressBarColor = _getProgressBarColor(studyDays);

    //colore
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = context.textColor;
    final subTextColor = context.subTextColor;

    //extraemos la primera letra del nombre para el Avatar
    final String initial = memberName.trim().isNotEmpty
        ? memberName.trim()[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Un gris muy sutil basado en el tema actual
        color: context.isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // avatar
          CircleAvatar(
            backgroundColor: primaryColor.withOpacity(0.1),
            child: Text(
              initial,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),

          // nombre y barra lineal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  memberName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                //barra de progreso delgada
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: context.isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),

          //texto de la fracción
          Text(
            "$studyDays/7",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
