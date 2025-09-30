import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_foundations/features/user/domain/entities/user.dart';
import 'package:flutter_foundations/features/user/domain/usecase/get_user_use_case.dart';
import 'package:flutter_foundations/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_foundations/features/user/presentation/bloc/user_event.dart';
import 'package:flutter_foundations/features/user/presentation/bloc/user_state.dart';

import 'user_bloc_test.mocks.dart';

@GenerateMocks([GetUserUseCase])
void main() {
  late UserBloc bloc;
  late MockGetUserUseCase mockGetUserUseCase;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    bloc = UserBloc(mockGetUserUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('UserBloc', () {
    const tUserId = '1';
    const tUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
    );

    test('initial state should be UserInitial', () {
      expect(bloc.state, equals(UserInitial()));
    });

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserLoaded] when LoadUserEvent is successful',
      build: () {
        when(mockGetUserUseCase.call(any)).thenAnswer((_) async => tUser);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUserEvent(tUserId)),
      expect: () => [
        UserLoading(),
        const UserLoaded(tUser),
      ],
      verify: (_) {
        verify(mockGetUserUseCase.call(tUserId)).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'should emit [UserLoading, UserError] when LoadUserEvent fails',
      build: () {
        when(mockGetUserUseCase.call(any)).thenThrow(Exception('Failed to load user'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUserEvent(tUserId)),
      expect: () => [
        UserLoading(),
        const UserError('Exception: Failed to load user'),
      ],
      verify: (_) {
        verify(mockGetUserUseCase.call(tUserId)).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'should call getUserUseCase with correct userId',
      build: () {
        when(mockGetUserUseCase.call(any)).thenAnswer((_) async => tUser);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUserEvent(tUserId)),
      verify: (_) {
        verify(mockGetUserUseCase.call(tUserId)).called(1);
        verifyNoMoreInteractions(mockGetUserUseCase);
      },
    );

    blocTest<UserBloc, UserState>(
      'should handle multiple LoadUserEvent independently',
      build: () {
        const userId1 = '1';
        const userId2 = '2';
        const user1 = User(id: '1', name: 'John', email: 'john@example.com');
        const user2 = User(id: '2', name: 'Jane', email: 'jane@example.com');

        when(mockGetUserUseCase.call(userId1)).thenAnswer((_) async => user1);
        when(mockGetUserUseCase.call(userId2)).thenAnswer((_) async => user2);
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const LoadUserEvent('1'));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const LoadUserEvent('2'));
      },
      expect: () => [
        UserLoading(),
        const UserLoaded(User(id: '1', name: 'John', email: 'john@example.com')),
        UserLoading(),
        const UserLoaded(User(id: '2', name: 'Jane', email: 'jane@example.com')),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should emit UserError with error message on generic exception',
      build: () {
        when(mockGetUserUseCase.call(any)).thenThrow(Exception('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUserEvent(tUserId)),
      expect: () => [
        UserLoading(),
        const UserError('Exception: Network error'),
      ],
    );
  });
}