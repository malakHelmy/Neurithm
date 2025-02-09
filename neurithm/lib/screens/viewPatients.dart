
import 'package:flutter/material.dart';
import '../widgets/wavesBackground.dart';
import '../widgets/appbar.dart';
import '../screens/viewAppRatings.dart';
import '../screens/viewPatients.dart';
import '../screens/adminSettings.dart';

class PatientsListPage extends StatelessWidget {
  const PatientsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: sideAppBar(context),
      body: Container(
        decoration: gradientBackground,
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
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 85),
              child: Column(
                children: [
                  const Text(
                    'Patient List',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search patients...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white.withOpacity(0.1),
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 62, 99, 135),
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(
                              'Patient ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Last visit: ${DateTime.now().toString().substring(0, 10)}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
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
