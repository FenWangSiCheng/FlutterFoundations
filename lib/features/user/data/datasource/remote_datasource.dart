import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class RemoteDataSource {
  Future<UserModel> getUser(String userId);
}

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> getUser(String userId) async {
    final response = await dio.get('/users/$userId');
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
