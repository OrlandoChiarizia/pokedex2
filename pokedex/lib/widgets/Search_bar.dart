import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _clearSearch() {
    _controller.clear();
    widget.onSearch('');
    setState(() {}); // Actualiza la UI
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Buscar Pokémon',
          hintText: 'Ejemplo: Pikachu',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Colors.grey),
            onPressed: _clearSearch,
          )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onChanged: (query) {
          widget.onSearch(query);
          setState(() {}); // Refresca el estado para mostrar/ocultar el botón de limpiar
        },
      ),
    );
  }
}
