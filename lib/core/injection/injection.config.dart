// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_foundations/core/injection/injection.dart' as _i379;
import 'package:flutter_foundations/core/network/dio_client.dart' as _i542;
import 'package:flutter_foundations/features/user/data/datasource/remote_datasource.dart'
    as _i961;
import 'package:flutter_foundations/features/user/data/repositories/user_repository_impl.dart'
    as _i294;
import 'package:flutter_foundations/features/user/domain/repositories/user_repository.dart'
    as _i698;
import 'package:flutter_foundations/features/user/domain/usecase/get_user_use_case.dart'
    as _i376;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.lazySingletonAsync<_i542.DioClient>(
      () => registerModule.dioClient(),
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i542.DioClient>()),
    );
    gh.factory<_i961.RemoteDataSource>(
      () => _i961.RemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.factory<_i698.UserRepository>(
      () => _i294.UserRepositoryImpl(gh<_i961.RemoteDataSource>()),
    );
    gh.factory<_i376.GetUserUseCase>(
      () => _i376.GetUserUseCase(gh<_i698.UserRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i379.RegisterModule {}
