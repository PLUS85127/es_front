import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:es_control/core/theme/app_html_styles.dart';
import '../providers/lesson_provider.dart';
import '../page/bible_verse_modal.dart';
import 'study_question_widget.dart';

class StudyHtmlRenderer extends StatelessWidget {
  final String htmlContent;
  final List bibleData;
  final double fontSize;
  final String dayId;
  final LessonProvider provider;

  const StudyHtmlRenderer({
    super.key,
    required this.htmlContent,
    required this.bibleData,
    required this.fontSize,
    required this.dayId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlContent,
      onLinkTap: (url, attributes, element) {
        _handleLinkTap(context, url, attributes);
      },
      style: AppHtmlStyles.getBaseStyle(context, fontSize),
      extensions: [
        TagExtension(
          tagsToExtend: {"code"},
          builder: (extCtx) => StudyQuestionWidget(
            innerHtml: extCtx.element?.innerHtml ?? "",
            fontSize: fontSize,
            dayId: dayId,
            provider: provider,
          ),
        ),
      ],
    );
  }

  void _handleLinkTap(
    BuildContext context,
    String? url,
    Map<String, String> attr,
  ) {
    String? verseId = attr['verse'];
    if (verseId == null && url != null && url.startsWith('verse://')) {
      verseId = url.replaceFirst('verse://', '');
    }
    if (verseId != null && verseId.isNotEmpty) {
      BibleVerseModal.show(
        context: context,
        verseIds: verseId,
        bibleData: bibleData,
      );
    }
  }
}
