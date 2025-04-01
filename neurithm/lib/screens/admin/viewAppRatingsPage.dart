import 'package:flutter/material.dart';
import 'package:neurithm/services/AppRatingsService.dart';
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class ViewAppRatingsPage extends StatefulWidget {
  const ViewAppRatingsPage({super.key});

  @override
  State<ViewAppRatingsPage> createState() => _AppRatingsPageState();
}

class _AppRatingsPageState extends State<ViewAppRatingsPage> {
  double averageRating = 0;
  int totalReviews = 0;
  int last30Days = 0;
  List<Map<String, dynamic>> recentRatings = [];
  final AppRatingsService _ratingService = AppRatingsService();

  @override
  void initState() {
    super.initState();
    _fetchAppRatings();
  }

  Future<void> _fetchAppRatings() async {
    final data = await _ratingService.fetchAppRatings();

    setState(() {
      averageRating = data['averageRating'];
      totalReviews = data['totalReviews'];
      last30Days = data['last30Days'];
      recentRatings = List<Map<String, dynamic>>.from(data['recentRatings']);
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
                        _buildStatCard(
                            averageRating.toStringAsFixed(1), 'Average Rating'),
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
