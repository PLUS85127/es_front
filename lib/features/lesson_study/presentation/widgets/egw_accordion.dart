import 'package:es_control/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/app_theme.dart';

class EgwAccordion extends StatelessWidget {
  final String content;
  final Map<String, Style> htmlStyle;
  final void Function(String?, Map<String, String>, dynamic) onLinkTap;

  const EgwAccordion({
    super.key,
    required this.content,
    required this.htmlStyle,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.iconColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.subTextColor.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          iconColor: context.iconColor,
          collapsedIconColor: Colors.grey.shade500,

          //icpono izquierdo
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: context.isDark ? AppTheme.darkBackground : Colors.white,
              size: 22,
            ),
          ),

          //
          title: Text(
            "Comentarios E.G. White",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: context.textColor,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            "Lectura complementaria",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: context.subTextColor,
            ),
          ),

          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.cardColor.withOpacity(0.02),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
              child: Html(
                data: content,
                onLinkTap: onLinkTap,
                style: htmlStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
