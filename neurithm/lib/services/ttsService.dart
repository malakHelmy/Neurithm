import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TTSService {

  Future<String> synthesizeSpeech(String text) async {
    String? accessToken = dotenv.env['GOOGLE_CLOUD_TTS_API_KEY'];
    if (accessToken == null) {
      print('Google Cloud TTS API key is missing.');
      return "error";
    }

    try {
      print("Inside TTS Service");
      final url = Uri.parse(
          'https://texttospeech.googleapis.com/v1/text:synthesize?key=$accessToken');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "input": {"text": text},
          "voice": {"languageCode": "ar-XA", "name": "ar-XA-Standard-D"},
          "audioConfig": {"audioEncoding": "LINEAR16"}
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String audioContent = responseData['audioContent'];

        final directory = await getTemporaryDirectory();
        String audioFilePath = '${directory.path}/output.wav';
        File audioFile = File(audioFilePath);
        await audioFile.writeAsBytes(base64Decode(audioContent));
        return audioFilePath;
      } else {
        print(
            'Failed to generate speech: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in synthesizeSpeech: $e');
    }
    return "error";
  }
}
