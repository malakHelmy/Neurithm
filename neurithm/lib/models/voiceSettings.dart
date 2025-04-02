class VoiceSettings {
  double pitch;
  String gender;
  String accent;

  VoiceSettings({
    required this.pitch,
    required this.gender,
    required this.accent,
  });

  Map<String, dynamic> toJson() {
    return {
      'pitch': pitch,
      'gender': gender,
      'language': accent,
    };
  }
}