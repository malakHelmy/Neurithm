import 'package:cloud_firestore/cloud_firestore.dart';

class EEGData {
  String id;
  String sessionId;
  Map<String, dynamic> rawData; // Change from String to Map<String, dynamic>

  EEGData({
    required this.id,
    required this.sessionId,
    required this.rawData, // Now stored as a Map instead of a JSON string
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'rawData': rawData, // Store as Map directly
    };
  }

  factory EEGData.fromMap(Map<String, dynamic> map, String id) {
    return EEGData(
      id: id,
      sessionId: map['sessionId'],
      rawData: Map<String, dynamic>.from(map['rawData']), // Convert from Firestore JSON
    );
  }
}
