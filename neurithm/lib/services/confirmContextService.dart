import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/flagModel.dart';
import 'package:neurithm/models/prediction.dart';
import 'package:neurithm/services/authService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  }) async {
    try {
      var currentUser = await _authService.getCurrentUser();

      if (currentUser == null) {
        throw 'User not found. Please log in again.';
      }

      Prediction prediction = Prediction(
        id: '', // Firestore will auto-generate the ID
        sessionId: sessionId,
        aiModelId: aiModelId,
        predictedText: predictedText,
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

  Future<void> saveFlag(FlagModel flagModel) async {
    await FirebaseFirestore.instance
        .collection('flagModel')
        .add(flagModel.toMap());
  }

  Future<String> saveFlagAndReturnId(FlagModel flagModel) async {
    final docRef = await FirebaseFirestore.instance
        .collection('flagModel')
        .add(flagModel.toMap());
    return docRef.id;
  }

  Future<void> updateFlagCorrectText({
    required String documentId,
    required String correctText,
  }) async {
    await FirebaseFirestore.instance
        .collection('flagModel')
        .doc(documentId)
        .update({'correctText': correctText});
  }
}
