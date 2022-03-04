import 'package:flutter/material.dart';
import 'package:mmguitarchordz/models/songModel.dart';
import 'package:mmguitarchordz/pages/songs/detail.dart';
import 'package:mmguitarchordz/services/adState.dart';
import 'package:mmguitarchordz/services/songServices.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmguitarchordz/widgets/sideMenu.dart';
import 'package:mmguitarchordz/widgets/songList.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

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
  bool isLoadingMore = false;
  bool canLoadMore = true;
  final SongService songService = SongService();

  // Ads
  BannerAd? bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AdState adState = Provider.of<AdState>(context);
    adState.initialization.then((status) => {
          setState(() {
            bannerAd = BannerAd(
                adUnitId: adState.bannerAdId,
                size: AdSize.banner,
                request: AdRequest(),
                listener: adState.bannerAdListener)
              ..load();
          })
        });
  }

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
      isLoadingMore = true;
      page = page + 1;
    });
    var data = await songService.getSongs(page);
    if (data.isEmpty) {
      setState(() {
        canLoadMore = false;
      });
    }
    setState(() {
      songs.addAll(data);
      isLoadingMore = false;
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
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Songs"),
    //     centerTitle: true,
    //     backgroundColor: Colors.greenAccent[700],
    //   ),
    //   drawer: SideMenu(homePage: true),
    //   body: Visibility(
    //     visible: isLoading,
    //     child: Container(
    //       child: spinkit,
    //     ),
    //     replacement: Container(
    //       margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
    //       child: Expanded(
    //         child: SingleChildScrollView(
    //           child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
    //                   child: TextField(
    //                     decoration: InputDecoration(
    //                       prefixIcon: Icon(Icons.search),
    //                       border: OutlineInputBorder(),
    //                       hintText: 'သီချင်းရှာမယ်',
    //                     ),
    //                     onSubmitted: (text) {
    //                       searchSongs(text);
    //                     },
    //                   ),
    //                 ),
    //                 Column(
    //                   children: songs
    //                       .map((song) => SongList(
    //                             song: song,
    //                             goToDetail: () => () {
    //                               Navigator.of(context).push(MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       SongPage(songId: song.id)));
    //                             },
    //                           ))
    //                       .toList(),
    //                 ),
    //                 if (!isSearching && canLoadMore)
    //                   SizedBox(
    //                     height: 48,
    //                     child: OutlinedButton(
    //                       child: isLoadingMore
    //                           ? CircularProgressIndicator()
    //                           : Text("Load More..."),
    //                       onPressed: () {
    //                         loadMoreSong();
    //                       },
    //                       style: OutlinedButton.styleFrom(
    //                         primary: Colors.black87,
    //                         shape: const RoundedRectangleBorder(
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(5)),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //               ]),
    //         ),
    //       ),
    //     ),
    //   ),
    //   bottomNavigationBar: Container(
    //     height: 50,
    //     child: bannerAd != null ? AdWidget(
    //       ad: bannerAd!,
    //     ) : SizedBox(height: 50,),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text("Songs"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[700],
        
      ),
      drawer: SideMenu(homePage: true),
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
                          contentPadding: const EdgeInsets.fromLTRB(2,8,2,8),
                        ),
                        onChanged: (text) {
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
                  if (!isSearching && canLoadMore)
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        child: isLoadingMore
                            ? CircularProgressIndicator()
                            : Text("Load More..."),
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
                    ),
                ]),
          ),
        ),
      ),
    );
  }
}
