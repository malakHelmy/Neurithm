import 'package:flutter/material.dart';
import 'package:neurithm/services/addwordBank.dart';
import 'package:neurithm/models/wordBankCategories.dart';
import '../widgets/appbar.dart';
import '../widgets/bottombar.dart';
import '../widgets/wavesBackground.dart';
import "../widgets/wordBankPhrases.dart";

class WordBankPage extends StatefulWidget {
  const WordBankPage({super.key});

  @override
  State<WordBankPage> createState() => _WordBankPageState();
}

class _WordBankPageState extends State<WordBankPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirestoreService _firestoreService = FirestoreService();
  TextEditingController searchController = TextEditingController();
  List<WordBankCategory> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await _firestoreService.fetchCategories();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: sideAppBar(context),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(spacing(5, getScreenHeight(context))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: bottomappBar(context),
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
                        hintText: "Search categories...",
                        hintStyle: TextStyle(color: Color(0xFF1A2A3A)),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF1A2A3A)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),

                    SizedBox(height: spacing(30, getScreenHeight(context))),

                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 206, 206, 206),
                      ),
                    ),

                    SizedBox(height: spacing(10, getScreenHeight(context))),

                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: spacing(25, getScreenWidth(context)),
                              mainAxisSpacing: spacing(10, getScreenHeight(context)),
                              childAspectRatio: 1.5,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WordBankPhrases(category: category),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.category, size: 40, color: Color(0xFF1A2A3A)),
                                      SizedBox(height: spacing(5, getScreenHeight(context))),
                                      Text(
                                        category.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF1A2A3A),
                                          fontWeight: FontWeight.bold,
                                        ),
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
