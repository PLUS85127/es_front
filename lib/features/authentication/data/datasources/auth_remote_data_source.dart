import 'dart:convert';
import 'package:es_control/core/network/api_conf.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  //Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.auth}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
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
}
