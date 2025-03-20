import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/utils/api_service.dart';
import 'package:pokedex/utils/local_storage.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:pokedex/widgets/search_bar.dart' as custom;
import 'dart:async';
import 'package:pokedex/screens/pokemon_detail_screen.dart';
import 'package:pokedex/widgets/rotating_pokemon_loader.dart';
import 'dart:math'; // 🔹 Agrega esta línea


class PokemonListScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  PokemonListScreen({required this.onThemeToggle});

  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _filteredPokemonList = [];
  Set<String> _favoritePokemon = {};
  String _selectedType = 'Todos';
  bool _showFavoritesOnly = false;
  bool _isLoading = false;
  bool _isGridView = true; // ✅ Estado para cambiar entre lista y cuadrícula
  final ScrollController _scrollController = ScrollController();
  final ScrollController _filterScrollController = ScrollController();
  final Map<String, Color> typeColors = {

    'electric': Colors.amber,
    'fire': Colors.red,
    'ground': Colors.brown,
    'water': Colors.blue,
    'grass': Colors.green,
    'normal': Colors.grey,
    'poison': Colors.purple,
    'flying': Colors.lightBlue,
    'bug': Colors.lightGreen,
    'rock': Colors.orange,
    'ghost': Colors.indigo,
    'dragon': Colors.deepPurple,
    'psychic': Colors.pink,
    'ice': Colors.cyan,
    'steel': Colors.blueGrey,
    'fighting': Colors.deepOrange,
    'fairy': Colors.pinkAccent,
  };

  @override
  void initState() {
    super.initState();
    _fetchAllPokemon();
    _loadFavorites();
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  String _sortOption = 'Número'; // Opción por defecto de orden

  Future<void> _fetchAllPokemon({String? query, String? type}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _pokemonList.clear(); // Limpiar la lista para una nueva carga
    });

    try {
      List<Pokemon> allPokemon = [];

      if (query != null && query.isNotEmpty) {
        final response = await ApiService.fetchPokemonByName(query);
        if (response != null) {
          allPokemon = [response];
        }
      } else if (type != null && type != "Todos") {
        allPokemon = await ApiService.fetchAllPokemonByType(type.toLowerCase());
      } else {
        allPokemon = await ApiService.fetchAllPokemon();
      }

      setState(() {
        _pokemonList = allPokemon;
        _applyFilters();
      });
    } catch (e) {
      print('Error al cargar Pokémon: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadFavorites() async {
    List<String> favorites = await LocalStorage.getFavorites();
    setState(() {
      _favoritePokemon = favorites.toSet();
    });
  }

  void _toggleFavorite(Pokemon pokemon) async {
    if (_favoritePokemon.contains(pokemon.name)) {
      _favoritePokemon.remove(pokemon.name);
      await LocalStorage.removeFavorite(pokemon.name);
    } else {
      _favoritePokemon.add(pokemon.name);
      await LocalStorage.saveFavorite(pokemon.name);

      Future.delayed(Duration(seconds: 3), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("¡${pokemon.name} ahora es tu favorito!")),
        );
      });
    }
    setState(() {});
  }

  void _applyFilters() {
    setState(() {
      _filteredPokemonList = _pokemonList.where((pokemon) {
        bool matchesType = _selectedType == 'Todos' || pokemon.types.contains(_selectedType.toLowerCase());
        bool matchesFavorites = !_showFavoritesOnly || _favoritePokemon.contains(pokemon.name);
        return matchesType && matchesFavorites;
      }).toList();

      _sortPokemonList(); // Ordenar después de aplicar los filtros
    });
  }

// 🔹 Función para ordenar la lista
  void _sortPokemonList() {
    setState(() {
      if (_sortOption == 'Número') {
        _filteredPokemonList.sort((a, b) => a.id.compareTo(b.id));
      } else if (_sortOption == 'Alfabéticamente') {
        _filteredPokemonList.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

// 🔹 Widget para el selector de orden
  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: _sortOption,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _sortOption = newValue;
            _sortPokemonList(); // Reordenar cuando cambia la selección
          });
        }
      },
      items: <String>['Número', 'Alfabéticamente']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }


  void _showRandomPokemon() {
    if (_filteredPokemonList.isEmpty) return;

    final random = Random();
    final randomPokemon = _filteredPokemonList[random.nextInt(_filteredPokemonList.length)];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonDetailScreen(pokemon: randomPokemon),
      ),
    );
  }

// 🔹 Agregar botón de Aleatorio en la AppBar
  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onThemeToggle,
          ),
          IconButton(
            icon: Icon(_showFavoritesOnly ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
                _applyFilters();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.shuffle), // Icono de aleatorio
            onPressed: _showRandomPokemon, // Llama a la función de aleatorio
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view), // 🔹 Botón para cambiar vista
            onPressed: _toggleView, // 🔹 Función para alternar vista
          ),
        ],
      ),
      body: Column(
        children: [
          custom.SearchBar(onSearch: (query) {
            _fetchAllPokemon(query: query);
          }),
          _buildSortDropdown(), // Menú desplegable de orden
          _buildTypeFilterButtons(), // Filtros de tipo
          Expanded(
            child: _isLoading
                ? Center(child: RotatingPokemonLoader()) // Mostrar Pokéball mientras carga
                : _isGridView
                ? GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWideScreen ? 3 : 2, // Ajusta la cantidad de columnas
                childAspectRatio: isWideScreen ? 1.2 : 1.0,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: _filteredPokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = _filteredPokemonList[index];
                final color = _getColorForTypes(pokemon.types);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                      ),
                    );
                  },
                  child: PokemonCard(
                    pokemon: pokemon,
                    isFavorite: _favoritePokemon.contains(pokemon.name),
                    onFavoriteToggle: () => _toggleFavorite(pokemon),
                    color: color,
                    showType: true,
                    showImage: true,
                  ),
                );
              },
            )
                : ListView.builder(
              controller: _scrollController,
              itemCount: _filteredPokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = _filteredPokemonList[index];
                final color = _getColorForTypes(pokemon.types);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                      ),
                    );
                  },
                  child: PokemonCard(
                    pokemon: pokemon,
                    isFavorite: _favoritePokemon.contains(pokemon.name),
                    onFavoriteToggle: () => _toggleFavorite(pokemon),
                    color: color,
                    showType: true,
                    showImage: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Color _getColorForTypes(List<String> types) {
    for (var type in types) {
      if (typeColors.containsKey(type.toLowerCase())) {
        return typeColors[type.toLowerCase()]!;
      }
    }
    return Colors.grey;
  }

  Widget _buildTypeFilterButtons() {
    List<String> types = ['Todos', ...typeColors.keys];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              _filterScrollController.animateTo(
                _filterScrollController.offset - 100, // Mueve hacia la izquierda
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _filterScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: types.map((type) {
                  bool isSelected = _selectedType == type;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = type;
                        if (type == 'Todos') {
                          _fetchAllPokemon();
                        } else {
                          _fetchAllPokemon(type: _selectedType);
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type[0].toUpperCase() + type.substring(1),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              _filterScrollController.animateTo(
                _filterScrollController.offset + 100, // Mueve hacia la derecha
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _filterScrollController.dispose();
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
