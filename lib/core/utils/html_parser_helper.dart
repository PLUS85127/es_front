class ParsedLesson {
  final String mainContent;
  final String egwContent;

  ParsedLesson({required this.mainContent, required this.egwContent});
}

class HtmlParserHelper {
  static ParsedLesson parseContent(String? rawContent) {
    if (rawContent == null || rawContent.isEmpty) {
      return ParsedLesson(mainContent: "", egwContent: "");
    }

    final String cleanHtml = rawContent
        .replaceAll(r'\u003C', '<')
        .replaceAll(r'\u003E', '>')
        .replaceAll(r'\u0022', '"');

    final String withLinks = cleanHtml.replaceAllMapped(
      RegExp(r'<a\s+(.*?)>'),
      (match) {
        String atributos = match.group(1) ?? '';
        final verseMatch = RegExp(r'verse="([^"]+)"').firstMatch(atributos);

        if (verseMatch != null && !atributos.contains('href=')) {
          final verseId = verseMatch.group(1);
          return '<a href="verse://$verseId" $atributos>';
        }
        return match.group(0)!;
      },
    );

    String mainContent = withLinks;
    String egwContent = "";

    if (withLinks.contains('<h4 id="comentarios-elena-gw">')) {
      final parts = withLinks.split('<h4 id="comentarios-elena-gw">');
      mainContent = parts[0].replaceAll(RegExp(r'<hr>\s*$'), '');
      egwContent = parts[1].replaceFirst(RegExp(r'.*?</h4>'), '');
    }

    return ParsedLesson(mainContent: mainContent, egwContent: egwContent);
  }
}
