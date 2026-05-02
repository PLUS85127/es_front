import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/theme_extension.dart';
import 'package:es_control/core/theme/app_theme.dart';

class DayCard extends StatelessWidget {
  final String name;
  final bool isEnabled;
  final VoidCallback? onTap;

  const DayCard({
    super.key,
    required this.name,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final bgColor = context.cardColor;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade200;
    final shadowColor = isDark ? Colors.black38 : Colors.grey.shade200;

    final accentColor = isDark ? AppTheme.yellowDecorative : AppTheme.navyBlue;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              bgColor,
              isDark ? bgColor.withOpacity(0.8) : Colors.grey.shade50,
            ],
          ),
        ),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.4,
          child: Stack(
            children: [
              Positioned(
                right: -15,
                bottom: -15,
                child: Icon(
                  Icons.auto_stories_rounded,
                  size: 80,
                  color: isDark
                      ? Colors.white.withOpacity(0.03)
                      : accentColor.withOpacity(0.04),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //circulo con el icono
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? accentColor.withOpacity(0.2)
                            : accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: accentColor,
                        size: 20,
                      ),
                    ),
                    const Spacer(),

                    //texto del dia
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    //subtitulos del idia
                    Text(
                      isEnabled ? "Estudiar" : "No disponible",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: context.subTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
