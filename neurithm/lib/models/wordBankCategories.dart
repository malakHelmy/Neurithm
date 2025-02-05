
class WordBankCategory {
  final String id;
  final String name;

  WordBankCategory({required this.id, required this.name});

  // Convert Category object to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create Category object from Firestore document
  factory WordBankCategory.fromMap(Map<String, dynamic> map, String documentId) {
    return WordBankCategory(
      id: documentId,
      name: map['name'],
    );
  }
}
