import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/network/api_conf.dart';

abstract class ChurchRemoteDataSource {
  Future<bool> createChurch(String token, String name, String address);
}

class ChurchRemoteDataSourceImpl implements ChurchRemoteDataSource {
  final http.Client client;

  ChurchRemoteDataSourceImpl({required this.client});

  @override
  Future<bool> createChurch(String token, String name, String address) async {
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/churches/create'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'address': address}),
    );
    return response.statusCode == 201;
  }
}
