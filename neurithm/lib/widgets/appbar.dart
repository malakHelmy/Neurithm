import 'package:flutter/material.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';
import 'package:neurithm/screens/patient/aboutUsPage.dart';
import 'package:neurithm/screens/patient/accountSettingsPage.dart';
import 'package:neurithm/screens/patient/helpPage.dart';
import 'package:neurithm/screens/homepage.dart';
import 'package:neurithm/screens/introPage.dart';
import 'package:neurithm/screens/patient/wordBankPage.dart';
import 'package:neurithm/services/authService.dart';

bool isConnected = false;

Drawer sideAppBar(BuildContext context) {
  final AuthService _authService = AuthService();
  final t = AppLocalizations.of(context)!;
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
      children: <Widget>[
        ListTile(
          title: Text(t.home,
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(showRatingPopup: false),
              ),
            );
          },
        ),
        ListTile(
          title: Text(t.about,
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutUsPage(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(t.helpAndSupport,
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpPage(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(t.accountInfo,
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountSettingsPage(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(t.wordBank,
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordBankPage(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(t.logOut,
              style: const TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            _authService.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IntroPage(),
              ),
            );
          },
        ),
      ],
    ),
  );
}AppBar Appbar(GlobalKey<ScaffoldState> scaffoldKey) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    leading: IconButton(
      icon: const Icon(
        Icons.menu,
        color: Color.fromARGB(255, 206, 206, 206),
      ),
      onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
    ),
    title: const Text(
      "Neurithm",
      style: TextStyle(
        color: Color.fromARGB(255, 206, 206, 206),
        fontSize: 25,
        fontWeight: FontWeight.normal,
        fontFamily: 'Vonique',
      ),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(
          Icons.signal_wifi_statusbar_4_bar_rounded,
          color: isConnected
              ? const Color.fromARGB(255, 130, 197, 116) // Green if connected
              : const Color.fromARGB(255, 244, 67, 54), // Red if not connected
          size: 25,
        ),
        onPressed: () {},
      ),
    ],
  );
}

Row loginPageAppBar(_scaffoldKey) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.menu, color: Color.fromARGB(255, 206, 206, 206)),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    ],
  );
}

Padding appBar(GlobalKey<ScaffoldState> scaffoldKey) {
  return Padding(
    padding: EdgeInsets.only(top: 17),
    child: Appbar(scaffoldKey),
  );
}

getScreenWidth(context) {
  return MediaQuery.of(context).size.width;
}

getScreenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double fontSize(double size, screenWidth) => size * screenWidth / 400;
double spacing(double size, screenHeight) => size * screenHeight / 800;


