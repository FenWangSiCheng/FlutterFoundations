import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/user/data/mock/user_mock_setup.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/domain/usecase/get_user_use_case.dart';
import '../config/app_config.dart';
import '../network/dio_client.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies(AppConfig appConfig) async {
  getIt.registerSingleton<AppConfig>(appConfig);

  await getIt.init();
}

@module
abstract class RegisterModule {
  @injectable
  GetUserUseCase getUserUseCase(UserRepository repository) =>
      GetUserUseCase(repository);

  @preResolve
  @lazySingleton
  Future<DioClient> dioClient(AppConfig appConfig) async {
    final client = DioClient(
      appConfig,
      configureMock: UserMockSetup.configureMockAdapter,
    );
    await client.initialize();
    return client;
  }

  @lazySingleton
  Dio dio(DioClient dioClient) => dioClient.dio;
}
