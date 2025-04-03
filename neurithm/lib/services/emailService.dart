import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailService {
  Future<void> sendEmail(String subject, String message, String userEmail) async {
    final Email email = Email(
      body: message,
      subject: subject,
      recipients: ['neurithm1@gmail.com'],
      cc: [userEmail],  
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      throw Exception('Error sending email: $e');
    }
  }
}
