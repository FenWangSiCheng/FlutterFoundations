import 'dart:convert';

import 'package:core/apis/api_service.dart';
import 'package:core/data/models/user_model.dart';

class RemoteDataSource {
  final ApiService apiService;

  RemoteDataSource(this.apiService);

  Future<UserModel> getUser(String userId) async {
    final response = await apiService.get('/users/$userId');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.data);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }
}