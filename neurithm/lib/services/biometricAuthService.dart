import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart  ';
import 'package:flutter/material.dart';
import 'package:neurithm/models/userPreferences.dart';

class Biometricauth {
  final auth = LocalAuthentication();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkBiometric(String email, String password) async {

    bool canCheckBiometric = await auth.canCheckBiometrics;

    if (canCheckBiometric) {
      List<BiometricType> availableBiometric =
          await auth.getAvailableBiometrics();

      if (availableBiometric.isNotEmpty) {
        bool authenticated = await auth.authenticate(
          localizedReason: "Scan your finger to authenticate",
        );
        UserPreferences.saveBiometricAuth(email, password);
      }
    }
  }
}
