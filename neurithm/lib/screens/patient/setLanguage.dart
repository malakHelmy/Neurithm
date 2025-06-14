import 'package:flutter/material.dart';
import 'package:neurithm/screens/patient/settingsPage.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:provider/provider.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';
import 'package:neurithm/models/locale.dart';

class SetLanguageScreen extends StatelessWidget {
  const SetLanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          children: [
            wavesBackground(getScreenWidth(context), getScreenHeight(context)),
            Padding(
              padding: EdgeInsets.all(spacing(16, getScreenHeight(context))),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 206, 206, 206)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing(20, getScreenHeight(context))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.chooseLanguage,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Lato',
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: Consumer<LocaleModel>(
                        builder: (context, localeModel, child) =>
                            ElevatedButton(
                          onPressed: () {
                            // Update the language to English
                            localeModel.set(Locale('en'));

                            // Rebuild the context and show Snackbar with updated message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    t.languageUpdated), // Use localized message
                                duration: Duration(
                                    seconds: 2), // Duration for Snackbar
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 240, 240, 240),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            t.english, // Localized string for English
                            style: const TextStyle(
                              color: Color(0xFF1A2A3A),
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Consumer<LocaleModel>(
                        builder: (context, localeModel, child) =>
                            ElevatedButton(
                          onPressed: () {
                            // Update the language to Arabic
                            localeModel.set(Locale('ar'));

                            // Rebuild the context and show Snackbar with updated message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    t.languageUpdated), // Use localized message
                                duration: Duration(
                                    seconds: 2), // Duration for Snackbar
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 240, 240, 240),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            t.arabic, // Localized string for Arabic
                            style: const TextStyle(
                              color: Color(0xFF1A2A3A),
                              fontSize: 25,
                            ),
                          ),
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
}
