import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/core/theme/theme_extension.dart';

class CircularProgressCard extends StatelessWidget {
  final double progressValue;
  final String mainText;
  final String subText;

  const CircularProgressCard({
    super.key,
    required this.progressValue,
    required this.mainText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 170,
                height: 170,
                child: CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 18,
                  color: context.iconColor,
                  backgroundColor: context.isDark
                      ? Colors.white
                      : Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(context.iconColor),
                ),
              ),
              Column(
                children: [
                  Text(
                    mainText,
                    style: GoogleFonts.poppins(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  Text(
                    subText,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: context.subTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
