import 'package:neurithm/models/voiceSettings.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserPreferences {
  static const String _pitchKey = 'pitch';
  static const String _genderKey = 'gender';
  static const String _languageKey = 'language';
  static const String _voiceNameKey = 'voice';

  static Future<void> saveVoiceSettings( VoiceSettings voiceSettings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_pitchKey, voiceSettings.pitch);
    await prefs.setString(_genderKey, voiceSettings.gender);
    await prefs.setString(_languageKey, voiceSettings.language);
    await prefs.setString(_voiceNameKey, voiceSettings.voiceName);
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