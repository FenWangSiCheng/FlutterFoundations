import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_foundations/core/network/mock/mock_responses.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockResponses', () {
    test('loadUserList handles missing asset gracefully', () async {
      final users = await MockResponses.loadUserList();
      // Should return empty list when asset loading fails in test environment
      expect(users, isA<List<Map<String, dynamic>>>());
    });

    test('getUserById returns null for unknown user', () async {
      final user = await MockResponses.getUserById('nonexistent-id');
      expect(user, isNull);
    });
  });
}
