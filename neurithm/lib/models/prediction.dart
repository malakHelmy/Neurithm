class Prediction {
  String id;
  String sessionId;
  String aiModelId;
  String predictedText;

  Prediction({
    required this.id,
    required this.sessionId,
    required this.aiModelId,
    required this.predictedText,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'aiModelId': aiModelId,
      'predictedText': predictedText,
    };
  }

  factory Prediction.fromMap(Map<String, dynamic> map, String id) {
    return Prediction(
      id: id,
      sessionId: map['sessionId'],
      aiModelId: map['aiModelId'],
      predictedText: map['predictedText'],
    );
  }
}