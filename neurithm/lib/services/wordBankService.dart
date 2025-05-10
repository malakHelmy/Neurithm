import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neurithm/models/wordBank.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import 'package:neurithm/models/locale.dart';
import 'package:provider/provider.dart';

class WordBankService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Upload categories first, then phrases related to each category
  Future<void> uploadArabicCategoriesAndPhrases() async {
    final categories = {
      "food": "طعام",
      "work": "عمل",
      "family": "عائلة",
      "emergency": "طوارئ",
      "greetings": "تحيات",
      "travel": "سفر",
      "health": "صحة",
      "daily_needs": "احتياجات يومية",
    };

    final phrases = {
      "food": [
        "أنا جائع.",
        "أنا عطشان.",
        "أحتاج إلى شراب.",
        "أود بعض الماء.",
        "أنا شبعان، شكراً.",
        "هل يمكنني الحصول على المزيد من الملح/الفلفل؟",
        "هذا الطعام حار جداً.",
        "أريد شيئاً حلوًا.",
        "هل يمكنني الحصول على شيء طري لأكله؟",
        "من فضلك، قطع طعامي.",
        "هذا طعمه جيد.",
        "هل يمكنني تناول وجبة خفيفة؟",
        "أحتاج إلى منديل.",
        "هل يمكنك مساعدتي في طعامي؟",
        "هل يمكنك إعطائي مصاصة؟"
      ],
      "work": [
        "أحتاج إلى أخذ استراحة.",
        "هل يمكنك مساعدتي في الرد على الرسائل الإلكترونية؟",
        "لنحدد موعداً للاجتماع.",
        "أواجه صعوبة في الكتابة.",
        "من فضلك، كرر ذلك لي.",
        "هل يمكن لشخص ما أن يعرض عملي؟",
        "من فضلك، كن صبوراً معي.",
        "هل يمكنك مساعدتي في جهاز الكمبيوتر؟",
        "هل يمكنك توضيح هذه النقطة؟",
        "أحتاج إلى المساعدة في هذه المهمة.",
        "لقد أكملت المهمة.",
        "دعونا نناقش حالة المشروع.",
        "من فضلك، أرسل لي التقرير.",
        "من فضلك، أرسل لي البريد الإلكتروني."
      ],
      "family": [
        "أنا أحبك.",
        "هل يمكننا التحدث؟",
        "أقدر دعمك.",
        "شكراً لتفهمك.",
        "دعونا نمضي وقتاً معاً.",
        "أحتاج إلى بعض الوقت الهادئ.",
        "هل يمكنك مساعدتي في هذا؟",
        "هل يمكننا الخروج للحصول على بعض الهواء النقي؟",
        "لنلتقط صورة معاً.",
        "من فضلك، ابقَ معي لبعض الوقت.",
        "دعونا نستمع إلى الموسيقى معاً.",
        "شكراً لكل شيء."
      ],
      "emergency": [
        "لا أستطيع التنفس جيداً.",
        "اتصل بالرقم 911 الآن!",
        "أشعر بالدوار.",
        "أشعر بالألم.",
        "اتصل بمقدم الرعاية الخاص بي.",
        "أحتاج إلى دوائي الآن.",
        "أشعر أنني قد أغشي.",
        "خذني إلى المستشفى.",
        "هناك حريق.",
        "لقد سقطت.",
        "اتصل بطبيبي."
      ],
      "greetings": [
        "مرحباً!",
        "أهلاً وسهلاً!",
        "صباح الخير.",
        "مساء الخير.",
        "مساء النور.",
        "كيف حالك؟",
        "سعيد بلقائك.",
        "اعتنِ بنفسك.",
        "أراك لاحقاً.",
        "أتمنى لك يوماً سعيداً.",
        "وداعاً."
      ],
      "travel": [
        "أحتاج إلى مساعدة بالكراسي المتحركة.",
        "أين هو أقرب حمام؟",
        "أحتاج إلى تمديد ساقي.",
        "هل يمكنك مساعدتي في إيجاد مقعدي؟",
        "هذا المقعد غير مريح.",
        "من فضلك، ساعدني في حمل حقيبتي.",
        "هل يمكننا استخدام المصعد؟",
        "أين هو أقرب مخرج؟",
        "أحتاج إلى مساعدة في الصعود إلى الطائرة.",
        "لدي حجز."
      ],
      "health": [
        "لدي موعد اليوم.",
        "أحتاج إلى أخذ دوائي.",
        "هل يمكنك مساعدتي في تماريني؟",
        "أحتاج إلى فحص ضغط دمي.",
        "لدي موعد مع الطبيب.",
        "أحتاج إلى الراحة الآن.",
        "من فضلك، ساعدني في الجلوس.",
        "هل يمكنك مساعدتي في تحريك ساقي؟",
        "هل يمكنك دعم عنقي؟",
        "أحتاج إلى تعديل كرسيي المتحرك."
      ],
      "daily_needs": [
        "أحتاج إلى استخدام الحمام.",
        "هل يمكنك مساعدتي في ارتداء ملابسي؟",
        "أحتاج إلى تنظيف أسناني.",
        "من فضلك، ساعدني في الاستحمام.",
        "أحتاج إلى شحن جهازي.",
        "هل يمكنك مساعدتي في كرسيي المتحرك؟",
        "أحتاج إلى تعديل وضعي.",
        "من فضلك، ساعدني في نظارتي.",
        "أحتاج إلى أخذ قيلولة.",
        "هل يمكنك أن تقرأ لي؟",
        "من فضلك، اضبط منبهي.",
        "من فضلك، ساعدني في استخدام هاتفي.",
        "من فضلك، ضبط الوسائد.",
        "هل يمكنك مساعدتي في غسل يدي؟",
        "من فضلك، أحضر لي نعالي.",
        "أحتاج إلى أخذ فيتاميني.",
        "هل يمكنك فتح النافذة؟"
      ],
    };
    for (var entry in categories.entries) {
      var categoryRef = _db
          .collection('ar_word_bank_categories')
          .doc(); // Create new doc for each category
      await categoryRef.set({'name': entry.value});

      // Upload phrases linked to this category using the document ID of the category
      for (String phrase in phrases[entry.key]!) {
        var phraseRef = _db.collection('ar_word_bank').doc();
        await phraseRef.set({
          'category_id': categoryRef.id, // Link to the category ID
          'phrase': phrase
        });
      }
    }
  }

  Future<void> uploadCategoriesAndPhrases() async {
    final categories = {
      "food": "Food",
      "work": "Work",
      "family": "Family",
      "emergency": "Emergency",
      "greetings": "Greetings",
      "travel": "Travel",
      "health": "Health",
      "daily_needs": "Daily Needs",
    };

    final phrases = {
      "food": [
        "I'm hungry.",
        "I’m thirsty",
        "I need a drink.",
        "I would like some water.",
        "I’m full, thank you.",
        "Can I have more salt/pepper?",
        "This food is too hot.",
        "I want something sweet.",
        "Can I have something softer to eat?",
        "Please cut my food.",
        "This tastes good.",
        "Can I have a snack?",
        "I need a napkin.",
        "Can you help me with my meal?",
        "Can you give me a straw?"
      ],
      "work": [
        "I need to take a break.",
        "Can you help me respond to emails?",
        "Let’s schedule a meeting.",
        "I’m having difficulty writing.",
        "Please repeat that for me.",
        "Can someone present my work?",
        "Please be patient with me.",
        "Can you assist me with my computer?",
        "Can you clarify this point?",
        "I need assistance with this task",
        "I have completed the assignment.",
        "Let's discuss the project status.",
        "Please send me the report.",
        "Please forward me the email."
      ],
      "family": [
        "I love you.",
        "Can we talk?",
        "I appreciate your support.",
        "Thank you for understanding.",
        "Let's spend time together.",
        "I need some quiet time.",
        "Can you assist me with this?",
        "Can we go outside for fresh air?",
        "Let’s take a picture together.",
        "Please stay with me for a while.",
        "Let’s listen to music together.",
        "Thank you for everything."
      ],
      "emergency": [
        "I can’t breathe well.",
        "Call 911 now!",
        "I feel dizzy.",
        "I’m in pain.",
        "Call my caregiver",
        "I need my medication now.",
        "I feel like I might faint.",
        "Take me to the hospital.",
        "There's a fire.",
        "I have fallen.",
        "Contact my doctor."
      ],
      "greetings": [
        "Hello!",
        "Welcome!",
        "Good morning.",
        "Good afternoon.",
        "Good evening.",
        "How are you?",
        "Nice to see you.",
        "Take care.",
        "See you later.",
        "Have a great day.",
        "Goodbye."
      ],
      "travel": [
        "I need wheelchair assistance.",
        "Where is the nearest restroom?",
        "I need to stretch my legs.",
        "Can you help me find my seat?",
        "This seat is uncomfortable.",
        "Please help me with my bags.",
        "Can we take the elevator?",
        "Where is the nearest exit?",
        "I need assistance boarding.",
        "I have a reservation."
      ],
      "health": [
        "I have an appointment today.",
        "I need to take my medication.",
        "Can you help me with my exercises?",
        "I need to check my blood pressure.",
        "I have a doctor's appointment.",
        "I need to rest now.",
        "Please help me sit up.",
        "Can you help me move my legs?",
        "Can you support my neck?",
        "I need my wheelchair adjusted."
      ],
      "daily_needs": [
        "I need to use the restroom.",
        "Can you help me get dressed?",
        "I need to brush my teeth.",
        "Please assist me with bathing.",
        "I need to charge my device.",
        "Can you help me with my wheelchair?",
        "I need to adjust my position.",
        "Please help me with my glasses.",
        "I need to take a nap.",
        "Can you read to me?",
        "Please set my alarm.",
        "Please help me use my phone.",
        "Please adjust my pillows.",
        "Can you help me wash my hands?",
        "Please bring me my slippers.",
        "I need to take my vitamins.",
        "Can you open the window?"
      ],
    };

    // Upload categories first
    for (var entry in categories.entries) {
      var categoryRef = _db
          .collection('word_bank_categories')
          .doc(); // Create new doc for each category
      await categoryRef.set({'name': entry.value});

      // Upload phrases linked to this category using the document ID of the category
      for (String phrase in phrases[entry.key]!) {
        var phraseRef = _db.collection('word_bank').doc();
        await phraseRef.set({
          'category_id': categoryRef.id, // Link to the category ID
          'phrase': phrase
        });
      }
    }
  }

  // Fetch all categories
  Future<List<WordBankCategory>> fetchCategories(BuildContext context) async {
    // Get the current locale using Provider
    LocaleModel localeModel = Provider.of<LocaleModel>(context, listen: false);
    String languageCode = localeModel.locale.languageCode;

    // Print the current language (for debugging)
    print("Current language code: $languageCode");
    if (languageCode == 'ar') {
      var querySnapshot = await _db.collection('ar_word_bank_categories').get();
      return querySnapshot.docs
          .map((doc) => WordBankCategory.fromMap(doc.data(), doc.id))
          .toList();
    }
    var querySnapshot = await _db.collection('word_bank_categories').get();
    return querySnapshot.docs
        .map((doc) => WordBankCategory.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Fetch phrases based on category ID
  Future<List<WordBankPhrase>> fetchPhrases(
      String categoryId, BuildContext context) async {
    LocaleModel localeModel = Provider.of<LocaleModel>(context, listen: false);
    String languageCode = localeModel.locale.languageCode;
    if (languageCode == 'ar') {
      var querySnapshot = await _db
          .collection('ar_word_bank')
          .where('category_id', isEqualTo: categoryId)
          .get();

      return querySnapshot.docs
          .map((doc) => WordBankPhrase.fromMap(doc.data(), doc.id))
          .toList();
    }
    var querySnapshot = await _db
        .collection('word_bank')
        .where('category_id', isEqualTo: categoryId)
        .get();

    return querySnapshot.docs
        .map((doc) => WordBankPhrase.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String> getCategoryId(String name, context) async {
    LocaleModel localeModel = Provider.of<LocaleModel>(context, listen: false);
    String languageCode = localeModel.locale.languageCode;
    var snapshot;
    if (languageCode == 'ar') {
      snapshot = await FirebaseFirestore.instance
          .collection('ar_word_bank_categories')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('word_bank_categories')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
    }

    if (snapshot.docs.isNotEmpty) {
      // print("category id: " + snapshot.docs.first.id);
      final categoryId = snapshot.docs.first.id;

      return categoryId;
    } else {
      throw Exception("Frequent used phrases category not found");
    }
  }

  Future<void> addPhraseToCategory(
      WordBankPhrase phrase, String categoryId) async {
    await FirebaseFirestore.instance.collection('word_bank').add({
      'phrase': phrase.phrase,
      'category_id': categoryId,
    });
  }

  Future<WordBankPhrase?> getPhraseById(String phraseID) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('word_bank').doc(phraseID).get();

      if (doc.exists && doc.data() != null) {
        return WordBankPhrase.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print("Error fetching phrase by ID: $e");
    }
    return null;
  }
}
