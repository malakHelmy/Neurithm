import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> resetPassword(BuildContext context, String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset email sent. Check your inbox.')),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.message}')),
    );
  }
}

class EmailService {
  Future<void> sendEmail(
      String subject, String message, String userEmail) async {
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

  Future<void> sendPasswordResetEmail(String email, String userEmail) async {
    final Email resetEmail = Email(
      body: 'Click the link to reset your password.',
      subject: 'Password Reset Request',
      recipients: [email],
      cc: [userEmail],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(resetEmail);
    } catch (e) {
      throw Exception('Error sending email: $e');
    }
  }
}
