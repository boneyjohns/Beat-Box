import 'package:beat_box/database/model/hive_model.dart';
import 'package:beat_box/screens/navigationpage/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../database/function/db_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Box<List> playlistBox = getPlaylistBox();
  Box<Songs> songBox = getSongBox();
  OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> deviceSongs = [];
  List<SongModel> fetchedSongs = [];
  @override
  void initState() {
    requestPermission();
    songfetchngfuction();
    gotohome();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  songfetchngfuction() async {
    deviceSongs = await audioQuery.querySongs(
      sortType: SongSortType.DISPLAY_NAME,
      orderType: OrderType.DESC_OR_GREATER,
      ignoreCase: true,
      uriType: UriType.EXTERNAL,
    );

    for (var song in deviceSongs) {
      if (song.fileExtension == 'm4a' || song.fileExtension == 'mp3') {
        fetchedSongs.add(song);
      }
    }

    for (var audio in fetchedSongs) {
      final song = Songs(
        id: audio.id.toString(),
        songname: audio.displayNameWOExt,
        path: audio.uri!,
        songartist: audio.artist!,
      );
      await songBox.put(song.id, song);
    }
    getFavSongs();
    getRecentSongs();
    getMostPlayedSongs();
  }

  Future<void> gotohome() async {
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const NavigationPage()));
  }

  Future getFavSongs() async {
    if (!playlistBox.keys.contains('Favourites')) {
      await playlistBox.put('Favourites', []);
    }
  }

  Future getRecentSongs() async {
    if (!playlistBox.keys.contains('Recent')) {
      await playlistBox.put('Recent', []);
    }
  }

  Future getMostPlayedSongs() async {
    if (!playlistBox.keys.contains('Most Played')) {
      await playlistBox.put('Most Played', []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Image(
        image: AssetImage(
          'lib/asset/screen1.jpg',
        ),
        fit: BoxFit.fitHeight,
        height: double.infinity,
      ),
    );
  }
}
