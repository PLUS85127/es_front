import 'package:es_control/core/theme/app_html_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/core/utils/ui_helper.dart';
import 'package:es_control/core/utils/html_parser_helper.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:es_control/features/reporting/presentation/provider/stats_provider.dart';
import '../../../../core/theme/theme_extension.dart';
import '../providers/lesson_provider.dart';
import 'study_toggle_button.dart';
import 'egw_accordion.dart';
import 'study_font_size_toolbar.dart';
import 'study_lesson_title.dart';
import 'study_html_renderer.dart';
import 'package:flutter/foundation.dart';

class StudyContent extends StatefulWidget {
  final String quarterlyId;
  final String lessonId;
  final String dayId;

  const StudyContent({
    super.key,
    required this.quarterlyId,
    required this.lessonId,
    required this.dayId,
  });

  @override
  State<StudyContent> createState() => _StudyContentState();
}

class _StudyContentState extends State<StudyContent>
    with AutomaticKeepAliveClientMixin {
  late Future<void> _fetchFuture;
  bool _isProcessing = false;
  dynamic _parsedData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchFuture = _initData();
  }

  Future<void> _initData() async {
    final statsProv = context.read<StatsProvider>();
    final auth = context.read<AuthProvider>();
    final lessonProv = context.read<LessonProvider>();

    try {
      if (auth.user?.token != null &&
          (statsProv.currentStats == null ||
              statsProv.currentStats!.lessonId != widget.lessonId)) {
        await statsProv.fetchMyStats(
          auth.user!.token,
          widget.quarterlyId,
          widget.lessonId,
        );
      }

      if (mounted) {
        await lessonProv.fetchDayRead(
          widget.quarterlyId,
          widget.lessonId,
          widget.dayId,
        );
      }

      if (mounted) {
        final data = lessonProv.dayReads[widget.dayId];
        if (data != null && data['content'] != null) {
          _parsedData = await compute(
            HtmlParserHelper.parseContent,
            data['content'] as String?,
          );
        }
      }

      _syncState();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error al cargar datos")));
      }
    }
  }

  void _syncState() {
    final stats = context.read<StatsProvider>();
    final lessonProv = context.read<LessonProvider>();

    if (stats.currentStats != null) {
      bool isRead = stats.currentStats!.readDays.any(
        (id) => id.endsWith("-${widget.dayId}"),
      );

      if (lessonProv.dayReads.containsKey(widget.dayId)) {
        lessonProv.dayReads[widget.dayId]!['isRead'] = isRead;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => lessonProv.notifyListeners(),
        );
      }
    }
  }

  Future<void> _handleToggle() async {
    setState(() => _isProcessing = true);
    final auth = context.read<AuthProvider>();
    final provider = context.read<LessonProvider>();
    final statsProv = context.read<StatsProvider>();
    if (auth.user?.token != null) {
      final success = await provider.markDayAsRead(
        auth.user!.token,
        widget.quarterlyId,
        widget.lessonId,
        widget.dayId,
      );

      if (success && mounted) {
        await statsProv.fetchMyStats(
          auth.user!.token,
          widget.quarterlyId,
          widget.lessonId,
        );

        final bool isRead = provider.dayReads[widget.dayId]?['isRead'] ?? false;
        UIHelper.showCustomSnackBar(
          context,
          isRead ? "¡Estudiado!" : "Pendiente",
          isSuccess: isRead,
        );
      }
    }
    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: _fetchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: context.iconColor),
          );
        }
        return Consumer<LessonProvider>(
          builder: (context, provider, _) {
            final data = provider.dayReads[widget.dayId];
            if (data == null || _parsedData == null) return const SizedBox();

            return SelectionArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StudyFontSizeToolbar(provider: provider),
                    StudyLessonTitle(
                      title: data['title'] ?? "",
                      fontSize: provider.currentFontSize,
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: StudyHtmlRenderer(
                        key: ValueKey(provider.currentFontSize),
                        htmlContent: _parsedData.mainContent,
                        bibleData: data['bible'] ?? [],
                        fontSize: provider.currentFontSize,
                        dayId: widget.dayId,
                        provider: provider,
                      ),
                    ),
                    if (_parsedData.egwContent.isNotEmpty)
                      EgwAccordion(
                        content: _parsedData.egwContent,
                        htmlStyle: AppHtmlStyles.getBaseStyle(
                          context,
                          provider.currentFontSize,
                        ),
                        onLinkTap: (u, a, e) {},
                      ),
                    const SizedBox(height: 30),
                    StudyToggleButton(
                      isStudied: data['isRead'] ?? false,
                      isProcessing: _isProcessing,
                      onPressed: _isProcessing ? null : _handleToggle,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
