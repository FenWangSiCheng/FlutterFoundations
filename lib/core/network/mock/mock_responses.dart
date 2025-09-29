import 'dart:convert';
import 'package:flutter/services.dart';

class MockResponses {
  static List<Map<String, dynamic>>? _cachedUsers;

  static Future<List<Map<String, dynamic>>> loadUserList() async {
    if (_cachedUsers != null) {
      return _cachedUsers!;
    }

    try {
      final String response = await rootBundle.loadString('assets/mock/users.json');
      final List<dynamic> jsonList = jsonDecode(response);
      _cachedUsers = jsonList.cast<Map<String, dynamic>>();
      return _cachedUsers!;
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getUserById(String userId) async {
    final users = await loadUserList();
    try {
      return users.firstWhere((user) => user['id'] == userId);
    } catch (e) {
      return null;
    }
  }
}