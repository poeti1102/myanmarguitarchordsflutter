import 'package:flutter/material.dart';
import 'package:myanmarguitarchords/models/songModel.dart';
import 'package:myanmarguitarchords/pages/songs/detail.dart';
import 'package:myanmarguitarchords/services/songServices.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myanmarguitarchords/widgets/sideMenu.dart';
import 'package:myanmarguitarchords/widgets/songList.dart';

class PopularSongsPage extends StatefulWidget {
  const PopularSongsPage({Key? key}) : super(key: key);

  @override
  _PopularSongsPageState createState() => _PopularSongsPageState();
}

class _PopularSongsPageState extends State<PopularSongsPage> {
  List<Song> songs = [];
  bool isLoading = true;

  final SongService songService = SongService();

  final spinkit = SpinKitFadingCube(
    color: Colors.black,
    size: 70.0,
  );

  void getSongs() async {
    var data = await songService.getPopularSongs();
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
        title: Text("Popular Songs"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[700],
      ),
      drawer: SideMenu(popularSongPage: true),
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
