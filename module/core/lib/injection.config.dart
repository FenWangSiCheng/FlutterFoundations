// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:core/apis/api_service.dart' as _i588;
import 'package:core/core.dart' as _i494;
import 'package:core/data/datasource/remote_datasource.dart' as _i975;
import 'package:core/data/repositories/user_repository_impl.dart' as _i794;
import 'package:core/domain/repositories/user_repository.dart' as _i414;
import 'package:core/domain/usecase/get_user_use_case.dart' as _i585;
import 'package:core/injection.dart' as _i336;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.lazySingletonAsync<_i361.Dio>(
      () => registerModule.dio(),
      preResolve: true,
    );
    gh.factory<_i588.ApiService>(() => _i588.ApiService(dio: gh<_i361.Dio>()));
    gh.factory<_i975.RemoteDataSource>(
        () => _i975.RemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.factory<_i494.UserRepository>(
        () => _i794.UserRepositoryImpl(gh<_i494.RemoteDataSource>()));
    gh.factory<_i585.GetUserUseCase>(
        () => _i585.GetUserUseCase(gh<_i414.UserRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i336.RegisterModule {}
