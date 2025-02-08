class PatientFeedback {
  final String id;
  final String patientId;
  final String feedbackId;

  PatientFeedback({
    required this.id,
    required this.patientId,
    required this.feedbackId,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'feedbackId': feedbackId,
    };
  }

  // Create object from Firestore document
  factory PatientFeedback.fromMap(Map<String, dynamic> map, String documentId) {
    return PatientFeedback(
      id: documentId,
      patientId: map['patientId'],
      feedbackId: map['feedbackId'],
    );
  }
}
