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
                child: Stack(children: [
                  wavesBackground(
                      getScreenWidth(context), getScreenHeight(context)),
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing(15, getScreenHeight(context)),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drawer appBar
                            appBar(_scaffoldKey),

                            SizedBox(height: spacing(15, getScreenHeight(context)))
                          ]))
                ]))));
  }
}
