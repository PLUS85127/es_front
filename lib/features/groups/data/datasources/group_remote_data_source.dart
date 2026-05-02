import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:es_control/core/network/api_conf.dart';
import '../models/group_model.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupModel>> getMyGroups(String token);
  Future<GroupModel> createGroup(String token, String name, int leaderId);
  Future<bool> joinGroup(String token, String code);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final http.Client client;

  GroupRemoteDataSourceImpl({required this.client});

  @override
  Future<List<GroupModel>> getMyGroups(String token) async {
    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/groups/my-groups'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['ok'] == true && decoded['result'] != null) {
        final List<dynamic> list = decoded['result'];
        return list.map((item) => GroupModel.fromJson(item)).toList();
      }
      return [];
    } else {
      throw Exception('Error al obtener los grupos');
    }
  }

  @override
  Future<GroupModel> createGroup(
    String token,
    String name,
    int leaderId,
  ) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/groups/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({"name": name, "leaderId": leaderId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      final groupData = decoded['result'] ?? decoded;
      return GroupModel.fromJson(groupData);
    } else {
      throw Exception('Error al crear el grupo');
    }
  }

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
      return true;
    } else {
      throw Exception('Error al unirse al grupo. Verifica el código.');
    }
  }
}
