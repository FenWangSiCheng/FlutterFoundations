enum UserFailureType { notFound, unavailable }

class UserFailure implements Exception {
  const UserFailure(this.type);

  final UserFailureType type;
}
