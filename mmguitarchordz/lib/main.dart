import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mmguitarchordz/pages/home/home.dart';
import 'package:mmguitarchordz/services/adState.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';


Future main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final adsFuture = MobileAds.instance.initialize();
  final adState = AdState(initialization: adsFuture);

  runApp(Provider.value(
    value: adState,
    builder: (context, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Myanmar Guitar Chords",
      home: UpgradeAlert(
        showReleaseNotes: false,
        child: HomePage()
        ),
    ),
  ));
}

