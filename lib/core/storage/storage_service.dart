import 'dart:convert';

import 'package:movies_app/features/movies/model/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';

  Future<void> init() async {
    await SharedPreferences.getInstance();
  }

  Future<List<MovieModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    return favoritesJson
        .map((json) => MovieModel.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addFavorite(MovieModel movie) async {
    await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.any((m) => m.id == movie.id)) {
      favorites.add(movie);
      await _saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(MovieModel movie) async {
    await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.removeWhere((m) => m.id == movie.id);
    await _saveFavorites(favorites);
  }

  Future<void> _saveFavorites(List<MovieModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson =
        favorites.map((movie) => jsonEncode(movie.toJson())).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }
}
