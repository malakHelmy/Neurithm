class FeedbackModel {
  final String id;
  final String category;
  final String comment;

  FeedbackModel({required this.id, required this.category, required this.comment});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'comment': comment,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FeedbackModel(
      id: documentId,
      category: map['category'],
      comment: map['comment'],
    );
  }
}
