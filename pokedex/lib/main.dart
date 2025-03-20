import 'package:flutter/material.dart';
import 'package:pokedex/screens/pokemon_list_screen.dart';
import 'package:pokedex/theme.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatefulWidget {
  const PokedexApp({Key? key}) : super(key: key);

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
      theme: ThemeData(
        fontFamily: 'Kanit-Thin', // 🔹 Fuente global
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontFamily: 'Kanit-Thin'),
          bodyMedium: TextStyle(fontSize: 16, fontFamily: 'Kanit-Thin'),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontFamily: 'Kanit-Thin'),
          bodyMedium: TextStyle(fontSize: 16, fontFamily: 'Kanit-Thin'),
        ),
      ),
      themeMode: _themeMode,
      home: PokemonListScreen(onThemeToggle: _toggleTheme),
    );
  }
}
