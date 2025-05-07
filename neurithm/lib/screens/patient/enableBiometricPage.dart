import 'package:flutter/material.dart';
import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/screens/patient/settingsPage.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';
import 'package:neurithm/services/biometricAuthService.dart';  // Import your biometric authentication service

class EnablebiometricPage extends StatelessWidget {
  final String email;
  final String password;

  const EnablebiometricPage(this.email, this.password, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    var selectedLocale = Localizations.localeOf(context).toString();

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            wavesBackground(getScreenWidth(context), getScreenHeight(context)),
            
            Padding(
              padding: EdgeInsets.all(spacing(25, getScreenHeight(context))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.fingerprint,
                          color: Color.fromARGB(255, 206, 206, 206), size: 100,),
                      onPressed: () {
                        // Call the method to check biometric authentication (fingerprint)
                        _authenticateWithBiometrics(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Enable Biometric authentication to log in with ease",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Skip the biometric authentication process
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(showRatingPopup: false,),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            fontSize: 20, color: Color(0xFF1A2A3A)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This method handles the biometric authentication process
  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    // Create an instance of your BiometricAuth service
    Biometricauth biometricAuth = Biometricauth();
    
    // Call the checkBiometric method from the service
    await biometricAuth.checkBiometric(this.email, this.password);

    // After successful authentication, navigate to the settings or home page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(showRatingPopup: false,), // Or any other page after authentication
      ),
    );
  }
}
