import 'package:core/apis/client.dart';
import 'package:core/injection.config.dart';
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
  Future<Dio> dio() async {
    return provideDio();
  }
}
