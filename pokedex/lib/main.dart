import 'package:flutter/material.dart';
import 'package:pokedex/screens/pokemon_list_screen.dart';
import 'package:pokedex/theme.dart';

void main() {
  runApp(PokedexApp());
}

class PokedexApp extends StatefulWidget {
  @override
  _PokedexAppState createState() => _PokedexAppState();
}

class _PokedexAppState extends State<PokedexApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 🔹 Oculta el banner DEBUG
      title: 'Pokédex',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: PokemonListScreen(onThemeToggle: _toggleTheme),
    );
  }
}
