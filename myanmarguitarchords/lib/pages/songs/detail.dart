import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myanmarguitarchords/models/authorModel.dart';
import 'package:myanmarguitarchords/models/songModel.dart';
import 'package:myanmarguitarchords/services/adState.dart';
import 'package:myanmarguitarchords/services/songServices.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SongPage extends StatefulWidget {
  final num songId;
  const SongPage({Key? key, required this.songId}) : super(key: key);

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

  // Ads
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

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

            InterstitialAd.load(
                adUnitId: adState.interstitialAd,
                request: AdRequest(),
                adLoadCallback: InterstitialAdLoadCallback(
                  onAdLoaded: (InterstitialAd ad) {
                    this.interstitialAd = ad;
                    if(adState.songCount >= int.parse(dotenv.env['SONG_LIMIT_INT']!))
                    {
                      interstitialAd!.show();
                      adState.songCount = 1;
                    } else {
                      adState.songCount = adState.songCount + 1;
                    }
                  },
                  onAdFailedToLoad: (LoadAdError error) {
                    print('InterstitialAd failed to load: $error');
                  },
                ));
          })
        });
  }

  void getSong(id) async {
    var data = await songService.getSong(id);
    setState(() {
      _song = data;
      _isLoading = false;
    });
  }

  void toggleFavorite() {
    if (_isFavorite) {
      _removeFavorite(this.songId);
    } else {
      _setFavorite(this.songId);
    }
  }

  void _setFavorite(id) async {
    var data = await songService.setFavorite(id);
    setState(() {
      _isFavorite = data;
    });
  }

  void _removeFavorite(id) async {
    var data = await songService.removeFavorite(id);
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
              toggleFavorite();
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
      bottomNavigationBar: Container(
        height: 50,
        child: bannerAd != null
            ? AdWidget(
                ad: bannerAd!,
              )
            : SizedBox(
                height: 50,
              ),
      ),
    );
  }
}
