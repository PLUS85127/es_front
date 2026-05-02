import 'package:es_control/core/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:es_control/core/theme/app_theme.dart';

class BibleVerseModal {
  static void show({
    required BuildContext context,
    required String verseIds,
    required List<dynamic> bibleData,
  }) {
    final Map<String, dynamic> allVerses = bibleData.isNotEmpty
        ? bibleData[0]['verses'] ?? {}
        : {};

    String content = allVerses[verseIds] ?? "";

    if (content.isEmpty) {
      final List<String> ids = verseIds
          .split(',')
          .map((e) => e.trim())
          .toList();
      for (var id in ids) {
        if (allVerses.containsKey(id)) {
          content += "${allVerses[id]}<br>";
        }
      }
    }

    if (content.isEmpty) {
      content = "<p>Versículo no encontrado ($verseIds)</p>";
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: context.subTextColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: context.subIconColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 25,
                    ),
                    child: Html(
                      data: content,
                      style: {
                        "h2": Style(
                          fontSize: FontSize(18),
                          fontWeight: FontWeight.bold,
                          color: context.iconColor,
                          fontFamily: 'Poppins',
                          margin: Margins.only(bottom: 8, top: 0),
                        ),
                        "body": Style(
                          fontSize: FontSize(16),
                          lineHeight: LineHeight(1.5),
                          fontFamily: 'Poppins',
                          color: context.textColor,
                          margin: Margins.zero,
                        ),
                        "sup": Style(
                          color: context.iconColor,
                          fontWeight: FontWeight.bold,
                        ),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
