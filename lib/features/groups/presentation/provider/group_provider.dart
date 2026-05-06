import 'package:flutter/material.dart';
import '../../domain/entities/group_entity.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/use_cases/get_my_groups_usecase.dart';
import '../../domain/use_cases/create_group_usecase.dart';
import '../../domain/use_cases/join_group_usecase.dart';
import '../../domain/use_cases/get_group_members_usecase.dart';
import '../../domain/use_cases/leave_group_usecase.dart';
import '../../domain/use_cases/get_attendance_usecase.dart';
import '../../domain/use_cases/mark_attendance_usecase.dart';

class GroupProvider extends ChangeNotifier {
  final GetMyGroupsUseCase getMyGroupsUseCase;
  final CreateGroupUseCase createGroupUseCase;
  final JoinGroupUseCase joinGroupUseCase;
  final GetGroupMembersUseCase getGroupMembersUseCase;
  final LeaveGroupUseCase leaveGroupUseCase;
  final GetAttendanceUseCase getAttendanceUseCase;
  final MarkAttendanceUseCase markAttendanceUseCase;

  GroupProvider({
    required this.getMyGroupsUseCase,
    required this.createGroupUseCase,
    required this.joinGroupUseCase,
    required this.getGroupMembersUseCase,
    required this.leaveGroupUseCase,
    required this.getAttendanceUseCase,
    required this.markAttendanceUseCase,
  });

  //ver mi grupo
  List<GroupEntity> _myGroups = [];
  List<GroupEntity> get myGroups => _myGroups;

  //ver miembros de grupo
  List<UserEntity> _currentGroupMembers = [];
  List<UserEntity> get currentGroupMembers => _currentGroupMembers;

  //guardar asistencia
  Map<String, dynamic> _currentAttendance = {};
  Map<String, dynamic> get attendance => _currentAttendance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  //cargar mis grupos
  Future<void> loadMyGroups(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myGroups = await getMyGroupsUseCase.execute(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //crear grupo
  Future<String?> createNewGroup(
    String token,
    String name,
    int leaderId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newGroup = await createGroupUseCase.execute(token, name, leaderId);
      if (newGroup != null) {
        await loadMyGroups(token);
      }

      return newGroup;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //unirse a grupo
  Future<bool> joinExistingGroup(String token, String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await joinGroupUseCase.execute(token, code);
      if (success) {
        await loadMyGroups(token); //si se un recargar lista
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //cargar asistencia
  Future<void> loadAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentAttendance = await getAttendanceUseCase.execute(
        token,
        groupId,
        quarterlyId,
        lessonId,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _currentAttendance = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //guardar/marcar asistencia
  Future<bool> saveAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
    List<int> presentUserIds,
    int visits,
    List<Map<String, dynamic>> progressData,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await markAttendanceUseCase.execute(
        token,
        groupId,
        quarterlyId,
        lessonId,
        presentUserIds,
        visits,
        progressData,
      );

      if (success) {
        await loadAttendance(token, groupId, quarterlyId, lessonId);
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadGroupMembers(
    String token,
    String groupId,
    String qId,
    String lId,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final members = await getGroupMembersUseCase.execute(
        token,
        groupId,
        qId,
        lId,
      );
      _currentGroupMembers = members;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
