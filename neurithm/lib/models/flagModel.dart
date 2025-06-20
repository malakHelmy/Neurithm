class FlagModel {
  final String sessionId;
  final String modelName;
  final String? correctText;  

  FlagModel({
    required this.sessionId,
    required this.modelName,
    this.correctText,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'modelName': modelName,
      if (correctText != null) 'correctText': correctText,
    };
  }

  factory FlagModel.fromMap(Map<String, dynamic> map) {
    return FlagModel(
      sessionId: map['sessionId'],
      modelName: map['modelName'],
      correctText: map['correctText'], 
    );
  }
}
