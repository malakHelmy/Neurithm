import 'package:flutter/material.dart';
import '../screens/homePage.dart';
import '../screens/loginPage.dart';

Drawer sideAppBar(context) {
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
      children: <Widget>[
        ListTile(
          title: const Text('About',
              style: TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Contact',
              style: TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Pricing',
              style: TextStyle(
                color: Color.fromARGB(255, 206, 206, 206),
                fontSize: 25,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Sign In',
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
                  builder: (context) => LoginPage(),
                ));
          },
        ),
      ],
    ),
  );
}

Row appBar(_scaffoldKey) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: const Icon(Icons.menu, color: Color.fromARGB(255, 206, 206, 206)),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      const Text(
        "Neurithm",
        style: TextStyle(
          color: Color.fromARGB(255, 206, 206, 206),
          fontSize: 25,
          fontWeight: FontWeight.normal,
          fontFamily: 'Vonique',
        ),
      ),
      IconButton(
        icon: const Icon(
          Icons.signal_wifi_statusbar_4_bar_rounded,
          color: Color.fromARGB(255, 130, 197, 116),
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
