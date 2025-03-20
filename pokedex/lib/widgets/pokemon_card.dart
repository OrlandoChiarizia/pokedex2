import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final Color color;
  final bool showType;
  final bool showImage;

  const PokemonCard({
    Key? key,
    required this.pokemon,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.color,
    this.showType = false,
    this.showImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 200;
    final isListView = MediaQuery.of(context).size.width < 200; // Detecta lista o cuadrícula

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isListView ? 8 : 8,  // 🔹 Más espacio entre tarjetas en lista
        horizontal: 8,  // 🔹 Espacio lateral en ambas vistas
      ),
      padding: EdgeInsets.all(isListView ? 8 : 12), // 🔹 Ajusta padding según la vista
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isListView
          ? Row( // 🔹 Diseño en fila para lista
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showImage)
            SizedBox(
              width: 50,
              height: 50,
              child: Image.network(pokemon.imageUrl),
            ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (showType)
                  Text(
                    pokemon.types.join(", "),
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: onFavoriteToggle,
          ),
        ],
      )
          : Column( // 🔹 Diseño en columna para cuadrícula
        children: [
          if (showImage)
            Image.network(pokemon.imageUrl, height: 80), // 🔹 Imagen más grande en cuadrícula
          Text(
            pokemon.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          if (showType)
            Text(
              pokemon.types.join(', '),
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}
