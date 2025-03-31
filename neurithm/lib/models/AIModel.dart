class AIModel {
  final String id;
  final String modelType;
  final String firebaseUrl;

  AIModel({
    required this.id,
    required this.modelType,
    required this.firebaseUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'modelType': modelType,
      'firebaseUrl': firebaseUrl,
    };
  }

  factory AIModel.fromMap(Map<String, dynamic> map, String id) {
    return AIModel(
      id: id,
      modelType: map['modelType'],
      firebaseUrl: map['firebaseUrl'],
    );
  }
}
