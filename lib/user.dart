class User {
  final String backendToken;
  final String id;
  final String name;
  User(this.backendToken, this.id, this.name);

  static User? currentNullable;
  static User get current => currentNullable!;
}
