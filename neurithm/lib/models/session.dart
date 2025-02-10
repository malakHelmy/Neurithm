
class Session {
  String id;
  String patientId;
  DateTime startTime;
  DateTime endTime;

  Session({required this.id, required this.patientId, required this.startTime, required this.endTime});

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map, String id) {
    return Session(
      id: id,
      patientId: map['patientId'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
    );
  }
}