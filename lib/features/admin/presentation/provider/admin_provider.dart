import 'package:flutter/material.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/use_cases/assign_role_usecase.dart';
import '../../domain/use_cases/search_user_usecase.dart';
import '../../domain/use_cases/transfer_user_church_usecase.dart';

class AdminProvider extends ChangeNotifier {
  final SearchUserUseCase searchUserUseCase;
  final AssignRoleUseCase assignRoleUseCase;
  final TransferUserChurchUseCase transferUserChurchUseCase;

  AdminProvider({
    required this.assignRoleUseCase,
    required this.searchUserUseCase,
    required this.transferUserChurchUseCase,
  });

  UserEntity? _searchedUser;
  UserEntity? get searchedUser => _searchedUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  //limpiar
  void clearSearch() {
    _searchedUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  //buscar por correo
  Future<void> searchUserByEmail(String token, String email) async {
    _isLoading = true;
    _errorMessage = null;
    _searchedUser = null;
    notifyListeners();

    try {
      final user = await searchUserUseCase.execute(token, email);
      if (user != null) {
        _searchedUser = user;
      } else {
        _errorMessage = 'No se encontró el usuario';
      }
    } catch (e) {
      _errorMessage = 'Error al buscar el usuario';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //cambiar rol
  Future<bool> changeRole(
    String token,
    int targetUserId,
    UserRole newRole,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await assignRoleUseCase.execute(
        token,
        targetUserId,
        newRole,
      );
      if (success) {
        clearSearch();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error al cambiar el rol';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //transferir iglesia
  Future<bool> transferMember(
    String token,
    int targetUserId,
    int newChurchId,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await transferUserChurchUseCase.execute(
        token,
        targetUserId,
        newChurchId,
      );
      if (success) {
        clearSearch();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Error al transferir el miembro';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
