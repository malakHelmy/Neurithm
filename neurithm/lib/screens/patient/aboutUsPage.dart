import 'package:flutter/material.dart';
import 'package:neurithm/l10n/generated/app_localizations.dart';
import 'package:neurithm/widgets/appbar.dart';
import 'package:neurithm/widgets/bottomBar.dart';
import 'package:neurithm/widgets/wavesBackground.dart';

class AboutUsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
        key: _scaffoldKey,
        drawer: sideAppBar(context),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(spacing(5, getScreenHeight(context))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: BottomBar(context, 0),
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
                          SizedBox(
                              height: spacing(15, getScreenHeight(context))),
                          Text(
                            t.aboutUs,
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.tagline,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.mission,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            t.visionTitle,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.vision,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            t.technologyTitle,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.technology,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            t.whyItMattersTitle,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.whyItMatters,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            t.teamTitle,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.team,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            t.acknowledgmentsTitle,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.acknowledgments,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            t.getInvolvedTitle,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.getInvolved,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
