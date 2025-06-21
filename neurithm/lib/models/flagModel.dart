class FlagModel {
  final String sessionId;
  final String modelId;
  final String? correctText;

  FlagModel({
    required this.sessionId,
    required this.modelId,
    this.correctText,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'modelId': modelId,
      if (correctText != null) 'correctText': correctText,
    };
  }

  factory FlagModel.fromMap(Map<String, dynamic> map) {
    return FlagModel(
      sessionId: map['sessionId'],
      modelId: map['modelId'],
      correctText: map['correctText'],
    );
  }
}
