import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  PokemonDetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? 500 : screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.name.toUpperCase(),
          style: TextStyle(fontFamily: 'Kanit-Thin'),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.network(
                pokemon.imageUrl,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 4),
            Expanded(
              child: Center(
                child: _buildDetailsCard(context, cardWidth.toDouble()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, double cardWidth) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[300] : Colors.white; // Fondo gris claro en modo oscuro

    return MouseRegion(
      onEnter: (event) {},
      onExit: (event) {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.05),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: backgroundColor, // Aplica el color de fondo dinámico
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${pokemon.name.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit-Thin',
                    color: Colors.black, // Texto oscuro para mayor contraste
                  ),
                ),
                SizedBox(height: 8),
                Text("Tipo(s): ${pokemon.types.join(', ')}", style: _detailTextStyle()),
                Text("Peso: ${pokemon.weight} kg", style: _detailTextStyle()),
                Text("Altura: ${pokemon.height} m", style: _detailTextStyle()),
                SizedBox(height: 8),
                Text(
                  "Estadísticas:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit-Thin',
                    color: Colors.black, // Asegura visibilidad en fondo claro
                  ),
                ),
                ...pokemon.stats.entries.map(
                      (stat) => Text("${stat.key}: ${stat.value}", style: _detailTextStyle()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _detailTextStyle() {
    return TextStyle(fontSize: 14, fontFamily: 'Kanit-Thin', color: Colors.black);
  }
}
