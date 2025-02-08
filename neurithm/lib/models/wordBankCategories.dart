
class WordBankCategory {
  final String id;
  final String name;

  WordBankCategory({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory WordBankCategory.fromMap(Map<String, dynamic> map, String documentId) {
    return WordBankCategory(
      id: documentId,
      name: map['name'],
    );
  }
}
