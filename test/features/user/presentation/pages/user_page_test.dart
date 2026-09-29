import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_foundations/features/user/domain/entities/user.dart';
import 'package:flutter_foundations/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_foundations/features/user/presentation/bloc/user_event.dart';
import 'package:flutter_foundations/features/user/presentation/bloc/user_state.dart';
import 'package:flutter_foundations/features/user/presentation/pages/user_page.dart';

import 'user_page_test.mocks.dart';

@GenerateMocks([UserBloc])
void main() {
  late MockUserBloc mockUserBloc;
  const testUser = User(id: '1', name: 'John Doe', email: 'john@example.com');
  const loadedState = UserLoaded(testUser);

  setUp(() {
    mockUserBloc = MockUserBloc();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<UserBloc>.value(value: mockUserBloc, child: child),
    );
  }

  Future<void> pumpPage(WidgetTester tester, UserState state) async {
    when(mockUserBloc.state).thenReturn(state);
    when(mockUserBloc.stream).thenAnswer((_) => Stream.value(state));
    await tester.pumpWidget(makeTestableWidget(const UserPage()));
    await tester.pump();
  }

  group('UserPage', () {
    testWidgets('should display loading indicator when state is UserLoading', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, UserLoading());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('User Info'), findsOneWidget);
    });

    testWidgets('should display user data when state is UserLoaded', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, loadedState);

      expect(find.text('ID: 1'), findsOneWidget);
      expect(find.text('Name: John Doe'), findsOneWidget);
      expect(find.text('Email: john@example.com'), findsOneWidget);
      expect(find.text('Load Different Users:'), findsOneWidget);
      expect(find.text('User 1'), findsOneWidget);
      expect(find.text('User 2'), findsOneWidget);
      expect(find.text('User 3'), findsOneWidget);
    });

    testWidgets('should display error message when state is UserError', (
      WidgetTester tester,
    ) async {
      const errorState = UserError('Failed to load user');

      await pumpPage(tester, errorState);

      expect(find.text('Error: Failed to load user'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should display default message when state is UserInitial', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, UserInitial());

      expect(find.text('Press a button to load user'), findsOneWidget);
    });

    testWidgets('should trigger LoadUserEvent when User 1 button is pressed', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, loadedState);

      await tester.tap(find.text('User 1'));
      await tester.pump();

      verify(mockUserBloc.add(const LoadUserEvent('1'))).called(1);
    });

    testWidgets('should trigger LoadUserEvent when User 2 button is pressed', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, loadedState);

      await tester.tap(find.text('User 2'));
      await tester.pump();

      verify(mockUserBloc.add(const LoadUserEvent('2'))).called(1);
    });

    testWidgets('should trigger LoadUserEvent when User 3 button is pressed', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, loadedState);

      await tester.tap(find.text('User 3'));
      await tester.pump();

      verify(mockUserBloc.add(const LoadUserEvent('3'))).called(1);
    });

    testWidgets('should trigger LoadUserEvent when Retry button is pressed', (
      WidgetTester tester,
    ) async {
      const errorState = UserError('Failed to load user');

      await pumpPage(tester, errorState);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(mockUserBloc.add(const LoadUserEvent('1'))).called(1);
    });

    testWidgets('should have AppBar with correct title and color', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, UserInitial());

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
      expect((appBar.title as Text).data, equals('User Info'));
      expect(appBar.backgroundColor, equals(Colors.blue));
    });

    testWidgets('should display image or fallback icon in loaded state', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, loadedState);

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should render Card widget for user info in loaded state', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, loadedState);

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should display all three user buttons in loaded state', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, loadedState);

      expect(find.byType(ElevatedButton), findsNWidgets(3));
    });

    testWidgets('should display error icon in error state', (
      WidgetTester tester,
    ) async {
      const errorState = UserError('Network error');

      await pumpPage(tester, errorState);

      final iconFinder = find.byIcon(Icons.error_outline);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.color, equals(Colors.red));
      expect(icon.size, equals(60));
    });
  });
}
