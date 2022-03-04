// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mmguitarchordz/models/authorModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorService {
  final apiKey = dotenv.env["API_KEY"];

  List<Author> parseAuthors(String responseBody) {
    final data = jsonDecode(responseBody);
    return data.map<Author>((author) => Author.fromJson(author)).toList();
  }

  Future<List<Author>> getAuthors() async {
    http.Response response = await http.get(
        Uri.parse('${dotenv.env["APP_URL"]}/authors/list'),
        headers: {
          "Authorization": 'Bearer $apiKey',
          'Content-Type': 'text/plain',
        });
    if (response.statusCode == 200) {
      return parseAuthors(response.body);
    } else {
      throw Exception('Failed to load authors');
    }
  }

  Future<List<Author>> searchAuthors(String searchTerm) async {
    http.Response response =
        await http.post(Uri.parse('${dotenv.env["APP_URL"]}/authors/search'),
            headers: {
              "Authorization": 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'searchTerm': searchTerm}));
    if (response.statusCode == 200) {
      if (searchTerm == "") {
        return parseAuthors(response.body);
      }
      final data = jsonDecode(response.body);
      return data.map<Author>((author) => Author.fromJson(author)).toList();
    } else {
      throw Exception('Failed to load authors');
    }
  }

}