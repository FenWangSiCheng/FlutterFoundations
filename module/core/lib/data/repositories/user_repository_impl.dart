import 'package:core/data/datasource/remote_datasource.dart';
import 'package:core/domain/entities/user.dart';
import 'package:core/domain/repositories/user_repository.dart';

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
