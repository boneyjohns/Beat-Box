import 'package:beat_box/screens/textscreens/privacyscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      child: SafeArea(
          child: Column(children: [
        Text(
          'Settings',
          style: GoogleFonts.alfaSlabOne(
              fontSize: 32,
              color: const Color.fromARGB(255, 10, 141, 180),
              fontStyle: FontStyle.italic,
              letterSpacing: 5),
        ),
        InkWell(
          onTap: () {
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Column(
                    children: [
                      Text(
                        "BEAT BOX",
                        style: const TextStyle(
                            fontFamily: "poppinz",
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                        selectionColor: Colors.blue,
                      ),
                      const Text('1.0.0')
                    ],
                  ),
                  content: const Text(
                      'BEAT BOX is designed and developed by\n BONEY JOHNS'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Color(0xffdd0021),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: Text(
                'About Us',
                style: TextStyle(color: Colors.white),
              )),
        ),
        Divider(height: 10),
        const ListTile(
          leading: Icon(Icons.notifications, color: Colors.white),
          title: Text(
            'Notification',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const Divider(
          height: 10,
        ),
        const ListTile(
          leading: Icon(Icons.share, color: Colors.white),
          title: Text(
            'Share',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const Divider(
          height: 10,
        ),
        ListTile(
            leading: Icon(Icons.health_and_safety, color: Colors.white),
            title: Text(
              'Privacy policy',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => ScreenSettingTile(
                            screenName: "PrivacyPolicy",
                          )));
            }),
        const Divider(
          height: 10,
        ),
        ListTile(
            leading: Icon(Icons.gavel_rounded, color: Colors.white),
            title: Text(
              'TermsAndConditions',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => ScreenSettingTile(
                            screenName: "Terms&Conditions",
                          )));
            })
      ])),
    );
  }
}
