import 'package:flutter/material.dart';
import '../widgets/wavesBackground.dart';
import '../widgets/appbar.dart';

class ViewUserFeedbackPage extends StatefulWidget {
  const ViewUserFeedbackPage({Key? key}) : super(key: key);

  @override
  State<ViewUserFeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<ViewUserFeedbackPage> {
  final List<Map<String, dynamic>> _feedbacks = List.generate(
    10,
    (index) => {
      'userName': 'User ${index + 1}',
      'date': DateTime.now().subtract(Duration(days: index)),
      'rating': 4 + (index % 2),
      'comment': 'This is a great app! Very helpful and user-friendly interface. Would recommend to others.',
      'isResolved': false,
    },
  );

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
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                      color: Color.fromARGB(255, 206, 206, 206),
                    ),
                    onPressed: () {
                      // filter functionality lw hnaamelo
                    },
                  ),
                ],
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
                          Icons.feedback,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'User Feedback',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildStatistics(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _feedbacks.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) => _buildFeedbackCard(_feedbacks[index]),
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

  Widget _buildStatistics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', '156', Icons.message),
          _verticalDivider(),
          _buildStatItem('Pending', '23', Icons.pending),
          _verticalDivider(),
          _buildStatItem('Resolved', '133', Icons.check_circle),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 62, 99, 135),
                  child: Text(
                    feedback['userName'].substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback['userName'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        feedback['date'].toString().substring(0, 10),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: feedback['isResolved']
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    feedback['isResolved'] ? 'Resolved' : 'Pending',
                    style: TextStyle(
                      color: feedback['isResolved']
                          ? Colors.green.shade300
                          : Colors.orange.shade300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 20,
                  color: index < feedback['rating']
                      ? Colors.amber
                      : Colors.white.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              feedback['comment'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Implement reply functionality
                  },
                  icon: const Icon(
                    Icons.reply,
                    color: Colors.white70,
                    size: 20,
                  ),
                  label: const Text(
                    'Reply',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      feedback['isResolved'] = !feedback['isResolved'];
                    });
                  },
                  icon: Icon(
                    feedback['isResolved']
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: Colors.white70,
                    size: 20,
                  ),
                  label: const Text(
                    'Mark as Resolved',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}