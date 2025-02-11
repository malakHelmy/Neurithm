import 'users.dart'; // Import the abstract class

class Patient extends Users {
  final String firstName;
  final String lastName;

  Patient({
    required String uid,
    required String email,
    required String password,
    required this.firstName,
    required this.lastName,
  }) : super(uid: uid, email: email, password: password);

  @override
  void login() {
    // Implementation of the login method specific to Patient
    print('$firstName $lastName is logging in...');
  }

  @override
  void logout() {
    print('$firstName $lastName is logging out...');
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

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      uid: map['uid'],
      email: map['email'],
      password: map['password'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }
}