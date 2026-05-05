import 'package:es_control/features/authentication/domain/entities/user_entity.dart';
import '../entities/group_entity.dart';

abstract class GroupRepository {
  // Obtener grupos del usuario actual
  Future<List<GroupEntity>> getMyGroups(String token);

  // Crear grupo
  Future<String?> createGroup(String token, String name, int leaderId);

  // Unirse a grupo
  Future<bool> joinGroup(String token, String code);

  //Verembros de grupo
  Future<List<UserEntity>> getGroupMembers(String token, String groupId);

  // Salir de grupo
  Future<bool> leaveGroup(String token, String groupId);

  //asistencia a clase
  Future<Map<String, dynamic>> getAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
    //List<Map<String, dynamic>> progressData,
  );

  Future<bool> markAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
    List<int> presentUserIds,
    int visits,
    List<Map<String, dynamic>> progressData,
  );
}
