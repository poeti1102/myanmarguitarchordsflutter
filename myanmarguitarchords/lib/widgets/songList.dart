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
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 74),
            offset: Offset(0, 5),
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
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.library_music,
                  size: 48.0,
                ),
              ),
              Divider(
                thickness: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      "${song.song_name_mm}",
                      style: TextStyle(
                          fontFamily: "Pyidaungsu",
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    height: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      song.singer.author_name_mm,
                      style: TextStyle(
                          fontFamily: "Pyidaungsu",
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
