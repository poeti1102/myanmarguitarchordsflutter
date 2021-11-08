// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myanmarguitarchords/pages/home/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({ Key? key }) : super(key: key);

  Widget MenuItem({
    required String name,
    required IconData icon,
    required VoidCallback? onClicked
  }) {
    final color = Colors.white;
    return ListTile(
      leading: Icon(icon , color : color),
      title: Text(name , style: TextStyle(color: color)),
      onTap: onClicked,
    );
  }

  void navigateTo(BuildContext context ,  page)
  {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page
      ));
  }

  void _launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: 16);
    final facebookMessengerLink = dotenv.env["MESSENGER_LINK"];
    return Drawer(
      child: Material(
        color: Colors.green[700],
        child: ListView(
          padding: padding,
          children: [
            // Menus
            SizedBox(height: 16),
            MenuItem(name: "Songs", icon: Icons.album,onClicked: () => navigateTo(context,HomePage())),
            // SizedBox(height: 16),
            // MenuItem(name: "Singers", icon: Icons.people),
            // SizedBox(height: 16),
            // MenuItem(name: "Albums", icon: Icons.collections),
            // SizedBox(height: 16),
            // MenuItem(name: "New Songs", icon: Icons.whatshot),
            // SizedBox(height: 16),
            // MenuItem(name: "Top Songs", icon: Icons.flash_on),
            // SizedBox(height: 16),
            // MenuItem(name: "Favorites", icon: Icons.favorite),

            // Divider
            SizedBox(height: 16),
            Divider(height: 3 ,),
            SizedBox(height: 16),

            // Facebook Page Link
            MenuItem(name: "သီချင်းတောင်းမည်", icon: Icons.help , onClicked: () => _launchURL(facebookMessengerLink) ),
          ],
        ),
      ),
    );
  }
}