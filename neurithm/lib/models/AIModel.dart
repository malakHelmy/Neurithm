class AIModel {
  final String id;
  final String modelName;

  AIModel({
    required this.id,
    required this.modelName,
  });

  Map<String, dynamic> toMap() {
    return {
      'modelType': modelName,
    };
  }

  factory AIModel.fromMap(Map<String, dynamic> map, String id) {
    return AIModel(
      id: id,
      modelName: map['modelName'],
    );
  }
}
