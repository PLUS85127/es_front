import 'package:flutter/material.dart';
import '../../data/datasources/auth_remote_data_source.dart';

class AuthProvider extends ChangeNotifier {
  final _dataSource = AuthRemoteDataSource();
  bool _isLoading = false;
  String? _userRole;
  String? _firstName;

  bool get isLoading => _isLoading;
  String? get userRole => _userRole;
  String? get firstName => _firstName;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _dataSource.login(email, password);
      _userRole = data['role']; // Guardamos si es PASTOR, DIRECTOR, etc.
      _firstName = data['user']['firstName']; // Guardamos el nombre del usuario
      // Aquí podrías guardar el token en FlutterSecureStorage
      _isLoading = false;
      notifyListeners();
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
      await _dataSource.register({
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
  }
}
