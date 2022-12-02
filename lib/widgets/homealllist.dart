import 'package:beat_box/database/model/hive_model.dart';
import 'package:beat_box/functions/playlist.dart';
import 'package:beat_box/functions/recentsongs.dart';
import 'package:beat_box/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../database/function/db_functions.dart';
import '../functions/favorate_function.dart';
import 'miniplayer.dart';

class Homesongs extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const Homesongs({
    super.key,
    required this.index,
    required this.audioPlayer,
    required this.songList,
    this.onPressed,
  });

  final int index;
  final AssetsAudioPlayer audioPlayer;
  final List<Songs> songList;
  final void Function()? onPressed;
  @override
  State<Homesongs> createState() => _HomesongsState();
}

class _HomesongsState extends State<Homesongs> {
  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylistBox();

  @override
  void initState() {
    super.initState();
    setState(() {
      Favourites.isThisFavourite(id: widget.songList[widget.index].id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Recents.addSongsToRecents(songId: widget.songList[widget.index].id);
        showBottomSheet(
            backgroundColor: Color.fromARGB(255, 174, 255, 145),
            context: context,
            builder: (ctx) => Miniplayer(
                  index: widget.index,
                  songList: widget.songList,
                  audioPlayer: widget.audioPlayer,
                ));
      },
      child: Card(
        shape: null,
        elevation: 0,
        color: Color.fromARGB(255, 174, 255, 145),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              topRight: Radius.circular(50),
            ),
            color: Color.fromARGB(255, 137, 148, 150),
          ),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 50,
                width: 60,
                child: QueryArtworkWidget(
                  artworkBorder: BorderRadius.circular(10),
                  id: int.parse(widget.songList[widget.index].id),
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'lib/asset/playing image.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.songList[widget.index].songname,
                      style:
                          GoogleFonts.saira(color: Colors.black, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                    Text(widget.songList[widget.index].songartist,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Favourites.addSongToFavourites(
                    context: context,
                    id: widget.songList[widget.index].id,
                  );
                  setState(() {
                    Favourites.isThisFavourite(
                      id: widget.songList[widget.index].id,
                    );
                  });
                },
                icon: Icon(
                  Favourites.isThisFavourite(
                    id: widget.songList[widget.index].id,
                  ),
                  color: Colors.black,
                  size: 25,
                ),
              ),
              IconButton(
                  onPressed: () {
                    showPlaylistModalSheet(
                        context: context, song: widget.songList[widget.index]);
                  },
                  icon: const Icon(Icons.playlist_add))
            ],
          ),
        ),
      ),
    );
  }
}

showPlaylistModalSheet({
  required BuildContext context,
  required Songs song,
}) {
  Box<List> playlistBox = getPlaylistBox();
  return showModalBottomSheet(
      backgroundColor: const Color.fromARGB(0, 194, 28, 28),
      context: context,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 119, 182, 145),
            borderRadius: BorderRadius.circular(50),
          ),
          height: 800,
          child: Column(
            children: [
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  showCreatingPlaylistDialoge(context: ctx);
                },
                icon: const Icon(
                  Icons.playlist_add,
                  color: Colors.black,
                ),
                label: const Text(
                  'Create Playlist',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: const Color.fromARGB(255, 10, 141, 180),
                  shape: const StadiumBorder(),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: playlistBox.listenable(),
                  builder: (context, boxSongList, _) {
                    final List<dynamic> keys = playlistBox.keys.toList();

                    keys.removeWhere((key) => key == 'Favourites');
                    keys.removeWhere((key) => key == 'Recent');
                    keys.removeWhere((key) => key == 'Most Played');

                    return Expanded(
                      child: (keys.isEmpty)
                          ? const Center(
                              child: Text("No Playlist Found"),
                            )
                          : ListView.builder(
                              itemCount: keys.length,
                              itemBuilder: (ctx, index) {
                                final String playlistKey = keys[index];

                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    onTap: () async {
                                      UserPlaylist.addSongToPlaylist(
                                          context: context,
                                          songId: song.id,
                                          playlistName: playlistKey);

                                      Navigator.pop(context);
                                    },
                                    leading: const Text(
                                      '🎧',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    title: Text(playlistKey),
                                  ),
                                );
                              },
                            ),
                    );
                  })
            ],
          ),
        );
      });
}

showCreatingPlaylistDialoge({required BuildContext context}) {
  TextEditingController textEditingController = TextEditingController();
  Box<List> playlistBox = getPlaylistBox();

  Future<void> createNewplaylist() async {
    List<Songs> songList = [];
    final String playlistName = textEditingController.text.trim();
    if (playlistName.isEmpty) {
      return;
    }
    await playlistBox.put(playlistName, songList);
  }

  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final formKey = GlobalKey<FormState>();
        return Form(
          key: formKey,
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 119, 182, 145),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            title: const Text(
              'Create playlist',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            content: SearchField(
              textController: textEditingController,
              hintText: 'Playlist Name',
              icon: Icons.playlist_add,
              validator: (value) {
                final keys = getPlaylistBox().keys.toList();
                if (value == null || value.isEmpty) {
                  return 'Field is empty';
                }
                if (keys.contains(value)) {
                  return '$value Already exist in playlist';
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
                    await createNewplaylist();
                    Navigator.pop(ctx);
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

showPlaylistDeleteAlert({required BuildContext context, required String key}) {
  final playlistBox = getPlaylistBox();
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 243, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          title: const Text(
            'Confirm Deletion',
          ),
          content: const Text(
            'Do you want to delete this Playlist',
            style: TextStyle(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await playlistBox.delete(key);
                Navigator.pop(ctx);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      });
}

showSongModalSheet({
  required BuildContext context,
  required String playlistKey,
}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) {
      final songBox = getSongBox();
      return Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30),
        ),
        height: 400,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Add Songs',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: songBox.listenable(),
                builder:
                    (BuildContext context, Box<Songs> boxSongs, Widget? child) {
                  return ListView.builder(
                    itemCount: boxSongs.values.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      final List<Songs> songsList = boxSongs.values.toList();
                      final Songs song = songsList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: ListTile(
                          onTap: () {
                            UserPlaylist.addSongToPlaylist(
                              context: context,
                              songId: song.id,
                              playlistName: playlistKey,
                            );

                            Navigator.pop(context);
                          },
                          leading: QueryArtworkWidget(
                            id: int.parse(song.id),
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(10),
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'lib/asset/playing image.jpg',
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          title: Text(
                            song.songname,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
