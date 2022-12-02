import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:beat_box/database/model/hive_model.dart';

import 'package:beat_box/widgets/homealllist.dart';

import 'package:beat_box/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../database/function/db_functions.dart';

class Searchbar extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Searchbar({
    super.key,
  });

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  final TextEditingController _searchController = TextEditingController();
  Box<Songs> songBox = getSongBox();
  List<Songs>? dbSongs;
  List<Songs>? searchedSongs;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  void initState() {
    super.initState();
    dbSongs = songBox.values.toList().cast<Songs>();
    searchedSongs = List<Songs>.from(dbSongs!).toList().cast<Songs>();
  }

  searchSongfomDb(String searchSong) {
    setState(() {
      searchedSongs = dbSongs!
          .where((song) =>
              song.songname.toLowerCase().contains(searchSong.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color.fromARGB(255, 98, 149, 175),
        child: Scaffold(
          body: Column(
            children: [
              SearchField(
                validator: (value) {
                  return null;
                },
                textController: _searchController,
                hintText: 'Search Songs Here',
                icon: Icons.search,
                onChanged: (value) {
                  searchSongfomDb(value);
                },
              ),
              Expanded(
                child: (searchedSongs!.isEmpty)
                    ? const Center(
                        child: Text('No Songs Found'),
                      )
                    : ListView.builder(
                        itemCount: searchedSongs!.length,
                        itemBuilder: (context, index) {
                          return Homesongs(
                            songList: searchedSongs!,
                            index: index,
                            audioPlayer: audioPlayer,
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }
}
