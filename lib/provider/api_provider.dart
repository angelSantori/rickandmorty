import 'package:flutter/material.dart';
import 'package:ricknmorty/models/character_model.dart';
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  final _baseUrl = 'https://rickandmortyapi.com';
  List<Character> characters = [];

  Future<void> getCharacters() async {
    final result = await http.get(Uri.parse("$_baseUrl/api/character"));
    final response = characterResponseFromJson(result.body);
    characters.addAll(response.results!);
    notifyListeners();
  }
}
