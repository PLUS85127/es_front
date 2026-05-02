import 'dart:convert';
import 'package:es_control/core/network/api_conf.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteDataSource {
  //Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      return data;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Error en Login');
    }
  }

  //registro
  Future<void> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode != 201) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Error al registrar',
      );
    }
  }

  //salir 'logout'
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Map<String, dynamic>> getMe(String token) async {
    final response = await http.get(
      //http://localhost:3000/api/v1/auth/me
      Uri.parse('${ApiConfig.auth}/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error cargando el perfil");
    }
  }
}
