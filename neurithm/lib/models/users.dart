abstract class Users {
  final String uid;
  final String email;
  final String password;

  Users({
    required this.uid,
    required this.email,
    required this.password,
  });

  void login();
  void logout();

  Map<String, dynamic> toMap();
}
