import 'package:flutter/material.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';
import 'package:neurithm/models/patient.dart';
import 'package:neurithm/services/authService.dart';
import 'package:neurithm/services/wordBankService.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';
import 'package:neurithm/widgets/wordBankPhrases.dart';

class WordBankPage extends StatefulWidget {
  const WordBankPage({super.key});

  @override
  State<WordBankPage> createState() => _WordBankPageState();
}

class _WordBankPageState extends State<WordBankPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final WordBankService _wordBankService = WordBankService();
  TextEditingController searchController = TextEditingController();
  List<WordBankCategory> categories = [];
  final AuthService _authService = AuthService();
  Patient? _currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchCategories(context);
  }

  Future<void> _fetchUser() async {
    Patient? user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _fetchCategories(BuildContext context) async {
    try {
      final fetchedCategories = await _wordBankService.fetchCategories(context);
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  IconData getIconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'emergency':
        return Icons.warning;
      case 'frequent used phrases' || "العبارات المستخدمة بشكل مترر":
        return Icons.chat;
      case 'food' || 'طعام':
        return Icons.fastfood ;
      case 'work' || 'عمل':
        return Icons.work;
      case 'greetings'|| 'تحيات':
        return Icons.waving_hand;
      case 'daily needs'|| 'احتياجات يومية':
        return Icons.shopping_cart;
      case 'health'|| 'صحة':
        return Icons.health_and_safety;
      case 'travel'|| 'سفر':
        return Icons.airplanemode_active;
      case 'family'|| 'عائلة':
        return Icons.family_restroom;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {    
    var t = AppLocalizations.of(context)!;
    String searchText = searchController.text.toLowerCase();
    List<WordBankCategory> filteredCategories = categories
        .where((category) => category.name.toLowerCase().contains(searchText))
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: sideAppBar(context),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5, getScreenHeight(context))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BottomBar(context, 1),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: gradientBackground,
          child: Stack(
            children: [
               waveBackground,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing(15, getScreenHeight(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appBar(_scaffoldKey),
                    SizedBox(height: spacing(15, getScreenHeight(context))),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: t.searchForCategories,
                        hintStyle: const TextStyle(color: Color(0xFF1A2A3A)),
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF1A2A3A)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: spacing(30, getScreenHeight(context))),
                    Text(
                      t.categories,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 206, 206, 206),
                      ),
                    ),
                    SizedBox(height: spacing(10, getScreenHeight(context))),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing:
                                  spacing(30, getScreenWidth(context)),
                              mainAxisSpacing:
                                  spacing(20, getScreenHeight(context)),
                              childAspectRatio: 1.5,
                            ),
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index) {
                              final category = filteredCategories[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WordBankPhrases(
                                          currentUser: _currentUser,
                                          category: category),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 226, 226, 226),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(getIconForCategory(category.name),
                                          size: 40,
                                          color: const Color(0xFF1A2A3A)),
                                      SizedBox(
                                          height: spacing(
                                              5, getScreenHeight(context))),
                                      Text(
                                        category.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF1A2A3A),
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.visible
                                          
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    SizedBox(height: spacing(20, getScreenHeight(context))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
