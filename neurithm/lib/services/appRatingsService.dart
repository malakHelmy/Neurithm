import 'package:cloud_firestore/cloud_firestore.dart';

class AppRatingsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchAppRatings() async {
    var ratingsQuery =
        await _db.collection('ratings').get();
    var patientQuery =
        await _db.collection('patients').get();

    Map<String, Map<String, dynamic>> patientLatestRatings = {};
    DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    int totalRating = 0;
    Set<String> uniquePatients = {};
    Set<String> patientsInLast30Days = {};
    int ratingsInLast30Days = 0;

    for (var doc in ratingsQuery.docs) {
      var ratingData = doc.data();
      String patientId = ratingData['patientId'];
      double rating = ratingData['rating'];
      var submittedAt = ratingData['submittedAt'];

      DateTime submittedDate;
      if (submittedAt is Timestamp) {
        submittedDate = submittedAt.toDate();
      } else if (submittedAt is String) {
        submittedDate = DateTime.parse(submittedAt);
      } else {
        continue;
      }

      if (!patientLatestRatings.containsKey(patientId) ||
          patientLatestRatings[patientId]!['submittedAt']
              .isBefore(submittedDate)) {
        patientLatestRatings[patientId] = {
          'rating': rating,
          'submittedAt': submittedDate,
        };
      }

      if (!uniquePatients.contains(patientId)) {
        uniquePatients.add(patientId);
      }

      if (submittedDate.isAfter(thirtyDaysAgo) &&
          !patientsInLast30Days.contains(patientId)) {
        patientsInLast30Days.add(patientId);
        ratingsInLast30Days++;
      }

      totalRating += rating.toInt();
    }

    double totalLatestRating = 0;
    for (var patientId in patientLatestRatings.keys) {
      totalLatestRating += patientLatestRatings[patientId]!['rating'];
    }

    double averageRating =
        uniquePatients.isEmpty ? 0 : totalLatestRating / uniquePatients.length;

    List<Map<String, dynamic>> ratingsList = [];
    for (var patientId in patientLatestRatings.keys) {
      var patient =
          patientQuery.docs.firstWhere((doc) => doc.id == patientId);
      String firstName = patient['firstName'];
      String lastName = patient['lastName'];
      String fullName = '$firstName $lastName';
      var latestRating = patientLatestRatings[patientId];

      ratingsList.add({
        'userName': fullName,
        'rating': latestRating?['rating'],
        'date': latestRating?['submittedAt'].toString().substring(0, 10),
      });
    }

    return {
      'averageRating': averageRating,
      'totalReviews': uniquePatients.length,
      'last30Days': ratingsInLast30Days,
      'recentRatings': ratingsList,
    };
  }
}
