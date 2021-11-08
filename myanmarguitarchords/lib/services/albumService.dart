// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myanmarguitarchords/models/albumModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumService {
  final apiKey = dotenv.env["API_KEY"];

  List<Album> parseAlbums(String responseBody) {
    final data = jsonDecode(responseBody);
    return data.map<Album>((album) => Album.fromJson(album)).toList();
  }

  Future<List<Album>> getAlbums() async {
    http.Response response = await http.get(
        Uri.parse('${dotenv.env["APP_URL"]}/albums/list'),
        headers: {
          "Authorization": 'Bearer $apiKey',
          'Content-Type': 'text/plain',
        });

    if (response.statusCode == 200) {
      return parseAlbums(response.body);
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<Album>> searchAlbums(String searchTerm) async {
    http.Response response =
        await http.post(Uri.parse('${dotenv.env["APP_URL"]}/albums/search'),
            headers: {
              "Authorization": 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'searchTerm': searchTerm}));
    if (response.statusCode == 200) {
      if (searchTerm == "") {
        return parseAlbums(response.body);
      }
      final data = jsonDecode(response.body);
      return data.map<Album>((album) => Album.fromJson(album)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

}