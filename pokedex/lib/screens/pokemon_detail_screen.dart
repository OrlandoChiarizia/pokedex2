import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  PokemonDetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    // Detectamos el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculamos el ancho de la tarjeta en función del tamaño de la pantalla
    final cardWidth = screenWidth > 600 ? 500 : screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name.toUpperCase()),
        backgroundColor: Colors.blue, // Barra superior azul
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen del Pokémon
            Center(
              child: Image.network(
                pokemon.imageUrl,
                height: 200, // Tamaño de la imagen
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 4), // Espacio reducido al mínimo

            // Tarjeta con detalles del Pokémon
            Expanded(
              child: Center(
                child: _buildDetailsCard(cardWidth.toDouble()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir la tarjeta con efecto hover
  Widget _buildDetailsCard(double cardWidth) {
    return MouseRegion(
      onEnter: (event) {},
      onExit: (event) {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.05), // Escala ligeramente al pasar el mouse
        child: Card(
          elevation: 8, // Sombreado
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bordes redondeados
          ),
          child: Container(
            width: cardWidth, // Ancho dinámico basado en el tamaño de la pantalla
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
              children: [
                Text(
                  "${pokemon.name.toUpperCase()}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Texto más pequeño
                ),
                SizedBox(height: 8), // Espaciado interno
                Text("Tipo(s): ${pokemon.types.join(', ')}", style: TextStyle(fontSize: 14)), // Texto más pequeño
                Text("Peso: ${pokemon.weight} kg", style: TextStyle(fontSize: 14)), // Texto más pequeño
                Text("Altura: ${pokemon.height} m", style: TextStyle(fontSize: 14)), // Texto más pequeño
                SizedBox(height: 8), // Espaciado interno
                Text("Estadísticas:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Título de estadísticas
                ...pokemon.stats.entries.map(
                      (stat) => Text("${stat.key}: ${stat.value}", style: TextStyle(fontSize: 14)), // Texto más pequeño
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}