import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_foundations/features/user/domain/entities/user.dart';

void main() {
  group('User', () {
    const tUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
    );

    test('should create a User instance with required properties', () {
      expect(tUser.id, equals('1'));
      expect(tUser.name, equals('John Doe'));
      expect(tUser.email, equals('john@example.com'));
    });

    test('should support equality comparison', () {
      const user1 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
      );
      const user2 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
      );

      expect(user1.id, equals(user2.id));
      expect(user1.name, equals(user2.name));
      expect(user1.email, equals(user2.email));
    });

    test('should differentiate between different users', () {
      const user1 = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
      );
      const user2 = User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
      );

      expect(user1.id, isNot(equals(user2.id)));
      expect(user1.name, isNot(equals(user2.name)));
      expect(user1.email, isNot(equals(user2.email)));
    });

    test('should be a const constructor', () {
      const user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
      );

      expect(user, isA<User>());
    });
  });
}