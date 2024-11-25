import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottombar.dart';
import '../widgets/wavesBackground.dart';

class wordBankPage extends StatefulWidget {
  const wordBankPage({super.key});

  @override
  State<wordBankPage> createState() => _wordBankPageState();
}

class _wordBankPageState extends State<wordBankPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  // Categories for the grid
  final List<Map<String, dynamic>> categories = [
    {"title": "Food", "icon": Icons.fastfood},
    {"title": "Work", "icon": Icons.work},
    {"title": "Family", "icon": Icons.family_restroom},
    {"title": "Emergency", "icon": Icons.warning},
    {"title": "Greetings", "icon": Icons.handshake},
    {"title": "Travel", "icon": Icons.flight},
    {"title": "Health", "icon": Icons.local_hospital},
    {"title": "Daily Needs", "icon": Icons.shopping_basket},
  ];

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
                    // Drawer appBar
                    appBar(_scaffoldKey),

                    SizedBox(height: spacing(15, getScreenHeight(context))),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search words...",
                        hintStyle: TextStyle(
                          color: Color(0xFF1A2A3A),
                        ),
                        prefixIcon: Icon(Icons.search),
                        prefixIconColor: Color(0xFF1A2A3A),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),

                    SizedBox(height: spacing(30, getScreenHeight(context))),
                    const Text(
                      "Frequently Accessed Words",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 206, 206, 206),
                      ),
                    ),
                    SizedBox(height: spacing(30, getScreenHeight(context))),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          4,
                          (index) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    spacing(5, getScreenHeight(context))),
                            child: Container(
                              height: spacing(100, getScreenHeight(context)),
                              width: getScreenWidth(context) * 0.35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing(30, getScreenHeight(context))),

                    // Grid Title
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 206, 206, 206),
                      ),
                    ),
                    // Grid of Categories
                    GridView.builder(
                      shrinkWrap: true, // Ensures it doesn't expand infinitely
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two items per row
                        crossAxisSpacing: spacing(25, getScreenWidth(context)),
                        mainAxisSpacing: spacing(10, getScreenHeight(context)),
                        childAspectRatio: 1.5, // Square items
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to the word bank for the selected category
                            print("Selected category: ${category['title']}");
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
                                Icon(
                                  category['icon'],
                                  size: 40,
                                  color: Color(0xFF1A2A3A),
                                ),
                                SizedBox(
                                    height:
                                        spacing(5, getScreenHeight(context))),
                                Text(
                                  category['title'],
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
