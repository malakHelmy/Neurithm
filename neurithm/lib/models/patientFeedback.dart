class PatientFeedback {
  final String id;
  final String patientId;
  final String feedbackId;
  final DateTime submittedAt;
  final bool isResolved;

  PatientFeedback({
    required this.id,
    required this.patientId,
    required this.feedbackId,
    required this.submittedAt, 
    required this.isResolved,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'feedbackId': feedbackId,
      'submittedAt': submittedAt.toIso8601String(), 
      'isResolved' : isResolved
    };
  }

  factory PatientFeedback.fromMap(Map<String, dynamic> map, String documentId) {
    return PatientFeedback(
      id: documentId,
      patientId: map['patientId'],
      feedbackId: map['feedbackId'],
      submittedAt: DateTime.parse(map['submittedAt']), 
      isResolved: map['isResolved']
    );
  }
}
