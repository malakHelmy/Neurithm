import 'package:flutter/material.dart';

class FAQSection extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I use this app?',
      'answer':
          'To use the app, navigate through the menu and select the desired feature (translate thoughts, access word bank, user profile). Detailed tutorials are available in the tutorial section.'
    },
    {
      'question': 'How can I contact support?',
      'answer':
          'You can contact support through the "Contact Us" section in the app or email us at support@example.com.'
    },
    {
      'question': 'Where can I find my history?',
      'answer':
          'Saved data can be found in the "History" section accessible from the bottom bar.'
    },
  ];

   FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: faqs.map((faq) {
        return FAQTile(
          question: faq['question']!,
          answer: faq['answer']!,
        );
      }).toList(),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontSize: 22,
          fontFamily: 'Lato',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
