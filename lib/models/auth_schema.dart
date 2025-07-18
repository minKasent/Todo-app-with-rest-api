class AuthSchema {
  final String username;
  final String password;

  AuthSchema({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
