import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/prediction.dart';
import 'package:neurithm/services/authService.dart'; 

class ConfirmContextService {
  final AuthService _authService = AuthService();

  Future<String> getAiModelId(String modelName) async {
    try {
      var modelSnapshot = await FirebaseFirestore.instance
          .collection('ai_models')
          .where('modelType', isEqualTo: modelName)
          .limit(1)
          .get();

      if (modelSnapshot.docs.isEmpty) {
        throw 'Model not found in Firestore';
      }

      return modelSnapshot.docs.first.id;
    } catch (e) {
      print("Error fetching AI model ID: $e");
      throw e;
    }
  }

  Future<void> addPrediction({
    required String sessionId,
    required String aiModelId, 
    required String predictedText,
    required bool isAccepted,
  }) async {
    try {
      var currentUser = await _authService.getCurrentUser();

      if (currentUser == null) {
        throw 'User not found. Please log in again.';
      }

      Prediction prediction = Prediction(
        id: '',  // Firestore will auto-generate the ID
        sessionId: sessionId,
        aiModelId: aiModelId,
        predictedText: predictedText,
        isAccepted: isAccepted,
      );

      await FirebaseFirestore.instance
          .collection('predictions')
          .add(prediction.toMap());

      print("Prediction successfully saved to Firestore!");
    } catch (e) {
      print("Error saving prediction: $e");
      throw e;
    }
  }
}
