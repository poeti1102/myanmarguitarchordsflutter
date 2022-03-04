// ignore_for_file: file_names

class Author {
  late num id;
  late String author_name_en;
  late String author_name_mm;

  Author(
      {this.id = 0,
      this.author_name_en = "Singer",
      this.author_name_mm = "Singer"});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as num,
      author_name_en: json['author_name_en'] as String,
      author_name_mm: json['author_name_mm'] as String,
    );
  }
}
