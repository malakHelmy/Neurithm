class RatingModel {
  final String id;
  final String patientId;
  final int rating;

  RatingModel({required this.id, required this.patientId, required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'rating': rating,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RatingModel(
      id: documentId,
      patientId: map['patientId'],
      rating: map['rating'],
    );
  }
}
