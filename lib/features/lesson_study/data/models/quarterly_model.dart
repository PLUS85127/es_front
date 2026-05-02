import '../../domain/entities/quarterly.dart';

class QuarterlyModel extends Quarterly {
  final DateTime startDate;
  final DateTime endDate;

  QuarterlyModel({
    required super.quarterlyId,
    required super.title,
    super.coverUrl,
    required this.startDate,
    required this.endDate,
  });

  factory QuarterlyModel.fromJson(Map<String, dynamic> json) {
    return QuarterlyModel(
      quarterlyId: json['QuarterlyId'],
      title: json['Title'],
      coverUrl: json['CoverUrl'], //image,

      startDate: DateTime.parse(json['StartDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['EndDate'] ?? DateTime.now().toString()),
    );
  }
}
