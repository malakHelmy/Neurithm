import 'package:flutter/material.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';

class FAQSection extends StatelessWidget {
  FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final List<Map<String, String>> faqs = [
      {'question': t.faq1Question, 'answer': t.faq1Answer},
      {'question': t.faq2Question, 'answer': t.faq2Answer},
      {'question': t.faq3Question, 'answer': t.faq3Answer},
    ];
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
