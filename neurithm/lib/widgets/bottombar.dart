import 'package:flutter/material.dart';
import 'package:neurithm/screens/history.dart';
import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/screens/settings.dart';
import 'package:neurithm/screens/wordBank.dart';

BottomNavigationBar bottomappBar(BuildContext context) {
  void _onItemTapped(int index) {
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
          MaterialPageRoute(builder: (context) => HistoryPage()),
        );
        break;
    }
  }

  return BottomNavigationBar(
    backgroundColor: Color(0xFF1A2A3A),
    selectedItemColor: Color.fromARGB(255, 255, 255, 255),
    unselectedItemColor: Color.fromARGB(255, 168, 167, 167),
    onTap: _onItemTapped, // Use the onItemTapped method here
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.saved_search),
        label: 'Word Bank',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.history),
        label: 'History',
      ),
    ],
    type: BottomNavigationBarType.fixed,
  );
}
