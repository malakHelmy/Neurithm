import 'package:flutter/material.dart';
import 'package:neurithm_frontend/screens/userProfile.dart';
import '../screens/homePage.dart';
import '../screens/wordBank.dart';
import '../screens/feedback.dart';
import '../screens/help.dart';
import '../screens/aboutUs.dart';

Drawer sideAppBar(context) {
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
      children: <Widget>[
        ListTile(
          title: const Text('Home',
              style: TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
          },
        ),
        ListTile(
          title: const Text('About',
              style: TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ));
          },
        ),
        // ListTile(
        //     title: const Text('Contact',
        //         style: TextStyle(
        //           color: Color.fromARGB(255, 206, 206, 206),
        //           fontSize: 25,
        //           fontFamily: 'Lato',
        //           fontWeight: FontWeight.bold,
        //         )),
        //     onTap: () {
        //       Navigator.pop(context);
        //     }),
        ListTile(
          title: const Text('Help and Support',
              style: TextStyle(
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
                ));
          },
        ),
        ListTile(
          title: const Text('Account Info',
              style: TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => userProfilePage(),
                ));
          },
        ),
        ListTile(
          title: const Text('Word Bank',
              style: TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => wordBankPage(),
                ));
          },
        ),
      ],
    ),
  );
}

AppBar Appbar(GlobalKey<ScaffoldState> scaffoldKey) {
  return AppBar(
    backgroundColor: Colors.transparent, elevation: 0.0,
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
    centerTitle: true, // Centers the title in the app bar
    actions: [
      IconButton(
        icon: const Icon(
          Icons.signal_wifi_statusbar_4_bar_rounded,
          color: Color.fromARGB(255, 130, 197, 116),
          size: 25,
        ),
        onPressed: () {
          // Add functionality here
        },
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

//get screen width and height (for better responsiveness)
getScreenWidth(context) {
  return MediaQuery.of(context).size.width;
}

getScreenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double fontSize(double size, screenWidth) => size * screenWidth / 400;
double spacing(double size, screenHeight) => size * screenHeight / 800;
