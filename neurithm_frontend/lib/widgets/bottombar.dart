import 'package:flutter/material.dart';


BottomNavigationBar bottomappBar() {
  return BottomNavigationBar(
    backgroundColor: Color.fromARGB(
        255, 70, 100, 166), // Matching color with dark blue gradient
    selectedItemColor:
        Color.fromARGB(255, 255, 255, 255), // Light blue for selected icon
    unselectedItemColor:
        Color.fromARGB(255, 168, 167, 167), // Gray for unselected icons
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.devices),
        label: 'Devices',
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
