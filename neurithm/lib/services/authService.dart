import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/models/admin.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check admin collection first
        DocumentSnapshot adminDoc =
            await _firestore.collection('admins').doc(user.uid).get();

        if (adminDoc.exists) {
          return Admin(
            uid: user.uid,
            firstName: adminDoc['firstName'] ?? '',
            lastName: adminDoc['lastName'] ?? '',
            email: user.email ?? '',
            password: '',
          );
        }

        // If not admin, check patient collection
        DocumentSnapshot patientDoc =
            await _firestore.collection('patients').doc(user.uid).get();

        if (patientDoc.exists) {
          return Patient(
            uid: user.uid,
            firstName: patientDoc['firstName'] ?? '',
            lastName: patientDoc['lastName'] ?? '',
            email: user.email ?? '',
            password: '',
          );
        }
      }
    } catch (e) {
      print("Error fetching current user: $e");
    }
    return null;
  }

  // Sign-Up with Email and Password
  Future<bool> signUpWithEmailPassword(
      String firstName, String lastName, String email, String password) async {
    bool result = false;
    try {
      // Create the user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Store user data in Firestore
        await _firestore.collection('patients').doc(user.uid).set({
          'uid': user.uid,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': ''
        });

        result = true;
      }
    } catch (e) {
      print("Error during sign-up: $e");
    }
    return result;
  }

  Future<Map<String, dynamic>> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Check if user is admin
        DocumentSnapshot adminDoc =
            await _firestore.collection('admins').doc(user.uid).get();

        if (adminDoc.exists) {
          return {
            'success': true,
            'isAdmin': true,
            'user': Admin(
              uid: user.uid,
              firstName: adminDoc['firstName'] ?? '',
              lastName: adminDoc['lastName'] ?? '',
              email: user.email ?? '',
              password: '',
            )
          };
        }

        // Check if user is patient
        DocumentSnapshot patientDoc =
            await _firestore.collection('patients').doc(user.uid).get();

        if (patientDoc.exists) {
          return {
            'success': true,
            'isAdmin': false,
            'user': Patient(
              uid: user.uid,
              firstName: patientDoc['firstName'] ?? '',
              lastName: patientDoc['lastName'] ?? '',
              email: user.email ?? '',
              password: '',
            )
          };
        }
      }
    } catch (e) {
      print("Error during email sign-in: $e");
      return {'success': false, 'error': e.toString()};
    }
    return {'success': false, 'error': 'User not found'};
  }

  // Keep existing Google Sign-In method
  Future<bool> signInWithGoogle() async {
    bool result = false;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection('patients').doc(user.uid).set({
            'uid': user.uid,
            'firstName': user.displayName?.split(' ')[0] ?? '',
            'lastName': user.displayName!.split(' ').length > 1
                ? user.displayName!.split(' ')[1]
                : '',
            'email': user.email,
            'password': ''
          });
        }

        result = true;
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
    return result;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();

      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }
}
