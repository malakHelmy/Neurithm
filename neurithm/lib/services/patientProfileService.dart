import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  Future<void> updatePatientProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    await _firestore.collection('patients').doc(uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    });
  }

  Future<Map<String, dynamic>?> fetchPatientData(String uid) async {
    final doc = await _firestore.collection('patients').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}