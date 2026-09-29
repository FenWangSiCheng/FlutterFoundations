import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_foundations/features/user/data/mock/user_mock_responses.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserMockResponses', () {
    test('loadUserList returns bundled users when asset exists', () async {
      final users = await UserMockResponses.loadUserList();
      expect(users, isA<List<Map<String, dynamic>>>());
      expect(users, isNotEmpty);
      expect(users.first.keys, containsAll(['id', 'name', 'email']));
    });

    test('getUserById returns null for unknown user', () async {
      final users = await UserMockResponses.loadUserList();
      final user = UserMockResponses.getUserById(users, 'nonexistent-id');
      expect(user, isNull);
    });
  });
}
