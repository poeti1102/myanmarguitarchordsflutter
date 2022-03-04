// ignore_for_file: file_names

class Album {
  late num id;
  late String album_name_en;
  late String album_name_mm;

  Album({
    this.id = 0,
    this.album_name_en = "Album",
    this.album_name_mm = "Album"
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as num,
      album_name_en: json['album_name_en'] as String,
      album_name_mm: json['album_name_mm'] as String,
    );
  }
}