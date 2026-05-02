import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:es_control/core/theme/app_theme.dart';
import 'package:es_control/features/authentication/presentation/provider/auth_provider.dart';
import 'package:es_control/features/lesson_study/presentation/providers/lesson_provider.dart';
import '../provider/stats_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/circular_progress_card.dart';
import '../widgets/week_selector.dart';
import '../../../../core/theme/theme_extension.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? _selectedLessonId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final lessonProv = context.read<LessonProvider>();

      context.read<StatsProvider>().loadCurrentWeekStats(
        token: auth.user?.token,
        currentQuarterly: lessonProv.currentQuarterly,
        currentLesson: lessonProv.currentLesson,
      );
    });
  }

  Future<void> _fetchStatsForLesson(String lessonId) async {
    final auth = context.read<AuthProvider>();
    final lp = context.read<LessonProvider>();
    final stats = context.read<StatsProvider>();

    if (auth.user?.token != null && lp.currentQuarterly != null) {
      await stats.fetchMyStats(
        auth.user!.token,
        lp.currentQuarterly!.quarterlyId,
        lessonId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LessonProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (_selectedLessonId != null)
              await _fetchStatsForLesson(_selectedLessonId!);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mi Progreso",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: context.textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      WeekSelector(
                        lessons: lp.lessons,
                        selectedLessonId: _selectedLessonId,
                        currentLessonId: lp.currentLesson?.lessonId,
                        onLessonSelected: (id) {
                          setState(() => _selectedLessonId = id);
                          _fetchStatsForLesson(id);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Consumer<StatsProvider>(
                builder: (context, sp, child) {
                  if (sp.isLoading)
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  if (sp.currentStats == null)
                    return const SliverToBoxAdapter(
                      child: Center(child: Text("Selecciona una semana")),
                    );

                  final stats = sp.currentStats!;

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        CircularProgressCard(
                          progressValue: sp.weeklyProgressValue,
                          mainText: "${stats.weeklyCount}/7",
                          subText: "Días leídos",
                        ),
                        const SizedBox(height: 25),

                        //estadisticas
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 1.1,
                          children: [
                            _buildCompactStat(
                              "Asistencia",
                              "Pendiente",
                              Icons.event_available,
                              Colors.orange,
                            ),
                            _buildCompactStat(
                              "Trimestre",
                              stats.quarterlyPercentage,
                              Icons.pie_chart,
                              Colors.green,
                            ),
                            _buildCompactStat(
                              "Total Trimestrales",
                              "${stats.totalDaysStudied}",
                              Icons.stars,
                              context.iconColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStat(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.3 : 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: context.subTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
