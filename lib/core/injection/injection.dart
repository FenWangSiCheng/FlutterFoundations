import '../network/dio_client.dart';
import 'injection.config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
}

@module
abstract class RegisterModule {
  @preResolve
  @lazySingleton
  Future<DioClient> dioClient() async {
    final client = DioClient();
    await client.initialize();
    return client;
  }

  @lazySingleton
  Dio dio(DioClient dioClient) => dioClient.dio;
}
