import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:beat_box/database/model/hive_model.dart';
import 'package:beat_box/functions/favorate_function.dart';

import 'package:beat_box/functions/recentsongs.dart';
import 'package:beat_box/screens/now_playing/nowplaying.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class Miniplayer extends StatefulWidget {
  Miniplayer({
    super.key,
    required this.songList,
    required this.index,
    required this.audioPlayer,
  });
  final List<Songs> songList;
  int index;
  final AssetsAudioPlayer audioPlayer;

  @override
  State<Miniplayer> createState() => _MiniplayerState();
}

class _MiniplayerState extends State<Miniplayer> {
  List<Audio> songAudio = [];

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) {
      return element.path == fromPath;
    });
  }

  void convertSongMode() {
    for (var song in widget.songList) {
      songAudio.add(
        Audio.file(
          song.path,
          metas: Metas(
            id: song.id.toString(),
            title: song.songname,
            artist: song.songartist,
          ),
        ),
      );
    }
  }

  Future<void> openAudioPLayer() async {
    convertSongMode();

    await widget.audioPlayer.open(
      Playlist(
        audios: songAudio,
        startIndex: widget.index,
      ),
      autoStart: true,
      showNotification: true,
      loopMode: LoopMode.playlist,
      playInBackground: PlayInBackground.enabled,
    );
  }

  @override
  void initState() {
    openAudioPLayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.audioPlayer.builderCurrent(builder: (context, playing) {
      final myAudio = find(songAudio, playing.audio.assetAudioPath);
      Recents.addSongsToRecents(songId: widget.songList[widget.index].id);
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Color.fromARGB(255, 10, 141, 180),
        ),
        height: 90,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => Nowplaying(
                  audioPlayer: widget.audioPlayer,
                  id: myAudio.metas.id!,
                  index: widget.index,
                  songaudio: songAudio),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: QueryArtworkWidget(
                  artworkBorder: BorderRadius.circular(10),
                  id: int.parse(widget.songList[widget.index].id),
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'lib/asset/mini.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    child: widget.audioPlayer.builderCurrent(
                        builder: (context, playing) {
                      return Text(
                        widget.audioPlayer.getCurrentAudioTitle,
                        style: GoogleFonts.parisienne(
                            color: Color.fromARGB(255, 15, 15, 15),
                            fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      );
                    }),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PlayerBuilder.isPlaying(
                            player: widget.audioPlayer,
                            builder: (context, isPlaying) {
                              return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.audioPlayer.previous();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.skip_previous,
                                    color: Colors.white,
                                  ));
                            }),
                        PlayerBuilder.isPlaying(
                            player: widget.audioPlayer,
                            builder: (context, isPlaying) {
                              return IconButton(
                                onPressed: () {
                                  if (isPlaying == false) {
                                    widget.audioPlayer.play();
                                    setState(() {
                                      isPlaying = true;
                                    });
                                  } else if (isPlaying == true) {
                                    widget.audioPlayer.pause();
                                    setState(() {
                                      isPlaying = false;
                                    });
                                  }
                                },
                                icon: isPlaying
                                    ? Icon(
                                        Icons.pause_rounded,
                                      )
                                    : Icon(
                                        Icons.play_arrow_rounded,
                                      ),
                              );
                            }),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.audioPlayer.next();
                              });
                            },
                            icon: Icon(Icons.skip_next, color: Colors.white)),
                      ],
                    ),
                  )
                ],
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
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      );
    });
  }
}
