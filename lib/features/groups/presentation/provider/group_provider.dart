import 'package:flutter/material.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/use_cases/get_my_groups_usecase.dart';
import '../../domain/use_cases/create_group_usecase.dart';
import '../../domain/use_cases/join_group_usecase.dart';

class GroupProvider extends ChangeNotifier {
  final GetMyGroupsUseCase getMyGroupsUseCase;
  final CreateGroupUseCase createGroupUseCase;
  final JoinGroupUseCase joinGroupUseCase;

  GroupProvider({
    required this.getMyGroupsUseCase,
    required this.createGroupUseCase,
    required this.joinGroupUseCase,
  });

  List<GroupEntity> _myGroups = [];
  List<GroupEntity> get joinedGroups => _myGroups;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadMyGroups(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myGroups = await getMyGroupsUseCase.execute(token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<GroupEntity?> createNewGroup(
    String token,
    String name,
    int leaderId,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newGroup = await createGroupUseCase.execute(token, name, leaderId);
      _myGroups.add(newGroup);
      _isLoading = false;
      notifyListeners();
      return newGroup;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> joinExistingGroup(String token, String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await joinGroupUseCase.execute(token, code);
      if (success) {
        await loadMyGroups(token);
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
