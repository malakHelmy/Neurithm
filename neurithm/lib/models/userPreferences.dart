import 'package:neurithm/models/voiceSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserPreferences {
  static const String _pitchKey = 'pitch';
  static const String _genderKey = 'gender';
  static const String _languageKey = 'language';
  static const String _voiceNameKey = 'voice';

  static Future<void> saveVoiceSettings({
    required double pitch,
    required String gender,
    required String language,
    required String voiceName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_pitchKey, pitch);
    await prefs.setString(_genderKey, gender);
    await prefs.setString(_languageKey, language);
    await prefs.setString(_voiceNameKey, voiceName);
  }

  static Future<VoiceSettings> loadVoiceSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return VoiceSettings(
      pitch: prefs.getDouble(_pitchKey) ?? 1.0,
      gender: prefs.getString(_genderKey) ?? 'male',
      language: prefs.getString(_languageKey) ?? 'en-US', 
      voiceName: prefs.getString(_voiceNameKey) ?? 'Puck',
    );
  }

}