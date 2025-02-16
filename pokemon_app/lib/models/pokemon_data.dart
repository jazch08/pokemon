// Clase que representa los datos de un Pokémon
class PokemonData {
  final String name;
  final int id;
  final String image;
  final List<String> types;
  final List<String> abilities;
  final List<Stat> stats;
  final List<Evolution> evolutionChain;
  final String color;

  // Constructor de la clase PokemonData
  PokemonData({
    required this.name,
    required this.id,
    required this.image,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.evolutionChain,
    required this.color, 
  });

  // Método de fábrica para crear una instancia de PokemonData a partir de un JSON
  factory PokemonData.fromJson(Map<String, dynamic> json) {
    return PokemonData(
      name: json['name'],
      id: json['id'],
      image: json['image'],
      types: List<String>.from(json['types']),
      abilities: List<String>.from(json['abilities']),
      stats: (json['stats'] as List).map((stat) => Stat.fromJson(stat)).toList(),
      evolutionChain: (json['evolution_chain'] as List).map((evolution) => Evolution.fromJson(evolution)).toList(),
      color: json['color'], // Añadido el campo color
    );
  }
}

// Clase que representa las estadísticas de un Pokémon
class Stat {
  final String name;
  final int baseStat;

  // Constructor de la clase Stat
  Stat({
    required this.name,
    required this.baseStat,
  });

  // Método de fábrica para crear una instancia de Stat a partir de un JSON
  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      name: json['name'],
      baseStat: json['base_stat'],
    );
  }
}

// Clase que representa una evolución de un Pokémon
class Evolution {
  final String name;
  final int id;
  final String image;
  final String color;

  // Constructor de la clase Evolution
  Evolution({
    required this.name,
    required this.id,
    required this.image,
    required this.color,
  });

  // Método de fábrica para crear una instancia de Evolution a partir de un JSON
  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(
      name: json['name'],
      id: json['id'],
      image: json['image'],
      color: json['color'],
    );
  }
}