import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUser(String userId) async {
    try {
      final userModel = await remoteDataSource.getUser(userId);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
}
