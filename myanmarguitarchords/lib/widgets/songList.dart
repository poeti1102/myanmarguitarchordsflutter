// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myanmarguitarchords/models/songModel.dart';

class SongList extends StatelessWidget {
  final Song song;
  final Function goToDetail;

  const SongList({Key? key, required this.song, required this.goToDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 74),
              offset: Offset(2, 4),
              blurRadius: 0,
              spreadRadius: 0,
            )
          ],
        ),
        child: Material(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: InkWell(
            hoverColor: Colors.transparent,
            onTap: goToDetail(),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.library_music,
                    size: 36.0,
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("${song.song_name_mm}".length > 30 ? "${song.song_name_mm}".substring(0 ,30) + ".." : "${song.song_name_mm}",
                        style: TextStyle(
                            fontFamily: "Pyidaungsu",
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    Text(
                      song.singer.author_name_mm,
                      style: TextStyle(
                          fontFamily: "Pyidaungsu",
                          fontSize: 10.0,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
