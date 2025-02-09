class RatingModel {
  final String id;
  final String patientId;
  final int rating;
  final DateTime submittedAt; 

  RatingModel({
    required this.id,
    required this.patientId,
    required this.rating,
    required this.submittedAt, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'rating': rating,
      'submittedAt': submittedAt.toIso8601String(), 
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RatingModel(
      id: documentId,
      patientId: map['patientId'],
      rating: map['rating'],
      submittedAt: DateTime.parse(map['submittedAt']), 
    );
  }
}
