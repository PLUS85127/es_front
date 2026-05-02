class Quarterly {
  final String quarterlyId;
  final String title;
  final String? coverUrl;

  final DateTime? startDate;
  final DateTime? endDate;

  Quarterly({
    required this.quarterlyId,
    required this.title,
    this.coverUrl,
    this.startDate,
    this.endDate,
  });
}
