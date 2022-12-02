import 'package:beat_box/screens/navigationpage/navigation_page.dart';
import 'package:beat_box/widgets/homeAllList.dart';
import 'package:beat_box/widgets/screenplayist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import '../database/function/db_functions.dart';
import '../database/model/hive_model.dart';

// ignore: must_be_immutable
class Screenplaylist extends StatelessWidget {
  Screenplaylist({
    super.key,
  });
  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylistBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => const NavigationPage(),
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 10, 10, 10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
              top: Radius.circular(100),
            ),
          ),
          title: Text(
            'Created Playlists',
            style: GoogleFonts.alfaSlabOne(
              fontSize: 22,
              color: const Color.fromARGB(255, 10, 141, 180),
              fontStyle: FontStyle.italic,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 60,
        ),
        body: Column(children: [
          const SizedBox(height: 15),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: playlistBox.listenable(),
              builder: (context, value, child) {
                List keys = playlistBox.keys.toList();
                keys.removeWhere((key) => key == 'Favourites');
                keys.removeWhere((key) => key == 'Recent');
                keys.removeWhere((key) => key == 'Most Played');
                return (keys.isEmpty)
                    ? const Center(
                        child: Text('No Created Playlist..'),
                      )
                    : GridView.builder(
                        itemCount: keys.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 1.25,
                        ),
                        itemBuilder: (context, index) {
                          final String playlistName = keys[index];

                          final List<Songs> songList = playlistBox
                              .get(playlistName)!
                              .toList()
                              .cast<Songs>();

                          final int songListlength = songList.length;

                          return CreatedPlaylist(
                            playlistImage: 'lib/asset/playlist.jpg',
                            playlistName: playlistName,
                            playlistSongNum: '$songListlength Songs',
                          );
                        },
                      );
              },
            ),
          )
        ]));
  }
}

class CreatedPlaylist extends StatelessWidget {
  const CreatedPlaylist({
    Key? key,
    required this.playlistImage,
    required this.playlistName,
    required this.playlistSongNum,
  }) : super(key: key);
  final String playlistImage;
  final String playlistName;
  final String playlistSongNum;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ScreenCreatedPlaylist(
              playlistName: playlistName,
            ),
          ),
        );
      },
      onLongPress: () {
        showPlaylistDeleteAlert(context: context, key: playlistName);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image.asset(
              playlistImage,
              fit: BoxFit.cover,
              height: 155,
            ),
          ),
          Positioned(
            bottom: 32,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.anton(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  playlistSongNum,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
