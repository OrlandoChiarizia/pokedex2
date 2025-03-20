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
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color, // Usamos el color proporcionado
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          if (showImage)
            Image.network(pokemon.imageUrl, height: 100),
          Text(pokemon.name, style: TextStyle(fontWeight: FontWeight.bold)),
          if (showType) Text(pokemon.types.join(', ')),
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}