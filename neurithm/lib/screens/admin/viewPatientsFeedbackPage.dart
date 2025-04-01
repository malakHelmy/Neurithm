import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurithm/widgets/appBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class ViewPatientsFeedbackPage extends StatefulWidget {
  const ViewPatientsFeedbackPage({Key? key}) : super(key: key);

  @override
  State<ViewPatientsFeedbackPage> createState() => _PatientsFeedbackPageState();
}

class _PatientsFeedbackPageState extends State<ViewPatientsFeedbackPage> {
  List<Map<String, dynamic>> _feedbacks = [];
  int totalFeedbacks = 0;
  int pendingFeedbacks = 0;
  int resolvedFeedbacks = 0;

  @override
  void initState() {
    super.initState();
    _aggregateFeedbacks();
  }

  Future<void> _aggregateFeedbacks() async {
    var feedbackQuery =
        await FirebaseFirestore.instance.collection('feedback').get();
    var patientFeedbackQuery =
        await FirebaseFirestore.instance.collection('patient_feedback').get();
    var patientQuery =
        await FirebaseFirestore.instance.collection('patients').get();

    Map<String, Set<DateTime>> uniqueFeedbacks = {};
    Map<String, Map<DateTime, List<String>>> feedbackComments = {};
    Set<String> totalFeedbackIds = {};

    // Clear the _feedbacks list to avoid adding duplicate feedback on page reload
    List<Map<String, dynamic>> aggregatedFeedbackList = [];

    // Loop through each feedback to aggregate
    for (var feedbackDoc in patientFeedbackQuery.docs) {
      var feedbackData = feedbackDoc.data();
      var patientId = feedbackData['patientId'];
      var feedbackId = feedbackData['feedbackId'];
      var submittedAt = DateTime.parse(feedbackData['submittedAt']);

      // Safely handle null 'isResolved' by treating it as 'false' if it's null.
      bool isResolved = feedbackData['isResolved'] ?? false;

      if (isResolved) continue;

      if (!uniqueFeedbacks.containsKey(patientId)) {
        uniqueFeedbacks[patientId] = {};
      }

      uniqueFeedbacks[patientId]!.add(submittedAt);
      totalFeedbackIds.add(feedbackId);

      if (!feedbackComments.containsKey(patientId)) {
        feedbackComments[patientId] = {};
      }

      if (!feedbackComments[patientId]!.containsKey(submittedAt)) {
        feedbackComments[patientId]![submittedAt] = [];
      }

      var feedback =
          feedbackQuery.docs.firstWhere((doc) => doc.id == feedbackId);
      feedbackComments[patientId]![submittedAt]!
          .add(feedback.data()['comment']);
    }

    totalFeedbacks =
        uniqueFeedbacks.values.fold(0, (sum, dates) => sum + dates.length);

    // Recalculate pending and resolved feedbacks
    pendingFeedbacks = uniqueFeedbacks.entries.fold(0, (count, entry) {
      return count +
          entry.value.where((date) {
            return patientFeedbackQuery.docs.any((doc) {
              bool isResolved = doc['isResolved'] ?? false;
              return doc['patientId'] == entry.key &&
                  DateTime.parse(doc['submittedAt']).isAtSameMomentAs(date) &&
                  !isResolved;
            });
          }).length;
    });

    resolvedFeedbacks = uniqueFeedbacks.entries.fold(0, (count, entry) {
      return count +
          entry.value.where((date) {
            return patientFeedbackQuery.docs.any((doc) {
              bool isResolved =
                  doc['isResolved'] ?? false; // Handle null 'isResolved'
              return doc['patientId'] == entry.key &&
                  DateTime.parse(doc['submittedAt']).isAtSameMomentAs(date) &&
                  isResolved; // Only count resolved feedback
            });
          }).length;
    });

    // Aggregate unresolved feedbacks
    for (var patientId in uniqueFeedbacks.keys) {
      var user = patientQuery.docs.firstWhere((doc) => doc.id == patientId);
      String firstName = user['firstName'];
      String lastName = user['lastName'];
      String fullName = '$firstName $lastName';

      for (var date in uniqueFeedbacks[patientId]!) {
        String feedbacks = uniqueFeedbacks[patientId]!.join(', ');
        String comments = feedbackComments[patientId]![date]!.join(', ');

        var feedbackData = {
          'userName': fullName,
          'date': date,
          'feedbacks': feedbacks,
          'comments': comments,
          'feedbackIds': feedbackComments[patientId]![date]!,
          'isResolved': false, // Initially set to false
        };

        // Add unresolved feedbacks to the list
        aggregatedFeedbackList.add(feedbackData);
      }
    }

    setState(() {
      _feedbacks =
          aggregatedFeedbackList; // Refresh the list with unresolved feedbacks only
    });
  }

  Future<void> _markAsResolved(Map<String, dynamic> feedback) async {
    var patientName = feedback['userName'];
    var date = feedback['date'];

    DateTime firebaseDate;
    if (date is String) {
      firebaseDate = DateTime.parse(date);
    } else if (date is DateTime) {
      firebaseDate = date;
    } else {
      print('Invalid date format');
      return;
    }

    List<String> nameParts = patientName.split(' ');
    if (nameParts.length < 2) {
      print('Invalid userName format');
      return;
    }

    var firstName = nameParts[0];
    var lastName = nameParts.sublist(1).join(' ');

    var patientQuery = await FirebaseFirestore.instance
        .collection('patients')
        .where('firstName', isEqualTo: firstName)
        .where('lastName', isEqualTo: lastName)
        .get();

    if (patientQuery.docs.isEmpty) {
      print('No patient found with this name');
      return;
    }

    var patientId = patientQuery.docs.first.id;

    // Update the 'isResolved' field in the database
    await FirebaseFirestore.instance
        .collection('patient_feedback')
        .where('patientId', isEqualTo: patientId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var submittedAt;
        if (doc['submittedAt'] is Timestamp) {
          submittedAt = (doc['submittedAt'] as Timestamp).toDate();
        } else if (doc['submittedAt'] is String) {
          submittedAt = DateTime.parse(doc['submittedAt']);
        }

        if (submittedAt.isAtSameMomentAs(firebaseDate)) {
          doc.reference.update({'isResolved': true});
        }
      });
    });

    setState(() {
      // Directly remove the resolved feedback from the list
      _feedbacks.removeWhere((item) =>
          item['date'] == firebaseDate && item['userName'] == patientName);
      pendingFeedbacks--; // Decrease pending count
      resolvedFeedbacks++; // Increase resolved count

      // Only show unresolved feedback
      _feedbacks =
          _feedbacks.where((item) => item['isResolved'] == false).toList();
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
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                      color: Color.fromARGB(255, 206, 206, 206),
                    ),
                    onPressed: () {
                      // filter functionality
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
                      itemBuilder: (context, index) =>
                          _buildFeedbackCard(_feedbacks[index]),
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
          _buildStatItem('Pending', '$pendingFeedbacks', Icons.pending),
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
              ],
            ),
            const SizedBox(height: 15),
            Text(
              feedback['comments'],
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
                    _markAsResolved(feedback);
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
