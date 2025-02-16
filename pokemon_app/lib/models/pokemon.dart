// Clase que representa un Pokémon
class Pokemon {
  final int? id;
  final String name;
  final String image;
  final String color;

  Pokemon({
    this.id,
    required this.name,
    required this.image,
    required this.color,
  });

  // Método de fábrica para crear una instancia de Pokemon a partir de un JSON
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int?,
      name: json['name'],
      image: json['image'],
      color: json['color'],
    );
  }
}
