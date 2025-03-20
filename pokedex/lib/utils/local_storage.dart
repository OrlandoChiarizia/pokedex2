import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _favoritesKey = 'favorite_pokemon';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<void> saveFavorite(String pokemonName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();
    if (!favorites.contains(pokemonName)) {
      favorites.add(pokemonName);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  static Future<void> removeFavorite(String pokemonName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();
    favorites.remove(pokemonName);
    await prefs.setStringList(_favoritesKey, favorites);
  }
}
