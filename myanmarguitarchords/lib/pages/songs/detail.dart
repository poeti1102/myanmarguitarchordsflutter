import 'package:flutter/material.dart';
import 'package:myanmarguitarchords/models/authorModel.dart';
import 'package:myanmarguitarchords/models/songModel.dart';
import 'package:myanmarguitarchords/services/songServices.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SongPage extends StatefulWidget {
  final num songId;
  const SongPage({Key? key , required this.songId}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState(songId: songId);
}

class _SongPageState extends State<SongPage> {
  num songId;
  _SongPageState({required this.songId});
  SongService songService = SongService();
  bool _isFavorite = false;
  bool _isLoading = true;
  Song _song = Song(singer: Author());

  final spinkit = SpinKitFadingCube(
    color: Colors.black,
    size: 70.0,
  );

  void getSong(id) async {
    var data = await songService.getSong(id);
    setState(() {
      _song = data;
      _isLoading = true;
    });
  }

  void toggleFavorite(id) async {
    var data = await songService.toggleFavorite(id);
    setState(() {
      _isFavorite = data;
    });
  }

  Future<void> isFavorite(id) async {
    var data = await songService.isFarovite(id);
    setState(() {
      _isFavorite = data;
    });
  }

  @override
  void initState() {
    isFavorite(songId);
    getSong(songId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Song"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[700],
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              toggleFavorite(_isFavorite);
            },
          )
        ],
      ),
      body: Visibility(
        visible: _isLoading,
        child: Container(
          child: spinkit,
        ),
        replacement: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16.0),
                child: PinchZoomImage(
                  image: Image.network(_song.file),
                  zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
