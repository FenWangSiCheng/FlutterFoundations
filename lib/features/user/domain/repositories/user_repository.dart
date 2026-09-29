import '../entities/user.dart';
import '../failures/user_failure.dart';

/// Repository interface for user data operations
abstract class UserRepository {
  /// Fetches a user by their ID
  ///
  /// Throws [UserFailure] if the request fails
  /// Returns a [User] entity on success
  Future<User> getUser(String userId);
}
