
import 'package:flutter/material.dart';
import '../widgets/wavesBackground.dart';
import '../widgets/appbar.dart';
import '../screens/viewAppRatings.dart';
import '../screens/viewPatients.dart';
import '../screens/adminSettings.dart';
import '../screens/viewUserFeedback.dart';
import '../widgets/bottombar.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.symmetric(vertical: 85),
              child: Column(
                children: [
                  const Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color.fromARGB(255, 62, 99, 135),
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Admin Dashboard',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          _dashboardCard(
                            context,
                            'Account Settings',
                            Icons.settings,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminSettingsPage(),
                              ),
                            ),
                          ),
                          _dashboardCard(
                            context,
                            'View Patients',
                            Icons.people,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PatientsListPage(),
                              ),
                            ),
                          ),
                          _dashboardCard(
                            context,
                            'View Feedback',
                            Icons.feedback,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewUserFeedbackPage(),
                              ),
                            ),
                          ),
                          _dashboardCard(
                            context,
                            'App Ratings',
                            Icons.star,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewAppRatingsDashboard(),
                              ),
                            ),
                          ),
                        ],
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

  Widget _dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
