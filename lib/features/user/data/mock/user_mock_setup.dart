import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'user_mock_responses.dart';

class UserMockSetup {
  static Future<void> configureMockAdapter(DioAdapter dioAdapter) async {
    final users = await UserMockResponses.loadUserList();

    dioAdapter.onGet('/users', (server) async {
      return server.reply(200, users, delay: const Duration(milliseconds: 300));
    });

    for (final userId in ['1', '2', '3']) {
      dioAdapter.onGet('/users/$userId', (server) async {
        final userData = UserMockResponses.getUserById(users, userId);
        return server.reply(
          200,
          userData,
          delay: const Duration(milliseconds: 300),
        );
      });
    }

    dioAdapter.onGet(
      '/users/404',
      (server) => server.reply(404, {
        'error': 'User not found',
        'message': 'The requested user does not exist',
      }, delay: const Duration(milliseconds: 200)),
    );
  }
}
