// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myanmarguitarchords/models/albumModel.dart';

class AlbumList extends StatelessWidget {
  final Album album;
  final Function showSongs;

  const AlbumList({Key? key, required this.album, required this.showSongs})
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
          onTap: showSongs(),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.collections,
                  size: 48.0,
                ),
              ),
              Divider(
                thickness: 10,
              ),
              Text(
                "${album.album_name_mm}",
                style: TextStyle(
                    fontFamily: "Pyidaungsu",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
