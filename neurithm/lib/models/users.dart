class Users {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Users({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  // Convert a User to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }

  // Convert a Map to a User
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      password: map['password'],
    );
  }
}
