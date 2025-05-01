import 'package:flutter/material.dart';

class LocaleModel extends ChangeNotifier {
  Locale _locale = Locale('en');  

  Locale get locale => _locale;

  // Method to update the locale
  void set(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();  
  }
}
