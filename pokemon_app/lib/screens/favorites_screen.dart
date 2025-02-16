import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';

// Pantalla que muestra la lista de Pokémon favoritos
class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de la aplicación con el título
      appBar: AppBar(
        title: Text('Favorite Pokémon'),
      ),
      // Cuerpo de la pantalla que muestra la lista de Pokémon favoritos
      body: FutureBuilder<List<Pokemon>>(
        future: Provider.of<ApiService>(context, listen: false).fetchFavoritePokemons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fallo al cargar los datos'));
          } else {
            final pokemons = snapshot.data;
            // Muestra la lista de Pokémon en un GridView
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas en la cuadrícula
                childAspectRatio: 3 / 4, // Relación de aspecto de los elementos
              ),
              itemCount: pokemons?.length,
              itemBuilder: (context, index) {
                // Crea una tarjeta de Pokémon para cada elemento en la lista
                return PokemonCard(pokemon: pokemons![index]);
              },
            );
          }
        },
      ),
    );
  }
}