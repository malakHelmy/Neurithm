import 'package:cloud_firestore/cloud_firestore.dart';

class AIModelsService {
  // This function is called to add AI models to Firestore
  Future<void> addAIModelsToFirestore() async {
    try {
      final modelsRef = FirebaseFirestore.instance.collection('ai_models');

      await modelsRef.add({
        'modelType': 'EEGNet',
      });

      await modelsRef.add({
        'modelType': 'EEG Transformer',
      });

      print("Models added successfully!");
    } catch (e) {
      print("Error adding models to Firestore: $e");
    }
  }
}
