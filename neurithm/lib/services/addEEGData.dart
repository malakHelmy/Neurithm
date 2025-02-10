import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';


class EEGDataService {
  late FirebaseFirestore _firestore;
  final String sessionId = "REvIuyIwAbZMzMlkyygn";

  EEGDataService() {
    _firestore = FirebaseFirestore.instanceFor(app: Firebase.app());
  }


Future<void> saveEEGDataFromCSV() async {
  try {
    print("🔹 Starting CSV file read...");

    // Use file_picker to select a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) {
      print("⚠ No file selected.");
      return;
    }

    // Get the file content
    PlatformFile file = result.files.first;
    final content = utf8.decode(file.bytes!); // Decode bytes to string

    // Skip metadata lines at the beginning
    final cleanedContent = content.split('\n')
        .skipWhile((line) => !line.startsWith('Timestamp'))
        .join('\n');

    final List<List<dynamic>> rows = CsvToListConverter().convert(cleanedContent);

    print("🔹 CSV file successfully read. Processing data...");

    // Extract column headers
    final headers = rows[0].map((e) => e.toString().trim()).toList();

    // Define EEG channels we want to capture
    final channelColumns = [
      "EEG.AF3", "EEG.F7", "EEG.F3", "EEG.FC5", "EEG.T7", "EEG.P7", "EEG.O1",
      "EEG.O2", "EEG.P8", "EEG.T8", "EEG.FC6", "EEG.F4", "EEG.F8", "EEG.AF4"
    ];

    // Get indices of our desired columns
    final Map<String, int> columnIndices = {};
    for (var channel in channelColumns) {
      int index = headers.indexOf(channel);
      if (index != -1) {
        columnIndices[channel] = index;
      } else {
        print("⚠ Warning: Column $channel not found in CSV.");
      }
    }

    // Process the data rows
    List<Map<String, dynamic>> eegDataList = [];
    for (var row in rows.sublist(1)) {
      if (row.isEmpty) continue;

      Map<String, dynamic> record = {};
      columnIndices.forEach((channel, index) {
        // Convert the value to double and handle any potential null values
        var value = row[index];
        record[channel] = value is num ? value.toDouble() : 0.0;
      });

      // Add timestamp if available
      int timestampIndex = headers.indexOf('Timestamp');
      if (timestampIndex != -1 && row[timestampIndex] != null) {
        record['timestamp'] = row[timestampIndex];
      }

      eegDataList.add(record);
    }

    print("🔹 Data extracted successfully. Preparing Firestore storage...");

    // Save the entire dataset as one record
    Map<String, dynamic> eegJsonData = {
      "sessionId": sessionId,
      "readings": eegDataList, // Save all readings in one document
    };

    // Add the data to Firestore
    await _firestore.collection("eeg_data").add(eegJsonData);
    print("✅ All EEG data successfully stored in Firestore as one record!");
  } catch (e, stackTrace) {
    print("❌ Error saving EEG data: $e");
    print("Stack trace: $stackTrace");
  }
}
}