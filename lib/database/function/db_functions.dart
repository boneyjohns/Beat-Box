import 'package:beat_box/database/model/hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

Box<Songs> getSongBox() {
  return Hive.box<Songs>('Songs');
}

Box<List> getPlaylistBox() {
  return Hive.box<List>('Playlist');
}
