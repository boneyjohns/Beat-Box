import 'package:beat_box/screens/home/home.dart';
import 'package:beat_box/screens/library/library.dart';
import 'package:beat_box/screens/scarchscreen/scarch_screen.dart';
import 'package:beat_box/screens/settingsdrawer/settings_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const MyHome(),
//Nowplaying(audioPlayer: ),
    Library(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SettingsDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
            top: Radius.circular(100),
          ),
        ),
        title: Text(
          'BEAT BOX',
          style: GoogleFonts.alfaSlabOne(
              fontSize: 32,
              color: const Color.fromARGB(255, 10, 141, 180),
              fontStyle: FontStyle.italic,
              letterSpacing: 5),
        ),
        centerTitle: true,
        toolbarHeight: 60,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => Searchbar()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(30), right: Radius.circular(30)),
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Colors.black,
              color: const Color.fromARGB(255, 119, 182, 145),
              activeColor: const Color.fromARGB(255, 119, 182, 145),
              tabBackgroundColor: const Color.fromARGB(255, 10, 141, 180),
              padding: const EdgeInsets.all(10),

              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                const GButton(
                  icon: Icons.home,
                  text: 'Home',
                  textStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
                // const GButton(
                //   icon: Icons.play_arrow,
                //   text: 'Now Playing',
                //   textStyle: TextStyle(fontSize: 10, color: Colors.white),
                // ),
                GButton(
                  icon: Icons.library_music_rounded,
                  text: 'Library',
                  textStyle: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ]),
        ),
      ),
    );
  }
}
