import 'package:injectable/injectable.dart';

import '../../../../core/network/error/exception.dart';
import '../../domain/entities/user.dart';
import '../../domain/failures/user_failure.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasource/remote_datasource.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUser(String userId) async {
    try {
      final userModel = await remoteDataSource.getUser(userId);
      return userModel.toEntity();
    } on ApiException catch (error) {
      throw UserFailure(
        error.errorCode == 404
            ? UserFailureType.notFound
            : UserFailureType.unavailable,
      );
    }
  }
}
