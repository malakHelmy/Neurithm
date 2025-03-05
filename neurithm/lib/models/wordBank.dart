class WordBankPhrase {
  final String id;
  final String categoryId;
  final String phrase;

  WordBankPhrase({required this.id, required this.categoryId, required this.phrase});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'phrase': phrase,
    };
  }

factory WordBankPhrase.fromMap(Map<String, dynamic> map, [String? documentId]) {
  return WordBankPhrase(
    id: documentId ?? '', // Use an empty string if documentId is null
    categoryId: map['category_id'] ?? '',
    phrase: map['phrase'] ?? '',
  );
}
}