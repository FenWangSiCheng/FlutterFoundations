import 'package:flutter_foundations/features/user/data/models/user_model.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(UserModel json) {
    return User(id: json.id, name: json.name, email: json.email);
  }
}
