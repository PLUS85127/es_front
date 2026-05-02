import 'package:es_control/features/authentication/domain/use_cases/logout_usecase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/register_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/get_me_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetMeUseCase getMeUseCase;

  bool _isLoading = false;
  UserEntity? _user;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getMeUseCase,
  });

  bool get isLoading => _isLoading;
  UserEntity? get user => _user;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await loginUseCase.execute(email, password);

      _isLoading = false;
      notifyListeners();
      await loadUserProfile();

      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await registerUseCase.execute({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await logoutUseCase.execute();
      _user = null;
    } catch (e) {
      debugPrint("Error logout: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenStr = prefs.getString('token');

      if (tokenStr != null) {
        _user = await getMeUseCase.execute(tokenStr);
      }
    } catch (e) {
      debugPrint("Error cargando el perfil $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
