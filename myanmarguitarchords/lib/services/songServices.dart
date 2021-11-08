// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:myanmarguitarchords/models/songModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongService {
  final apiKey = dotenv.env["API_KEY"];

  List<Song> parseSongs(String responseBody) {
    final data = jsonDecode(responseBody);
    final parsed = data['data'].cast<Map<String, dynamic>>();
    return parsed.map<Song>((song) => Song.fromJson(song)).toList();
  }

  Future<List<Song>> getSongs(num page) async {
    http.Response response = await http.get(
        Uri.parse('${dotenv.env["APP_URL"]}/songs/list?page=$page'),
        headers: {
          "Authorization": 'Bearer $apiKey',
          'Content-Type': 'text/plain',
        });

    if (response.statusCode == 200) {
      return parseSongs(response.body);
    } else {
      throw Exception('Failed to load songs');
    }
  }

  Future<Song> getSong(num songId) async {
    http.Response response = await http
        .get(Uri.parse('${dotenv.env["APP_URL"]}/songs/get/$songId'), headers: {
      "Authorization": 'Bearer $apiKey',
      'Content-Type': 'text/plain',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Song.fromJson(data);
    } else {
      throw Exception('Failed to load song');
    }
  }

  Future<List<Song>> searchSongs(String searchTerm) async {
    http.Response response =
        await http.post(Uri.parse('${dotenv.env["APP_URL"]}/songs/search'),
            headers: {
              "Authorization": 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'searchTerm': searchTerm}));
    if (response.statusCode == 200) {
      if (searchTerm == "") {
        return parseSongs(response.body);
      }
      final data = jsonDecode(response.body);
      return data.map<Song>((song) => Song.fromJson(song)).toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }

  Future<bool> isFarovite(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favoriteSongs = prefs.getString("favoriteList") ?? "";
    List songs = jsonDecode(favoriteSongs);
    return songs.contains(id) ? true : false;
  }

  Future<bool> toggleFavorite(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favoriteSongs = prefs.getString("favoriteList") ?? "";
    List songs = jsonDecode(favoriteSongs);
    if (songs.contains(id)) {
      songs.remove(id);
      prefs.setString('favoriteList', jsonEncode(songs));
      return false;
    } else {
      songs.add(id);
      prefs.setString('favoriteList', jsonEncode(songs));
      return true;
    }
  }
}
