import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:es_control/core/theme/app_theme.dart';
import '../../core/theme/theme_extension.dart';

class AppHtmlStyles {
  //tamaño dinamico
  static Map<String, Style> getBaseStyle(
    BuildContext context,
    double fontSize,
  ) {
    return {
      "body": Style(
        fontSize: FontSize(fontSize),
        lineHeight: LineHeight(1.6),
        fontFamily: 'Poppins',
        color: context.textColor,
      ),
      "a": Style(
        color: context.iconColor,
        fontWeight: FontWeight.bold,
        textDecoration: TextDecoration.underline,
      ),
      "blockquote": Style(
        backgroundColor: context.cardColor,
        border: Border(left: BorderSide(color: AppTheme.navyBlue, width: 5.0)),

        padding: HtmlPaddings.symmetric(horizontal: 15, vertical: 10),
        margin: Margins.only(top: 15, bottom: 15),
        fontStyle: FontStyle.italic,
        color: context.subTextColor,
      ),
    };
  }
}
