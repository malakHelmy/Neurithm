import 'package:shared_preferences/shared_preferences.dart';
import '../screens/voicesettings.dart';

class UserPreferences {
  static const String _pitchKey = 'pitch';
  static const String _genderKey = 'gender';
  static const String _accentKey = 'accent';

  static Future<void> saveVoiceSettings({
    required double pitch,
    required String gender,
    required String accent,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_pitchKey, pitch);
    await prefs.setString(_genderKey, gender);
    await prefs.setString(_accentKey, accent);
  }

  static Future<VoiceSettings> loadVoiceSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return VoiceSettings(
      pitch: prefs.getDouble(_pitchKey) ?? 1.0,
      gender: prefs.getString(_genderKey) ?? 'male',
      accent: prefs.getString(_accentKey) ?? 'en', // Change this to "en"
    );
  }

}