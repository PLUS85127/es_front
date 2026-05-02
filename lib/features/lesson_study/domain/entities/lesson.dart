class Lesson {
  final String lessonId;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;

  Lesson({
    required this.lessonId,
    required this.title,
    this.startDate,
    this.endDate,
  });
}
