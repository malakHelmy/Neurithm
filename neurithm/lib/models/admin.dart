import 'package:neurithm/models/users.dart';

class Admin extends Users {
  final String firstName;
  final String lastName;

  Admin({
    required String uid,
    required String email,
    required String password,
    required this.firstName,
    required this.lastName,
  }) : super(uid: uid, email: email, password: password);

  @override
  void login() {
    print('Admin logged in: $email');
  }

  @override
  void logout() {
    print('Admin logged out: $email');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      uid: map['uid'],
      email: map['email'],
      password: map['password'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }
}
