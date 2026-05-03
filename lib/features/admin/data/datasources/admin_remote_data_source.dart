import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_conf.dart';
import '../../../authentication/data/models/user_model.dart';

abstract class AdminRemoteDataSource {
  Future<UserModel?> searchUserByEmail(String token, String email);
  Future<bool> assignRole(String token, int targetUserId, String newRole);
  Future<bool> transferUserChurch(
    String token,
    int targetUserId,
    int newChurchId,
  );
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final http.Client client;

  AdminRemoteDataSourceImpl({required this.client});

  //buscar usuario por correo electrónico
  @override
  Future<UserModel?> searchUserByEmail(String token, String email) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/user/search?email=$email');
    final response = await client.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['ok'] == true && decoded['user'] != null) {
        return UserModel.fromJson(decoded['user']);
      }
      return null;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al buscar el usuario ${response.body}');
    }
  }

  //asignar rol a usuario
  @override
  Future<bool> assignRole(
    String token,
    int targetUserId,
    String newRole,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/user/assign-role');
    final response = await client.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'targetUserId': targetUserId, 'newRole': newRole}),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['ok'] == true;
    }
    throw Exception('Error al asignar el rol ${response.body}');
  }

  //transferir usuario a otra iglesia
  @override
  Future<bool> transferUserChurch(
    String token,
    int targetUserId,
    int newChurchId,
  ) async {
    final response = await client.patch(
      Uri.parse('${ApiConfig.baseUrl}/user/transfer-church'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'targetUserId': targetUserId,
        'newChurchId': newChurchId,
      }),
    );
    return response.statusCode == 200;
  }

  @override
  Future<bool> markDayAsRead(
    String token,
    String qId,
    String lId,
    String dId,
    String lang,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/progress/toggle');
    final response = await client.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'qId': qId, 'lId': lId, 'dId': dId, 'lang': lang}),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['ok'] == true;
    }
    return false;
  }

  @override
  Future<void> finishWeek(
    String token,
    String quarterlyId,
    String lessonId,
  ) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/progress/finish-week'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'quarterlyId': quarterlyId, 'lessonId': lessonId}),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['ok'] == true;
    }
    return false;
  }
}
