// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myanmarguitarchords/models/albumModel.dart';
import 'package:myanmarguitarchords/models/songModel.dart';
import 'package:myanmarguitarchords/pages/songs/detail.dart';
import 'package:myanmarguitarchords/services/songServices.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myanmarguitarchords/widgets/sideMenu.dart';
import 'package:myanmarguitarchords/widgets/songList.dart';

class SongListByAlbumPage extends StatefulWidget {
  final Album album;
  const SongListByAlbumPage({Key? key, required this.album})
      : super(key: key);

  @override
  _SongListByAlbumPageState createState() =>
      _SongListByAlbumPageState(album: album);
}

class _SongListByAlbumPageState extends State<SongListByAlbumPage> {
  _SongListByAlbumPageState({required this.album});
  List<Song> songs = [];
  late Album album;
  bool isLoading = true;
  final SongService songService = SongService();

  final spinkit = SpinKitFadingCube(
    color: Colors.black,
    size: 70.0,
  );

  void getSongs() async {
    var data = await songService.getSongsByAlbum(album.id);
    setState(() {
      songs = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Songs"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[700],
      ),
      body: Visibility(
        visible: isLoading,
        child: Container(
          child: spinkit,
        ),
        replacement: Container(
          margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: songs
                        .map((song) => SongList(
                              song: song,
                              goToDetail: () => () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SongPage(songId: song.id)));
                              },
                            ))
                        .toList(),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
