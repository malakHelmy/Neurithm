class WordBankCategory {
  final String id;
  final String name;

  WordBankCategory({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory WordBankCategory.fromMap(Map<String, dynamic> map, String id) {
    return WordBankCategory(
      id: id,
      name: map['name'],
    );
  }
}
