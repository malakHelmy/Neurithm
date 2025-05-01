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
    var t = AppLocalizations.of(context)!;  // Get localized strings
    var selectedLocale = Localizations.localeOf(context).toString();  // Get current locale

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            wavesBackground(getScreenWidth(context), getScreenHeight(context)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing(15, getScreenHeight(context)),
              ),
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
            Center(
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
                  Consumer<LocaleModel>(
                    builder: (context, localeModel, child) => ElevatedButton(
                      onPressed: () {
                        // Update the language when "English" is selected
                        localeModel.set(Locale('en'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        t.english,  // Localized string for English
                        style: const TextStyle(
                          color: Color(0xFF1A2A3A),
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<LocaleModel>(
                    builder: (context, localeModel, child) => ElevatedButton(
                      onPressed: () {
                        // Update the language when "Arabic" is selected
                        localeModel.set(Locale('ar'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        t.arabic,  // Localized string for Arabic
                        style: const TextStyle(
                          color: Color(0xFF1A2A3A),
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  // Confirmation message after language selection
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      t.languageUpdated,  // Localized confirmation message
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
