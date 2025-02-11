import 'package:cloud_firestore/cloud_firestore.dart';

class EEGData {
  String id;
  String sessionId;
  Map<String, dynamic> rawData;

  EEGData({
    required this.id,
    required this.sessionId,
    required this.rawData, 
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'rawData': rawData, 
    };
  }

  factory EEGData.fromMap(Map<String, dynamic> map, String id) {
    return EEGData(
      id: id,
      sessionId: map['sessionId'],
      rawData: Map<String, dynamic>.from(map['rawData']),
    );
  }
}