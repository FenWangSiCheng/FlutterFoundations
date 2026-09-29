import 'dart:convert';

import 'package:flutter/services.dart';

class UserMockResponses {
  static Future<List<Map<String, dynamic>>> loadUserList() async {
    final response = await rootBundle.loadString('assets/mock/users.json');
    final List<dynamic> jsonList = jsonDecode(response);
    return jsonList.cast<Map<String, dynamic>>();
  }

  static Map<String, dynamic>? getUserById(
    List<Map<String, dynamic>> users,
    String userId,
  ) {
    for (final user in users) {
      if (user['id'] == userId) {
        return user;
      }
    }
    return null;
  }
}
