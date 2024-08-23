import 'package:core/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);
}
