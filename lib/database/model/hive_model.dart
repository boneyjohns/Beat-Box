import 'package:hive/hive.dart';
part 'hive_model.g.dart';

@HiveType(typeId: 0)
class Songs extends HiveObject {
  @HiveField(0)
  String path;
  @HiveField(1)
  String id;

  @HiveField(2)
  String songname;

  @HiveField(3)
  String songartist;

  @HiveField(4)
  int count;

  Songs(
      {required this.path,
      required this.id,
      required this.songname,
      required this.songartist,
      this.count = 0});
}
