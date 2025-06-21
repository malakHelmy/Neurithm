import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:neurithm/screens/patient/confirmContextPage.dart';
import 'package:neurithm/services/authService.dart';

class SignalReadingService {
  final AuthService _authService = AuthService();

  Future<void> startThinkingWithSession(BuildContext context,
      {bool isNewWord = false}) async {
    var currentUser = await _authService.getCurrentUser();
    print("user: "+currentUser.firstName);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please log in again.')),
      );
      return;
    }

    DateTime startTime = DateTime.now();

    Map<String, dynamic> sessionData = {
      'patientId': currentUser.uid,
      'startTime': startTime.toIso8601String(),
      'endTime': null,
    };

    try {
      final sessionRef = FirebaseFirestore.instance.collection('sessions');
      await sessionRef.add(sessionData);
      print("Session successfully saved to Firestore!");
    } catch (e) {
      print("Error saving session to Firestore: $e");
    }

    await uploadFileAndStartThinking(context, isNewWord: isNewWord);
  }

  Future<void> updateEndTimeByPatientId(String patientId) async {
    try {
      DateTime endTime = DateTime.now();

      var sessionSnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .where('patientId', isEqualTo: patientId)
          .where('endTime', isEqualTo: null)
          .limit(1)
          .get();

      if (sessionSnapshot.docs.isEmpty) {
        print("No active session found for patientId: $patientId");
        return;
      }

      var sessionDoc = sessionSnapshot.docs.first;

      await sessionDoc.reference.update({
        'endTime': endTime.toIso8601String(),
      });

      print("Session end time successfully updated for patientId: $patientId!");
    } catch (e) {
      print("Error updating end time: $e");
    }
  }

  // Function to handle the file upload and prediction request for start thinking
  Future<void> uploadFileAndStartThinking(BuildContext context,
      {bool isNewWord = false}) async {
    const String localServerUrl = 'https://8e2b-45-244-69-164.ngrok-free.app/start_thinking';

    // Pick the file from the user's device
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return;

    final file = File(result.files.single.path!);

    try {
      // Create a POST request to the Flask server for "Start Thinking"
      var request = http.MultipartRequest(
          'POST', Uri.parse(localServerUrl) // Use the local Flask server URL
          );

      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request and wait for the response
      var response = await request.send();

      // Check if the response is successful
      if (response.statusCode == 200) {
        // If successful, decode the JSON response
        var responseData = await response.stream.bytesToString();
        var data = json.decode(responseData);

        // Extract predicted text from the server response
        String predictedText = data['concatenated_word'];

        // Show a customized SnackBar message based on the type of action
        String snackBarMessage = isNewWord
            ? 'New word added successfully: $predictedText'
            : 'Start Thinking Processed Successfully: $predictedText';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(snackBarMessage)),
        );
      } else {
        // Show an error message if the server responds with an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to get prediction. Please try again.')),
        );
      }
    } catch (e) {
      // Handle network errors or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> doneThinking(BuildContext context) async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://8e2b-45-244-69-164.ngrok-free.app/done_thinking'), 
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Extract corrected text from the response
        String originalText = data['original_text'];
                print("original text: " + data['original_text']);

        List<String> correctedTexts =
            List<String>.from(data['corrected_texts']);

        // Get the current user's sessionId
        var currentUser = await _authService.getCurrentUser();
        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not found. Please log in again.')),
          );
          return;
        }

        // Query the Firestore database to get the sessionId
        var sessionSnapshot = await FirebaseFirestore.instance
            .collection('sessions')
            .where('patientId', isEqualTo: currentUser.uid)
            .where('endTime', isEqualTo: null) // Look for active sessions
            .limit(1)
            .get();

        if (sessionSnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No active session found.')),
          );
          return;
        }

        String sessionId = sessionSnapshot.docs.first.id;

        // Navigate to ConfirmContextPage with the corrected texts and sessionId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmContextPage(
              correctedTexts: correctedTexts, 
              sessionId: sessionId, 
            ),
          ),
        );

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Done Thinking Processed Successfully: $originalText')),
        );
      } else {
        // Show an error message if the server responds with an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to get correction. Please try again.')),
        );
      }
    } catch (e) {
      // Handle network errors or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to restart the server
  Future<void> restartServer(BuildContext context) async {
    try {
      var response = await http.post(
        Uri.parse('https://8e2b-45-244-69-164.ngrok-free.app/restart'), // Restart endpoint
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Show success message after restarting
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restart Successful.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to restart.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
