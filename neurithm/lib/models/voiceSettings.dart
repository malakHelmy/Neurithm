class VoiceSettings {
  double pitch;
  String gender;
  String language;
  String voiceName;

  VoiceSettings({
    required this.pitch,
    required this.gender,
    required this.language,
    required this.voiceName,
  });

  Map<String, dynamic> toJson() {
    return {
      'pitch': pitch,
      'gender': gender,
      'language': language,
      'voice name': voiceName,
    };
  }
}