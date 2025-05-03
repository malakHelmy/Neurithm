import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/prediction.dart';
import 'package:neurithm/models/aiModel.dart';

class ConversationHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> fetchConversationHistory(String userId) async {
    List<Map<String, String>> conversationHistory = [];

    try {
      print("Starting to fetch session data for user: $userId"); // Debugging print
      var sessionSnapshot = await _firestore
          .collection('session')
          .where('patientId', isEqualTo: userId)
          .get();

      print("Session Snapshot fetched: ${sessionSnapshot.docs.length} records found"); // Debugging print

      for (var sessionDoc in sessionSnapshot.docs) {
        String sessionId = sessionDoc.id;
        var startTimeData = sessionDoc['startTime'];
        var endTimeData = sessionDoc['endTime'];

        // Parse startTime and endTime if they are Strings
        DateTime? startTime;
        DateTime? endTime;

        if (startTimeData is String) {
          startTime = DateTime.parse(startTimeData); // Parse string into DateTime
          print("Parsed startTime: $startTime"); // Debugging print
        } else if (startTimeData is Timestamp) {
          startTime = startTimeData.toDate(); // Convert Firestore Timestamp to DateTime
          print("Parsed startTime from Timestamp: $startTime"); // Debugging print
        }

        if (endTimeData != null) {
          if (endTimeData is String) {
            endTime = DateTime.parse(endTimeData); // Parse string into DateTime
            print("Parsed endTime: $endTime"); // Debugging print
          } else if (endTimeData is Timestamp) {
            endTime = endTimeData.toDate(); // Convert Firestore Timestamp to DateTime
            print("Parsed endTime from Timestamp: $endTime"); // Debugging print
          }
        } else {
          print("endTime is null"); // Debugging print
        }

        var predictionSnapshot = await _firestore
            .collection('predictions')
            .where('sessionId', isEqualTo: sessionId)
            .where('isAccepted', isEqualTo: true)
            .get();

        print("Prediction Snapshot fetched: ${predictionSnapshot.docs.length} records found"); // Debugging print

        for (var predictionDoc in predictionSnapshot.docs) {

          // Add conversation history
          conversationHistory.add({
            'date': '${startTime.toString()} - ${endTime != null ? endTime.toString() : "N/A"}',  // Display endTime if available
            'content': '${predictionDoc['predictedText']}',
          });
        }
      }
    } catch (e) {
      print("Error fetching conversation history: $e");
    }

    print("Total conversation history fetched: ${conversationHistory.length}"); // Debugging print
    return conversationHistory;
  }
}
