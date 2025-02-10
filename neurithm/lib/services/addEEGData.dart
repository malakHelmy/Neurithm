import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EEGDataService {
  late FirebaseFirestore _firestore;
  final String sessionId = "REvIuyIwAbZMzMlkyygn";

  EEGDataService() {
    _firestore = FirebaseFirestore.instanceFor(app: Firebase.app());
  }

  Future<void> saveEEGDataFromCSV(String filePath) async {
    try {
      print("🔹 Starting CSV file read...");

      final file = File(filePath);
      final content = await file.readAsString();
      final List<List<dynamic>> rows = CsvToListConverter().convert(content);
      
      print("🔹 CSV file successfully read. Processing data...");

      // Extract column headers
      final headers = rows[0].map((e) => e.toString()).toList();
      print("🔹 Headers from CSV: $headers");

      final channelColumns = [
        "EEG.AF3", "EEG.F7", "EEG.F3", "EEG.FC5", "EEG.T7", "EEG.P7", "EEG.O1",
        "EEG.O2", "EEG.P8", "EEG.T8", "EEG.FC6", "EEG.F4", "EEG.F8", "EEG.AF4"
      ];

      final columnIndexes = channelColumns.map((col) {
        int index = headers.indexOf(col);
        if (index == -1) {
          print("⚠ Warning: Column $col not found in CSV.");
        }
        return index;
      }).toList();

      List<Map<String, dynamic>> eegDataList = [];
      for (var row in rows.sublist(1)) {
        Map<String, dynamic> record = {};
        for (int i = 0; i < columnIndexes.length; i++) {
          if (columnIndexes[i] != -1) {
            record[channelColumns[i]] = row[columnIndexes[i]];
          }
        }
        eegDataList.add(record);
      }

      print("🔹 Data extracted successfully. Preparing Firestore storage...");

      // Convert data to a compatible Firestore format
      Map<String, dynamic> eegJsonData = {
        "sessionId": sessionId,
        "rawData": eegDataList.map((e) => Map<String, dynamic>.from(e)).toList(),
      };

      DocumentReference docRef = await _firestore.collection("eeg_data").add(eegJsonData);
      print("✅ EEG data successfully stored in Firestore! Document ID: ${docRef.id}");
    } catch (e) {
      print("❌ Error saving EEG data: $e");
    }
  }
}