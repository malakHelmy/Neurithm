import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: sideAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 79, 114, 190), // stat color (lighter blue)
                Color(0xFF1A2A3A), // end color (dark blue)
              ],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 55.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drawer Navbar
                    navBar(_scaffoldKey),
                    const SizedBox(height: 60),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome,",
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          Text("Potenial User",
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            SizedBox(width: 100),
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/brainsignals.png'),
                                      fit: BoxFit
                                          .cover, // You can adjust the fit to your needs
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    // Intro
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Voice Your Mind",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Transform your thoughts into speech effortlessly.",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white60),
                          ),
                          const SizedBox(height: 30),

                          //start speaking button
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 240, 240),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Start Speaking Now",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A2A3A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "History",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 206, 206, 206),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 206, 206, 206)),
                          onPressed: () {},
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.12),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.12),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.12),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                height: 100,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black.withOpacity(0.12),
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(1.0), // Adds spacing around the navbar
        child: ClipRRect(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust for rounded corners
            child: bottomNavbar()),
      ),
    );
  }
}

Row navBar(_scaffoldKey) {
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
      // SizedBox(width: 20,) lw ayza title centered
    ],
  );
}

Drawer sideAppBar(context) {
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
      
      children: <Widget>[
        ListTile(
          title: const Text('About'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Contact'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Pricing'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Sign In'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

BottomNavigationBar bottomNavbar() {
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
