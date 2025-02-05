class WordBankPhrase {
  final String id;
  final String categoryId;
  final String phrase;

  WordBankPhrase({required this.id, required this.categoryId, required this.phrase});

  // Convert Phrase object to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'phrase': phrase,
    };
  }

  // Create Phrase object from Firestore document
  factory WordBankPhrase.fromMap(Map<String, dynamic> map, String documentId) {
    return WordBankPhrase(
      id: documentId,
      categoryId: map['category_id'],
      phrase: map['phrase'],
    );
  }
}
