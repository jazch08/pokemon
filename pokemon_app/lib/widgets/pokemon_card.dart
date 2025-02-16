import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../screens/pokemon_detail_screen.dart';

// Widget que representa una tarjeta de Pokémon
class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navega a la pantalla de detalles del Pokémon al tocar la tarjeta
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailScreen(pokemonName: pokemon.name),
          ),
        );
      },
      child: Container(
        // Estilo de la tarjeta
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _getColorFromName(pokemon.color), width: 4),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            // Imagen del Pokémon
            Expanded(
              child: Image.network(
                pokemon.image,
                fit: BoxFit.cover,
              ),
            ),
            // Nombre del Pokémon con fondo de color
            Container(
              width: double.infinity,
              color: _getColorFromName(pokemon.color),
              padding: EdgeInsets.all(8),
              child: Text(
                pokemon.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para obtener el color basado en el nombre del color
  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'brown':
        return Colors.brown;
      case 'black':
        return Colors.black;
      case 'white':
        return const Color.fromARGB(255, 190, 190, 190);
      case 'gray':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}