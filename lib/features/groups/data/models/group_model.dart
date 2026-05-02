import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.id,
    required super.name,
    required super.code,
    super.directorId,
    super.leaderId,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['Id']?.toString() ?? '',
      name: json['GroupName'] ?? 'Sin asignar',
      code: json['GroupCode'] ?? '',
      directorId: json['DirectorId']?.toString(),
      leaderId: json['LeaderId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'GroupName': name,
      'GroupCode': code,
      'DirectorId': directorId,
      'LeaderId': leaderId,
    };
  }
}
