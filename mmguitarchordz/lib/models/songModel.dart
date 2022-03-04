// ignore_for_file: file_names

import 'package:mmguitarchordz/models/authorModel.dart';

class Song {
    late num id;
    late String song_name_mm;
    late String song_name_en;
    late num view_count;
    late String file;
    late bool is_new;
    late bool is_popular;
    late Author singer;
    // late Map<String,dynamic> album;

    Song({
      this.id = 0,
      this.song_name_mm = "Track 1",
      this.song_name_en = "Track 2",
      this.view_count = 0,
      this.file = "test.jng",
      this.is_new = false,
      this.is_popular = false,
      required this.singer,
      // required this.album,
    });

    factory Song.fromJson(Map<String, dynamic> json) {
      return Song(
        id : json['id'] as num,
        song_name_mm : json['song_name_mm'] as String,
        song_name_en : json['song_name_en'] as String,
        view_count : json['view_count'] as num,
        file : json['file'] as String,
        is_new : json['is_new'] as bool,
        is_popular : json['is_popular'] as bool,
        singer : json['author'] != null ? Author.fromJson(json['author']) : Author(),
        // album : json['album'] as Map<String,dynamic>,
      );
    }
}