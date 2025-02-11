class Prediction {
  String id;
  String sessionId;
  String eegDataId;
  String aiModelId;
  String predictedText;
  bool isAccepted;
  String status;

  Prediction({
    required this.id,
    required this.sessionId,
    required this.eegDataId,
    required this.aiModelId,
    required this.predictedText,
    required this.isAccepted,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'eegDataId': eegDataId,
      'aiModelId': aiModelId,
      'predictedText': predictedText,
      'isAccepted': isAccepted,
      'status': status,
    };
  }

  factory Prediction.fromMap(Map<String, dynamic> map, String id) {
    return Prediction(
      id: id,
      sessionId: map['sessionId'],
      eegDataId: map['eegDataId'],
      aiModelId: map['aiModelId'],
      predictedText: map['predictedText'],
      isAccepted: map['isAccepted'],
      status: map['status'],
    );
  }
}