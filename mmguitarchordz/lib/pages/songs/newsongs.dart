import 'package:flutter/material.dart';
import 'package:mmguitarchordz/models/songModel.dart';
import 'package:mmguitarchordz/pages/songs/detail.dart';
import 'package:mmguitarchordz/services/songServices.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmguitarchordz/widgets/sideMenu.dart';
import 'package:mmguitarchordz/widgets/songList.dart';

class NewSongsPage extends StatefulWidget {
  const NewSongsPage({Key? key}) : super(key: key);

  @override
  _NewSongsPageState createState() => _NewSongsPageState();
}

class _NewSongsPageState extends State<NewSongsPage> {
  List<Song> songs = [];
  bool isLoading = true;

  final SongService songService = SongService();

  final spinkit = SpinKitFadingCube(
    color: Colors.black,
    size: 70.0,
  );

  void getSongs() async {
    var data = await songService.getNewSongs();
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
        title: Text("New Songs"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[700],
      ),
      drawer: SideMenu(newSongPage: true),
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
