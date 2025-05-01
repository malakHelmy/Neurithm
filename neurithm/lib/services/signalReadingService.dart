import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:neurithm/screens/patient/confirmContextPage.dart';

class SignalReadingService {

  // Function to handle the file upload and prediction request for start thinking
  Future<void> uploadFileAndStartThinking(BuildContext context) async {
    final String localServerUrl = 'http://10.0.2.2:5000/start_thinking'; 

    // Pick the file from the user's device
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    if (result == null) return; 

    final file = File(result.files.single.path!); // Get the selected file

    try {
      // Create a POST request to the Flask server for "Start Thinking"
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(localServerUrl) // Use the local Flask server URL
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

        // Show the predicted word to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Predicted Text: $predictedText')),
        );
      } else {
        // Show an error message if the server responds with an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get prediction. Please try again.')),
        );
      }
    } catch (e) {
      // Handle network errors or other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to handle Done Thinking request
  Future<void> doneThinking(BuildContext context) async {
    try {
      var response = await http.post(
        Uri.parse('http://10.0.2.2:5000/done_thinking'), // Done Thinking endpoint
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Extract corrected text from the response
        String originalText = data['original_text'];
        List<String> correctedTexts = List<String>.from(data['corrected_texts']);

        // Navigate to ConfirmContextPage with the corrected texts
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmContextPage(
              correctedTexts: correctedTexts,  // Pass the corrected options
            ),
          ),
        );
      } else {
        // Show an error message if the server responds with an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get correction. Please try again.')),
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
        Uri.parse('http://10.0.2.2:5000/restart'), // Restart endpoint
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Show success message after restarting
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server has been reset.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reset the server.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
