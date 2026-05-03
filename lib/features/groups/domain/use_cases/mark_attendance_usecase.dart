import '../repositories/group_repository.dart';

class MarkAttendanceUseCase {
  final GroupRepository groupRepository;

  MarkAttendanceUseCase(this.groupRepository);

  Future<bool> execute(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
    List<int> presentUserIds,
    int visits,
  ) async {
    return await groupRepository.markAttendance(
      token,
      groupId,
      quarterlyId,
      lessonId,
      presentUserIds,
      visits,
    );
  }
}
