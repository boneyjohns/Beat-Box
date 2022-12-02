import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:beat_box/database/function/db_functions.dart';
import 'package:beat_box/database/model/hive_model.dart';

import 'package:beat_box/screens/likedsongs/likedsongs.dart';
import 'package:beat_box/widgets/homeAllList.dart';
import 'package:beat_box/widgets/home_icons.dart';
import 'package:beat_box/widgets/playlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylistBox();
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Expanded(
          flex: 1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                width: 5,
              ),
              Homeicons(
                ontap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => Screenplaylist(),
                    ),
                  );
                },
                playlistname: 'Playlist',
                imagepath: 'lib/asset/new.1.jpg',
              ),
              const SizedBox(
                width: 5,
              ),
              Homeicons(
                ontap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ScreenFavourites(
                            playlistName: 'Recent',
                          )));
                },
                playlistname: 'Recent Songs',
                imagepath: 'lib/asset/new.2.jpg',
              ),
              const SizedBox(
                width: 5,
              ),
              Homeicons(
                ontap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ScreenFavourites(
                            playlistName: 'Favourites',
                          )));
                },
                playlistname: 'Liked Songs',
                imagepath: 'lib/asset/new.jpg',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            width: 35,
          ),
          Text(
            'All Songs',
            style: GoogleFonts.prata(
                color: Color.fromARGB(255, 5, 5, 5),
                fontSize: 24,
                fontStyle: FontStyle.italic),
          ),
        ]),
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 2,
          child: ValueListenableBuilder(
            valueListenable: songBox.listenable(),
            builder: (BuildContext context, boxSongs, _) {
              List<Songs> songList = songBox.values.toList().cast<Songs>();
              return (songList.isEmpty)
                  ? const Text("No Songs Found")
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Homesongs(
                          index: index,
                          audioPlayer: audioPlayer,
                          songList: songList,
                        );
                      },
                      itemCount: songBox.length,
                    );
            },
          ),
        )
      ],
    );
  }
}
