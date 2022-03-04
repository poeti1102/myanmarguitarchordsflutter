// ignore_for_file: file_names

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AdState {
  Future<InitializationStatus> initialization;
  num _songCount = 1;

  AdState({required this.initialization});
  String get bannerAdId => dotenv.env["ADMOB_BANNER_ID"]!;
  String get interstitialAd => dotenv.env["ADMOB_INTERISTIAL_ID"]!;
  String get rewardAd => dotenv.env["ADMOB_REWARDINT_ID"]!;
  num get songCount => _songCount;
  set songCount(num count) => _songCount = count;

  BannerAdListener get bannerAdListener => _bannerAdListener;

  final BannerAdListener _bannerAdListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
}