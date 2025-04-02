import 'package:neurithm/models/wordBank.dart';
import 'package:neurithm/services/wordBankService.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PhraseTrackerDbHelper {
  static final PhraseTrackerDbHelper instance = PhraseTrackerDbHelper._init();
  static Database? _database;

  PhraseTrackerDbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('phrases.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
       CREATE TABLE frequentUsedPhrases (
         patientID TEXT NOT NULL,
         wordbankphraseID TEXT NOT NULL,
         counter INTEGER DEFAULT 1,
         PRIMARY KEY (patientID, wordbankphraseID)
       )
     ''');
  }

  Future<void> incrementPhraseUsage(String patientID, String phraseID) async {
    final db = await instance.database;

    final result = await db.rawQuery(
        'SELECT counter FROM frequentUsedPhrases WHERE patientID = ? AND wordbankphraseID = ?',
        [patientID, phraseID]);

    if (result.isEmpty) {
      await db.insert('frequentUsedPhrases', {
        'patientID': patientID,
        'wordbankphraseID': phraseID,
        'counter': 1,
      });
    } else {
      int counter = result.first['counter'] as int;
      await db.update(
        'frequentUsedPhrases',
        {'counter': counter + 1},
        where: 'patientID = ? AND wordbankphraseID = ?',
        whereArgs: [patientID, phraseID],
      );
    }
  }

  Future<List<WordBankPhrase>> getFrequentPhrases(String patientID) async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT wordbankphraseID FROM frequentUsedPhrases 
     WHERE patientID = ? AND counter > 5
   ''', [patientID]);

    // Step 2: Fetch full phrase details from Firebase
    List<WordBankPhrase> phrases = [];
    for (var row in result) {
      String phraseID = row['wordbankphraseID'] as String;
      WordBankPhrase? phrase = await WordBankService().getPhraseById(phraseID);

      if (phrase != null) {
        phrases.add(phrase);
      }
    }

    return phrases;
  }
}
