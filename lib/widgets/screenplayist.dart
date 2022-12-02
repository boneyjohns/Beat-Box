import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:beat_box/widgets/homeAllList.dart';
import 'package:beat_box/widgets/playlistsongs.dart';
import 'package:beat_box/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hive_flutter/adapters.dart';

import '../database/function/db_functions.dart';
import '../database/model/hive_model.dart';

class ScreenCreatedPlaylist extends StatefulWidget {
  const ScreenCreatedPlaylist({super.key, required this.playlistName});
  final String playlistName;

  @override
  State<ScreenCreatedPlaylist> createState() => _ScreenCreatedPlaylistState();
}

class _ScreenCreatedPlaylistState extends State<ScreenCreatedPlaylist> {
  String? newPlaylistName;
  @override
  void initState() {
    newPlaylistName = widget.playlistName;
    super.initState();
  }

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylistBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
            top: Radius.circular(100),
          ),
        ),
        title: Text(
          newPlaylistName!,
          style: GoogleFonts.alfaSlabOne(
              fontSize: 32,
              color: const Color.fromARGB(255, 10, 141, 180),
              fontStyle: FontStyle.italic,
              letterSpacing: 5),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final List<Songs> playlistSongs =
                  playlistBox.get(newPlaylistName)!.toList().cast<Songs>();
              showEditingPlaylistDialoge(
                context: context,
                playlistName: newPlaylistName!,
                playlistSongs: playlistSongs,
              );
            },
            icon: const Icon(
              Icons.edit,
              //   color: kLightBlue,
            ),
          ),
          IconButton(
            onPressed: () {
              showSongModalSheet(
                context: context,
                playlistKey: newPlaylistName!,
              );
            },
            icon: const Icon(
              Icons.add,
              size: 27,
              //   color: kLightBlue,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ValueListenableBuilder<Box<List<dynamic>>>(
          valueListenable: playlistBox.listenable(),
          builder: (context, boxSongList, _) {
            final List<Songs> songList =
                boxSongList.get(newPlaylistName)!.cast<Songs>();

            if (songList.isEmpty) {
              return const Center(
                child: Text('No Songs Found'),
              );
            }
            return ListView.builder(
              itemCount: songList.length,
              itemBuilder: (ctx, index) {
                return Librarysongs(
                    playlistname: widget.playlistName,
                    songList: songList,
                    index: index,
                    audioPlayer: audioPlayer);
              },
            );
          },
        ),
      ),
    );
  }

  showEditingPlaylistDialoge({
    required BuildContext context,
    required String playlistName,
    required List<Songs> playlistSongs,
  }) {
    final TextEditingController textController =
        TextEditingController(text: playlistName);
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final formKey = GlobalKey<FormState>();
          return Form(
            key: formKey,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: const Color.fromARGB(255, 119, 182, 145),
              title: const Text(
                'Edit playlist',
                style: TextStyle(
                  //  color: kDarkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SearchField(
                textController: textController,
                hintText: 'Playlist Name',
                icon: Icons.playlist_add,
                validator: (value) {
                  final keys = getPlaylistBox().keys.toList();
                  if (value == null || value.isEmpty) {
                    return 'Field is empty';
                  }
                  if (keys.contains(value)) {
                    return '$value already exist in playlist';
                  }
                  return null;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final playlistBox = getPlaylistBox();
                      setState(() {
                        newPlaylistName = textController.text.trim();
                      });
                      await playlistBox.put(newPlaylistName, playlistSongs);
                      playlistBox.delete(playlistName);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
