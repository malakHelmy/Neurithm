import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/prediction.dart';
import 'package:neurithm/models/aiModel.dart';

class ConversationHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> fetchConversationHistory(String userId) async {
  List<Map<String, String>> conversationHistory = [];

  try {
    // Fetch the sessions for the user
    var sessionSnapshot = await _firestore
        .collection('sessions')
        .where('patientId', isEqualTo: userId)
        .get();

    for (var sessionDoc in sessionSnapshot.docs) {
      String sessionId = sessionDoc.id;
      var startTimeData = sessionDoc['startTime'];
      var endTimeData = sessionDoc['endTime'];

      DateTime? startTime;
      DateTime? endTime;

      if (startTimeData is String) {
        startTime = DateTime.parse(startTimeData); 
      } else if (startTimeData is Timestamp) {
        startTime = startTimeData.toDate(); 
      }

      if (endTimeData != null) {
        if (endTimeData is String) {
          endTime = DateTime.parse(endTimeData); 
        } else if (endTimeData is Timestamp) {
          endTime = endTimeData.toDate(); 
        }
      }

      // Fetch predictions associated with the session
      var predictionSnapshot = await _firestore
          .collection('predictions')
          .where('sessionId', isEqualTo: sessionId)
          .where('isAccepted', isEqualTo: true)
          .get();

      // Handle predictions and map them to the expected structure
      for (var predictionDoc in predictionSnapshot.docs) {
        conversationHistory.add({
          'date': '${startTime.toString()} - ${endTime != null ? endTime.toString() : "N/A"}',
          'content': '${predictionDoc['predictedText']}',
          'sessionId': sessionId,
          'predictionId': predictionDoc.id, 
        });
      }
    }
  } catch (e) {
    print("Error fetching conversation history: $e");
  }

  print("Total conversation history fetched: ${conversationHistory.length}");
  return conversationHistory;
}

  Future<void> deletePrediction(String predictionId) async {
    try {
      await _firestore.collection('predictions').doc(predictionId).delete();
      print("Prediction deleted successfully.");
    } catch (e) {
      print("Error deleting prediction: $e");
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      // Delete all predictions related to this session
      var predictionSnapshot = await _firestore
          .collection('predictions')
          .where('sessionId', isEqualTo: sessionId)
          .get();

      for (var predictionDoc in predictionSnapshot.docs) {
        await predictionDoc.reference.delete();
      }

      // Now delete the session itself
      await _firestore.collection('sessions').doc(sessionId).delete();
      print("Session and all related predictions deleted successfully.");
    } catch (e) {
      print("Error deleting session: $e");
    }
  }
}

