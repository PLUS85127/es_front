import '../repositories/group_repository.dart';

class GetAttendanceUseCase {
  final GroupRepository groupRepository;

  GetAttendanceUseCase(this.groupRepository);

  Future<Map<String, dynamic>> execute(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
  ) async {
    return await groupRepository.getAttendance(
      token,
      groupId,
      quarterlyId,
      lessonId,
    );
  }
}
