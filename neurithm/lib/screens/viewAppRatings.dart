import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class ViewAppRatingsDashboard extends StatefulWidget {
  const ViewAppRatingsDashboard({super.key});

  @override
  State<ViewAppRatingsDashboard> createState() => _AppRatingsDashboardState();
}

class _AppRatingsDashboardState extends State<ViewAppRatingsDashboard> {
  double averageRating = 0;
  int totalReviews = 0;
  int last30Days = 0;
  List<Map<String, dynamic>> recentRatings = [];

  @override
  void initState() {
    super.initState();
    _fetchAppRatings();
  }

Future<void> _fetchAppRatings() async {
  var ratingsQuery = await FirebaseFirestore.instance.collection('ratings').orderBy('submittedAt', descending: true).get();
  var patientQuery = await FirebaseFirestore.instance.collection('patients').get();

  Map<String, Map<String, dynamic>> patientLatestRatings = {};
  DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));

  int totalRating = 0;
  Set<String> uniquePatients = Set();
  Set<String> patientsInLast30Days = Set();
  int ratingsInLast30Days = 0;

  for (var doc in ratingsQuery.docs) {
    var ratingData = doc.data();
    String patientId = ratingData['patientId'];
    int rating = ratingData['rating'];
    var submittedAt = ratingData['submittedAt'];

    DateTime submittedDate;
    if (submittedAt is Timestamp) {
      submittedDate = submittedAt.toDate(); 
    } else if (submittedAt is String) {
      submittedDate = DateTime.parse(submittedAt); 
    } else {
      continue; 
    }

    // Only keep the latest rating for each patient
    if (!patientLatestRatings.containsKey(patientId) ||
        patientLatestRatings[patientId]!['submittedAt'].isBefore(submittedDate)) {
      patientLatestRatings[patientId] = {
        'rating': rating,
        'submittedAt': submittedDate,
      };
    }

    if (!uniquePatients.contains(patientId)) {
      uniquePatients.add(patientId);
      totalReviews++;
    }

    if (submittedDate.isAfter(thirtyDaysAgo) && !patientsInLast30Days.contains(patientId)) {
      patientsInLast30Days.add(patientId);
      ratingsInLast30Days++;
    }

    totalRating += rating as int;
  }

  double totalLatestRating = 0;
  for (var patientId in patientLatestRatings.keys) {
    totalLatestRating += patientLatestRatings[patientId]!['rating'];
  }
  averageRating = totalLatestRating / uniquePatients.length;

  List<Map<String, dynamic>> ratingsList = [];
  for (var patientId in patientLatestRatings.keys) {
    var patient = patientQuery.docs.firstWhere((doc) => doc.id == patientId);
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

  setState(() {
    recentRatings = ratingsList;
    totalReviews = uniquePatients.length;
    last30Days = ratingsInLast30Days;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: sideAppBar(context),
      body: Container(
        decoration: gradientBackground,
        child: Stack(
          children: [
            wavesBackground(getScreenWidth(context), getScreenHeight(context)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing(15, getScreenHeight(context)),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromARGB(255, 206, 206, 206),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 85),
              child: Column(
                children: [
                  const Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color.fromARGB(255, 62, 99, 135),
                        child: Icon(
                          Icons.star,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'App Ratings',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(averageRating.toStringAsFixed(1), 'Average Rating'),
                        _buildStatCard('$totalReviews', 'Total Reviews'),
                        _buildStatCard('$last30Days', 'Last 30 Days'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: recentRatings.length,
                        itemBuilder: (context, index) {
                          final rating = recentRatings[index];
                          return _buildRatingItem(rating);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 62, 99, 135).withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 206, 206, 206),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingItem(Map<String, dynamic> rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rating['userName'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 18,
                    color: index < rating['rating']
                        ? Colors.amber
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            rating['date'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 206, 206, 206),
            thickness: 0.75,
          ),
        ],
      ),
    );
  }
}
