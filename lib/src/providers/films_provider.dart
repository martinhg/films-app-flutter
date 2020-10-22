import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:films_app_flutter/src/models/film_model.dart';

class FilmsProviders {
  String _apikey = '54627095141dd281f37d67e270a7cd51';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  int _popularsPage = 0;
  bool _loading = false;

  List<Film> _populars = new List();

  final _popularsStreamController = StreamController<List<Film>>.broadcast();

  Function(List<Film>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Film>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Film>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final films = new Films.fromJsonList(decodedData['results']);

    return films.items;
  }

  Future<List<Film>> getInCinema() async {
    final url = Uri.https(_url, '/3/movie/now_playing',
        {'api_key': _apikey, 'language': _lenguage});
    return await _processResponse(url);
  }

  Future<List<Film>> getPopulars() async {
    if (_loading) return [];
    _loading = true;
    _popularsPage++;

    final url = Uri.https(_url, '/3/movie/popular', {
      'api_key': _apikey,
      'language': _lenguage,
      'page': _popularsPage.toString()
    });

    final response = await _processResponse(url);

    _populars.addAll(response);

    popularsSink(_populars);

    _loading = false;

    return response;
  }
}
