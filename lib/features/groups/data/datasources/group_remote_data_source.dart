import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:es_control/core/network/api_conf.dart';
import '../models/group_model.dart';
import '../../../authentication/data/models/user_model.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupModel>> getMyGroups(String token);
  Future<String> createGroup(String token, String name, int leaderId);
  Future<bool> joinGroup(String token, String code);
  Future<List<UserModel>> getGroupMembers(String token, String groupId);
  Future<bool> leaveGroup(String token, String groupId);

  Future<Map<String, dynamic>> getAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
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

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final http.Client client;

  GroupRemoteDataSourceImpl({required this.client});

  //obtener grupos del usuario actual
  @override
  Future<List<GroupModel>> getMyGroups(String token) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/groups/my-groups'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['ok'] == true && decoded['result'] != null) {
        final List list = decoded['result'];
        return list.map((item) => GroupModel.fromJson(item)).toList();
      }
    }
    throw Exception('Error al obtener los grupos ${response.body}');
  }

  //crear grupo
  @override
  Future<String> createGroup(String token, String name, int leaderId) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/groups/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({"name": name, "leaderId": leaderId}),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['ok'] == true && decoded['code'] != null) {
        return decoded['code'];
      }
    }
    throw Exception('Error al crear el grupo ${response.body}');
  }

  //unirse a grupo
  @override
  Future<bool> joinGroup(String token, String code) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/groups/join'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({"code": code}),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['ok'] == true;
    } else {
      throw Exception('Error al unirse al grupo ${response.body}');
    }
  }

  //obtener miembros del grupo
  @override
  Future<List<UserModel>> getGroupMembers(String token, String groupId) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/groups/$groupId/members'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['ok'] == true && decoded['result'] != null) {
        final List list = decoded['result'];
        return list.map((item) => UserModel.fromJson(item)).toList();
      }
    }
    return [];
  }

  //salir de grupo
  @override
  Future<bool> leaveGroup(String token, String groupId) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/groups/$groupId/leave'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['ok'] == true;
    }
    return false;
  }

  //obtener asistencia
  @override
  Future<Map<String, dynamic>> getAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
  ) async {
    final response = await client.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/groups/$groupId/attendance/$quarterlyId/$lessonId',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['ok'] == true) {
        return decoded;
      }
    }
    return {};
  }

  @override
  Future<bool> markAttendance(
    String token,
    String groupId,
    String quarterlyId,
    String lessonId,
    List<int> presentUserIds,
    int visits,
    List<Map<String, dynamic>> progressData,
  ) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/groups/$groupId/attendance'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'quarterlyId': quarterlyId,
        'lessonId': lessonId,
        'presentUserIds': presentUserIds,
        'visits': visits,
        'progressData': progressData,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['ok'] == true;
    }
    return false;
  }
}
