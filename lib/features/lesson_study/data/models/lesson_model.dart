import '../../domain/entities/lesson.dart';

class LessonModel extends Lesson {
  LessonModel({required super.lessonId, required super.title});

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(lessonId: json['LessonId'], title: json['Title']);
  }
}
