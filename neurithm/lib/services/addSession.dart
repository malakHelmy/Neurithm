import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/models/session.dart';

class SessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createDummySession() async {
    final session = Session(
      id: '',
      patientId: 'QQOoVanQBvgldPJgMSPHowTcI7p2',
      startTime: DateTime.now().subtract(Duration(hours: 1)),
      endTime: DateTime.now(),
    );

    final docRef = await _firestore.collection('session').add(session.toMap());

    return docRef.id;
  }
}