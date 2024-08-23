import 'package:core/domain/entities/user.dart';
import 'package:core/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<User> call(String userId) async {
    return await repository.getUser(userId);
  }
}
