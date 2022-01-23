// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myanmarguitarchords/pages/albums/albums.dart';
import 'package:myanmarguitarchords/pages/authors/authors.dart';
import 'package:myanmarguitarchords/pages/home/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myanmarguitarchords/pages/songs/favorites.dart';
import 'package:myanmarguitarchords/pages/songs/newsongs.dart';
import 'package:myanmarguitarchords/pages/songs/popularsongs.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatelessWidget {
  bool homePage;
  bool authorPage;
  bool albumPage;
  bool favoritePage;
  bool newSongPage;
  bool popularSongPage;
  
  SideMenu({
    Key? key,
    this.homePage = false,
    this.authorPage = false,
    this.albumPage = false,
    this.favoritePage = false,
    this.newSongPage = false,
    this.popularSongPage = false
  }) : super(key: key);

  Widget MenuItem(
      {required String name,
      required IconData icon,
      required VoidCallback? onClicked,
      bool enabled = false}) {
    final color = Colors.white;
    return ListTile(
      selected: enabled,
      selectedTileColor: Colors.grey[500],
      leading: Icon(icon, color: color),
      title: Text(name, style: TextStyle(color: color)),
      onTap: onClicked,
    );
  }

  void navigateTo(BuildContext context, page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.fromLTRB(16,40,16,20);
    final facebookMessengerLink = dotenv.env["MESSENGER_LINK"];
    return Drawer(
      child: Material(
        color: Colors.green[700],
        child: ListView(
          padding: padding,
          children: [
            // Menus
            SizedBox(height: 16),
            MenuItem(
                name: "Songs",
                icon: Icons.album,
                onClicked: () => navigateTo(context, HomePage()),
                enabled: homePage),
            SizedBox(height: 16),
            MenuItem(
                name: "Singers",
                icon: Icons.people,
                onClicked: () => navigateTo(context, AuthorPage()),
                enabled: authorPage),
            SizedBox(height: 16),
            MenuItem(
                name: "Albums",
                icon: Icons.collections,
                onClicked: () => navigateTo(context, AlbumPage()),
                enabled: albumPage),
            SizedBox(height: 16),
            MenuItem(
                name: "New Songs",
                icon: Icons.whatshot,
                onClicked: () => navigateTo(context, NewSongsPage()),
                enabled: newSongPage),
            SizedBox(height: 16),
            MenuItem(
                name: "Popular Songs",
                icon: Icons.flash_on,
                onClicked: () => navigateTo(context, PopularSongsPage()),
                enabled: popularSongPage),
            SizedBox(height: 16),
            MenuItem(
                name: "Favorites",
                icon: Icons.favorite,
                onClicked: () => navigateTo(context, FavoriteSongsPage()),
                enabled: favoritePage),

            // Divider
            SizedBox(height: 16),
            Divider(
              height: 3,
            ),
            SizedBox(height: 16),

            // Facebook Page Link
            MenuItem(
                name: "သီချင်းတောင်းမည်",
                icon: Icons.help,
                onClicked: () => _launchURL(facebookMessengerLink)),
          ],
        ),
      ),
    );
  }
}
