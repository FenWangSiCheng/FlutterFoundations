import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_foundations/features/user/data/datasource/remote_datasource.dart';
import 'package:flutter_foundations/features/user/data/models/user_model.dart';

import 'remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late RemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = RemoteDataSourceImpl(mockDio);
  });

  group('RemoteDataSource - getUser', () {
    const tUserId = '1';
    const tUserModel = UserModel(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
    );

    test('should perform a GET request to /users/:userId', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: {
            'id': '1',
            'name': 'John Doe',
            'email': 'john@example.com',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/$tUserId'),
        ),
      );

      await dataSource.getUser(tUserId);

      verify(mockDio.get('/users/$tUserId')).called(1);
    });

    test('should return UserModel when response is successful (200)', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: {
            'id': '1',
            'name': 'John Doe',
            'email': 'john@example.com',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users/$tUserId'),
        ),
      );

      final result = await dataSource.getUser(tUserId);

      expect(result, equals(tUserModel));
    });

    test('should throw an Exception when response is unsuccessful', () async {
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: {'error': 'User not found'},
          statusCode: 404,
          requestOptions: RequestOptions(path: '/users/$tUserId'),
        ),
      );

      expect(
        () => dataSource.getUser(tUserId),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw DioException when network error occurs', () async {
      when(mockDio.get(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/users/$tUserId'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => dataSource.getUser(tUserId),
        throwsA(isA<DioException>()),
      );
    });
  });
}