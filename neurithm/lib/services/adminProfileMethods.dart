import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/admin.dart';

class AdminProfileMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current admin profile data
  Future<Admin?> getAdminProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
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
      }
      return null;
    } catch (e) {
      print("Error fetching admin profile: $e");
      return null;
    }
  }

  // Update admin profile information
  Future<Map<String, dynamic>> updateAdminProfile({
    required String firstName,
    required String lastName,
    String? newEmail,
    String? newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return {
          'success': false,
          'message': 'No authenticated user found'
        };
      }

      // Update Firestore document
      Map<String, dynamic> updateData = {
        'firstName': firstName,
        'lastName': lastName,
      };

      await _firestore.collection('admins').doc(user.uid).update(updateData);

      // Update email if provided
      if (newEmail != null && newEmail.isNotEmpty && newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
        return {
          'success': true,
          'message': 'Profile updated. Please verify your new email address.'
        };
      }

      // Update password if provided
      if (newPassword != null && newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
        return {
          'success': true,
          'message': 'Profile and password updated successfully'
        };
      }

      return {
        'success': true,
        'message': 'Profile updated successfully'
      };

    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'requires-recent-login':
            return {
              'success': false,
              'message': 'Please log in again to update your security settings'
            };
          case 'weak-password':
            return {
              'success': false,
              'message': 'Password should be at least 6 characters'
            };
          case 'invalid-email':
            return {
              'success': false,
              'message': 'Invalid email address'
            };
          default:
            return {
              'success': false,
              'message': 'An error occurred: ${e.message}'
            };
        }
      }
      return {
        'success': false,
        'message': 'An unexpected error occurred'
      };
    }
  }
}