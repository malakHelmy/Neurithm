import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/AIModel.dart';

class AIModelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createDummyAIModel() async {
    final aiModel = AIModel(
      id: '',
      modelType: 'BiLSTM',
      firebaseUrl: 'https://firebasestorage.googleapis.com/v0/b/example-app.appspot.com/o/model%2Fbi_lstm_model.tflite?alt=media',
    );

    final docRef = await _firestore.collection('ai_models').add(aiModel.toMap());

    return docRef.id;
  }
}