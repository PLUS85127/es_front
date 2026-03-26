import '../../domain/entities/quarterly.dart';

class QuarterlyModel extends Quarterly {
  QuarterlyModel({
    required super.quarterlyId,
    required super.title,
    super.coverUrl,
  });

  factory QuarterlyModel.fromJson(Map<String, dynamic> json) {
    return QuarterlyModel(
      quarterlyId: json['QuarterlyId'],
      title: json['Title'],
      coverUrl: json['CoverUrl'], //image,
    );
  }
}
