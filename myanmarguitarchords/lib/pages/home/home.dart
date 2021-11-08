import 'package:flutter/material.dart';
import 'package:myanmarguitarchords/models/songModel.dart';
import 'package:myanmarguitarchords/pages/songs/detail.dart';
import 'package:myanmarguitarchords/services/songServices.dart';
import 'package:myanmarguitarchords/widgets/searchWidget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myanmarguitarchords/widgets/sideMenu.dart';
import 'package:myanmarguitarchords/widgets/songList.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> songs = [];
  num page = 1;
  bool isSearching = false;
  bool isLoading = true;
  final SongService songService = SongService();

  final spinkit = SpinKitFadingCube(
    color: Colors.black,
    size: 70.0,
  );

  void getSongs(num pageNumber) async {
    var data = await songService.getSongs(pageNumber);
    setState(() {
      songs = data;
      isLoading = false;
    });
  }

  void loadMoreSong() async {
    setState(() {
      page = page + 1;
    });
    var data = await songService.getSongs(page);
    setState(() {
      songs.addAll(data);
    });
  }

  void searchSongs(String searchTerm) async {
    if (searchTerm == "") {
      isSearching = false;
    } else {
      isSearching = true;
    }
    var data = await songService.searchSongs(searchTerm);
    setState(() {
      songs = data;
    });
  }

  @override
  void initState() {
    getSongs(1);
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
      drawer: SideMenu(),
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
                        hintText: 'သီချင်းရှာမယ်',
                      ),
                      onSubmitted: (text) {
                        searchSongs(text);
                      },
                    ),
                  ),
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
                  if (!isSearching)
                    OutlinedButton(
                      child: Text("Load More"),
                      onPressed: () {
                        loadMoreSong();
                      },
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black87,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                ]),
          ),
        ),
      ),
    );
  }
}
