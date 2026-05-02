class StatsEntity {
  final String quarterlyId;
  final String lessonId;
  final String weeklyLabel;
  final int weeklyCount;
  final String quarterlyPercentage;
  final int totalDaysStudied;
  final List<String> readDays;

  StatsEntity({
    required this.quarterlyId,
    required this.lessonId,
    required this.weeklyLabel,
    required this.weeklyCount,
    required this.quarterlyPercentage,
    required this.totalDaysStudied,
    required this.readDays,
  });
}
