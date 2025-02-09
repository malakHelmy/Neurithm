import 'package:flutter/material.dart';
import '../widgets/wavesBackground.dart';
import '../widgets/appbar.dart';
import '../screens/viewAppRatings.dart';
import '../screens/viewPatients.dart';
import '../screens/adminSettings.dart';
import '../services/adminProfileMethods.dart';

// admin_settings.dart
class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({Key? key}) : super(key: key);

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AdminProfileMethods _adminProfileMethods = AdminProfileMethods();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminProfile();
  }

  Future<void> _loadAdminProfile() async {
    setState(() => isLoading = true);
    try {
      final admin = await _adminProfileMethods.getAdminProfile();
      if (admin != null) {
        nameController.text = admin.firstName;
        lastNameController.text = admin.lastName;
        emailController.text = admin.email;
      }
    } catch (e) {
      _showErrorSnackBar('Error loading profile');
    }
    setState(() => isLoading = false);
  }

  Future<void> _saveChanges() async {
    setState(() => isLoading = true);

    final result = await _adminProfileMethods.updateAdminProfile(
      firstName: nameController.text,
      lastName: lastNameController.text,
      newEmail: emailController.text,
      newPassword:
          passwordController.text.isNotEmpty ? passwordController.text : null,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) {
      passwordController.clear();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

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
                        'Admin Settings',
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
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _settingsField(
                          Icons.person,
                          'First Name',
                          controller: nameController,
                        ),_settingsField(
                          Icons.person,
                          'Last Name',
                          controller: lastNameController,
                        ),
                        _settingsField(
                          Icons.email,
                          'Email',
                          controller: emailController,
                        ),
                        _settingsField(
                          Icons.lock,
                          'Password',
                          controller: passwordController,
                          obscureText: true,
                        ),
                        _settingsField(
                          Icons.notifications,
                          'Notifications',
                          isSwitch: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      // save settings
                      onPressed: isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF1A2A3A))
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                color: Color(0xFF1A2A3A),
                                fontSize: 18,
                              ),
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

  Widget _settingsField(
    IconData icon,
    String label, {
    TextEditingController? controller,
    bool obscureText = false,
    bool isSwitch = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: isSwitch
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: Colors.white,
                      ),
                    ],
                  )
                : TextField(
                    controller: controller,
                    obscureText: obscureText,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
