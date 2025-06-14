import 'package:flutter/material.dart';
import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/screens/patient/conversationHistoryPage.dart';
import 'package:neurithm/screens/patient/settingsPage.dart';
import 'package:neurithm/screens/patient/wordBankPage.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';

BottomNavigationBar BottomBar(BuildContext context, int currentIndex) {
  void _onItemTapped(int index) {
    if (index >= 0 && index <= 3) {
      // Valid index cases
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(showRatingPopup: false)),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WordBankPage()),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConversationHistoryPage()),
          );
          break;
      }
    }
  }

  return BottomNavigationBar(
    backgroundColor: Color(0xFF1A2A3A),
    selectedItemColor: Color.fromARGB(255, 255, 255, 255),
    unselectedItemColor: Color.fromARGB(255, 168, 167, 167),
    currentIndex: currentIndex,
    onTap: _onItemTapped,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: AppLocalizations.of(context)!.home,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.saved_search),
        label: AppLocalizations.of(context)!.wordBank,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: AppLocalizations.of(context)!.settings,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: AppLocalizations.of(context)!.history,
      ),
    ],
    type: BottomNavigationBarType.fixed,
  );
}
