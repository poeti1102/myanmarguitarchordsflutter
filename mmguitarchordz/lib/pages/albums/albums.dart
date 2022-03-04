import 'package:flutter/material.dart';
import 'package:mmguitarchordz/models/albumModel.dart';
import 'package:mmguitarchordz/pages/songs/songsByAlbum.dart';
import 'package:mmguitarchordz/pages/songs/songsByAuthor.dart';
import 'package:mmguitarchordz/services/albumService.dart';
import 'package:mmguitarchordz/services/authorService.dart';
import 'package:mmguitarchordz/widgets/albumList.dart';
import 'package:mmguitarchordz/widgets/authorList.dart';
import 'package:mmguitarchordz/widgets/sideMenu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key? key}) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List<Album> albums = [];
  bool isLoading = true;
  AlbumService albumServ = AlbumService();

  final spinkit = SpinKitFadingCube(
    color: Colors.black,
    size: 70.0,
  );

  void getAlbums() async {
    var data = await albumServ.getAlbums();
    setState(() {
      albums = data;
      isLoading = false;
    });
  }

  void searchAuthor(String searchTerm) async {
    var data = await albumServ.searchAlbums(searchTerm);
    setState(() {
      albums = data;
    });
  }

  @override
  void initState() {
    getAlbums();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[700],
      ),
      drawer: SideMenu(albumPage: true),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        hintText: 'Album ရှာမယ်',
                      ),
                      onSubmitted: (text) {
                        searchAuthor(text);
                      },
                    ),
                  ),
                  Column(
                    children: albums
                        .map((album) => AlbumList(
                              album: album,
                              showSongs: () => () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SongListByAlbumPage(album: album)));
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
