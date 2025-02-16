import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';

// Pantalla que muestra la lista de Pokémon
class PokemonListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon List'),
      ),
      // Cuerpo de la pantalla que muestra la lista de Pokémon
      body: FutureBuilder<List<Pokemon>>(
        // Llama al método fetchPokemons() para obtener la lista de Pokémon
        future: Provider.of<ApiService>(context, listen: false).fetchPokemons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fallo al cargar el listado de Pokémon'));
          } else {
            final pokemons = snapshot.data;
            // Muestra la lista de Pokémon en un GridView
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
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