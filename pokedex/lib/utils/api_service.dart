import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokedex/models/pokemon.dart';

class ApiService {
  static Future<List<Pokemon>> fetchAllPokemon() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      List<Pokemon> pokemonList = [];

      for (var result in results) {
        final pokeResponse = await http.get(Uri.parse(result['url']));
        if (pokeResponse.statusCode == 200) {
          final pokeData = json.decode(pokeResponse.body);
          pokemonList.add(Pokemon.fromJson(pokeData));
        }
      }
      return pokemonList;
    } else {
      throw Exception('Error al cargar todos los Pokémon');
    }
  }

  static Future<List<Pokemon>> fetchAllPokemonByType(String type) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/type/$type'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> pokemonList = data['pokemon'];

      List<Pokemon> filteredPokemon = [];
      for (var entry in pokemonList) {
        final pokeResponse = await http.get(Uri.parse(entry['pokemon']['url']));
        if (pokeResponse.statusCode == 200) {
          final pokeData = json.decode(pokeResponse.body);
          filteredPokemon.add(Pokemon.fromJson(pokeData));
        }
      }
      return filteredPokemon;
    } else {
      throw Exception('Error al cargar Pokémon por tipo');
    }
  }

  static Future<Pokemon?> fetchPokemonByName(String name) async {
    print("🔍 Buscando Pokémon: $name");

    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));

    print("📡 Código de respuesta: ${response.statusCode}");

    if (response.statusCode == 200) {
      final pokeData = json.decode(response.body);
      print("✅ Datos recibidos: $pokeData");
      return Pokemon.fromJson(pokeData);
    } else {
      print("⚠️ Error: Pokémon no encontrado");
      return null;
    }
  }
}
