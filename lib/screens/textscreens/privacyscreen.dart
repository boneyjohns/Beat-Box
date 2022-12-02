import 'package:beat_box/screens/navigationpage/navigation_page.dart';
import 'package:beat_box/screens/text/privacy.dart';
import 'package:beat_box/screens/text/terms_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ScreenSettingTile extends StatelessWidget {
  ScreenSettingTile({super.key, required this.screenName});
  final String screenName;
  String? screenContent;

  @override
  Widget build(BuildContext context) {
    screenContent =
        screenName == 'PrivacyPolicy' ? PrivacyPolicy : TermsAndConditions;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 248, 248, 248),
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (ctx) => NavigationPage()));
          },
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
            top: Radius.circular(100),
          ),
        ),
        title: Text(
          screenName,
          style: GoogleFonts.alfaSlabOne(
            fontSize: 26,
            color: const Color.fromARGB(255, 10, 141, 180),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Html(data: screenContent),
        ),
      ),
    );
  }
}
