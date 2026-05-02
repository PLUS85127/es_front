import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  LessonModel({
    required super.lessonId,
    required super.title,
    required super.startDate,
    required super.endDate,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      lessonId: (json['LessonId'] ?? json['lessonId']),
      title: (json['Title'] ?? json['title']),
      startDate: DateTime.parse(json['StartDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['EndDate'] ?? DateTime.now().toString()),
    );
  }
}
