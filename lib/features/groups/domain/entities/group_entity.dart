class GroupEntity {
  final String id;
  final String name;
  final String code;
  final String? directorId;
  final String? leaderId;

  GroupEntity({
    required this.id,
    required this.name,
    required this.code,
    this.directorId,
    this.leaderId,
  });
}
