import '../../domain/entities/stats_entity.dart';

class StatsModel extends StatsEntity {
  StatsModel({
    required super.quarterlyId,
    required super.lessonId,
    required super.weeklyLabel,
    required super.weeklyCount,
    required super.quarterlyPercentage,
    required super.totalDaysStudied,
    required super.readDays,
  });

  //Constructor factory
  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      quarterlyId: json['quarterlyId'] ?? '',
      lessonId: json['lessonId'] ?? '',
      weeklyLabel: json['weeklyLabel'] ?? '',
      weeklyCount: json['weeklyCount'] ?? 0,
      quarterlyPercentage: json['quarterlyPercentage'] ?? '0%',
      totalDaysStudied: json['totalDaysStudied'] ?? 0,
      readDays:
          (json['readDays'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
