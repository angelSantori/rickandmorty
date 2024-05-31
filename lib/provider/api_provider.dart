import 'package:flutter/material.dart';
import 'package:ricknmorty/models/character_model.dart';
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  final _baseUrl = 'rickandmortyapi.com';
  List<Character> characters = [];

  Future<void> getCharacters(int page) async {
    final result = await http.get(Uri.https(_baseUrl, "/api/character", {
      'page': page.toString(),
    }));
    final response = characterResponseFromJson(result.body);
    characters.addAll(response.results!);
    notifyListeners();
  }
}
