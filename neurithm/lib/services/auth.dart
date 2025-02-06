import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle() async {
  bool result = false;
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    // Make sure we sign out from any active session first
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut(); // Ensure we sign out before a fresh sign-in
    }

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // User canceled the sign-in
      return false;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Add the data to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': user.displayName,
          'uid': user.uid,
          'profilePhoto': user.photoURL,
          'email': user.email,
        });
      }
      result = true;
    }
    return result;
  } catch (e) {
    print("Error during Google Sign-In: $e");
    return result;
  }
}


  Future<void> signOut() async {
    try {
      await _auth.signOut(); // Sign out from Firebase Auth

      // Check if the user is already signed in with Google before calling disconnect
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut(); // Properly sign out from Google
      }
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }
}
