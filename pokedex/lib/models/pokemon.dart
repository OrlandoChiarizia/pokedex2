class Pokemon {
  final int id; // Número en la Pokédex
  final String name;
  final String imageUrl;
  final String url;
  final List<String> types;
  final double weight;
  final double height;
  final Map<String, int> stats;

  Pokemon({
    required this.id, // Agregado el campo 'id'
    required this.name,
    required this.imageUrl,
    required this.url,
    required this.types,
    required this.weight,
    required this.height,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'], // Aquí asignamos el número de Pokédex
      name: json['name'],
      imageUrl: json['sprites']['front_default'] ?? '',
      url: json['id'].toString(),
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      weight: json['weight'] / 10, // Convertimos de hectogramos a kg
      height: json['height'] / 10, // Convertimos de decímetros a metros
      stats: {
        for (var stat in json['stats'])
          stat['stat']['name']: stat['base_stat'] as int,
      },
    );
  }
}
