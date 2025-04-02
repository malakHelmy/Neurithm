import 'package:neurithm/models/voiceSettings.dart';
import 'package:neurithm/models/userPreferences.dart';

class VoiceSettingService {
  List<String> maleVoices = ["Orus","Charon", "Leda", "Fenrir", "Puck"];
  List<String> femaleVoices = ["Aoede", "Kore", "Leda", "Zephyr"];

  String getFullVoiceId(String languageCode, String selectedVoice) {
    return "$languageCode-Chirp3-HD-$selectedVoice";
  }
}
