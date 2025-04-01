import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static Future<bool> authenticateWithFaceID(BuildContext context) async {
    try {
      List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();

      if (!availableBiometrics.contains(BiometricType.face)) {
        _showErrorMessage(context, "Face ID is not available on this device.");
        return false;
      }

      bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate using Face ID',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!isAuthenticated) {
        _showErrorMessage(context, "Face ID authentication failed.");
      }

      return isAuthenticated;
    } catch (e) {
      _showErrorMessage(context, "Error: Face ID authentication failed.");
      return false;
    }
  }

  static void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
