// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:myanmarguitarchords/models/songModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';

class SongService {
  final apiKey = dotenv.env["API_KEY"];
  final LocalStorage storage = new LocalStorage('myanmarguitarchords');

  List<Song> parseSongs(String responseBody) {
    final data = jsonDecode(responseBody);
    final parsed = data['data'].cast<Map<String, dynamic>>();
    return parsed.map<Song>((song) => Song.fromJson(song)).toList();
  }

  List<Song> parseNormalSongs(String responseBody) {
    final data = jsonDecode(responseBody);
      return data.map<Song>((song) => Song.fromJson(song)).toList();
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

  Future<List<Song>> getFavoriteSongs() async {
    String favoriteSongs = storage.getItem("favoriteList") ?? "";
    List songs = favoriteSongs == "" ? [] : jsonDecode(favoriteSongs);
    http.Response response =
        await http.post(Uri.parse('${dotenv.env["APP_URL"]}/songs/getFavorites'),
            headers: {
              "Authorization": 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'ids': songs}));
    if (response.statusCode == 200) {
      return parseNormalSongs(response.body);
    } else {
      throw Exception('Failed to load songs');
    }
  }

  Future<List<Song>> getNewSongs() async {
    http.Response response =
        await http.get(Uri.parse('${dotenv.env["APP_URL"]}/songs/getNewSongs'),
            headers: {
              "Authorization": 'Bearer $apiKey',
              'Content-Type': 'application/json',
            });
    if (response.statusCode == 200) {
      return parseNormalSongs(response.body);
    } else {
      throw Exception('Failed to load songs');
    }
  }

  Future<List<Song>> getPopularSongs() async {
    http.Response response =
        await http.get(Uri.parse('${dotenv.env["APP_URL"]}/songs/getPopular'),
            headers: {
              "Authorization": 'Bearer $apiKey',
              'Content-Type': 'application/json',
            });
    if (response.statusCode == 200) {
      return parseNormalSongs(response.body);
    } else {
      throw Exception('Failed to load songs');
    }
  }

  Future<List<Song>> getSongsByAuthor(id) async {
    http.Response response =
        await http.get(Uri.parse('${dotenv.env["APP_URL"]}/songs/getSongsByAuthor/$id'),
            headers: {
              "Authorization": 'Bearer $apiKey',
              'Content-Type': 'application/json',
            });
    if (response.statusCode == 200) {
      return parseNormalSongs(response.body);
    } else {
      throw Exception('Failed to load songs');
    }
  }

  Future<List<Song>> getSongsByAlbum(id) async {
    http.Response response =
        await http.get(Uri.parse('${dotenv.env["APP_URL"]}/songs/getSongsByAlbum/$id'),
            headers: {
              "Authorization": 'Bearer $apiKey',
              'Content-Type': 'application/json',
            });
    if (response.statusCode == 200) {
      return parseNormalSongs(response.body);
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
    String favoriteSongs = storage.getItem("favoriteList") ?? "";
    List songs = favoriteSongs == "" ? [] : jsonDecode(favoriteSongs);
    print(favoriteSongs);
    return songs.contains(id);
  }

  Future<bool> setFavorite(id) async {
    String favoriteSongs = storage.getItem("favoriteList") ?? "";
    List songs = favoriteSongs == "" ? [] : jsonDecode(favoriteSongs);
    songs.add(id);
    print(id);
    storage.setItem('favoriteList', jsonEncode(songs));
    return songs.contains(id);
  }

  Future<bool> removeFavorite(id) async {
    String favoriteSongs = storage.getItem("favoriteList") ?? "";
    List songs = jsonDecode(favoriteSongs);
    songs.remove(id);
    print(id);
    storage.setItem('favoriteList', jsonEncode(songs));
    return songs.contains(id);
  }
}
