import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/pokemon_data.dart';
import '../services/api_service.dart';

// Clase principal de la pantalla de detalles del Pokémon
class PokemonDetailScreen extends StatefulWidget {
  final String pokemonName;

  PokemonDetailScreen({required this.pokemonName});

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> with SingleTickerProviderStateMixin {
  late Future<PokemonData> _pokemonDetail;
  bool _isEvolving = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Obtiene los detalles del Pokémon al iniciar la pantalla
    _pokemonDetail = Provider.of<ApiService>(context, listen: false).fetchPokemonDetail(widget.pokemonName);
    // Inicializa el controlador de animación
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    // Configura la animación con una curva de entrada y salida suave
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    // Libera los recursos del controlador de animación cuando se destruye el widget
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PokemonData>(
        future: _pokemonDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si ocurre un problema al obtener los datos
            return Center(child: Text('Fallo el cargar los datos'));
          } else if (snapshot.hasData) {
            final pokemon = snapshot.data!;
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            color: _getColorFromName(pokemon.color),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 40),
                                // Muestra el nombre del Pokémon
                                Text(
                                  pokemon.name,
                                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                // Muestra el ID del Pokémon
                                Text(
                                  '#${pokemon.id.toString().padLeft(3, '0')}',
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                                Spacer(),
                                // Muestra la imagen del Pokémon
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Image.network(pokemon.image, height: 200, width: 200),
                                ),
                                SizedBox(height: 8),
                                // Botones de favorito y evolución
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.favorite, color: Colors.red, size: 36),
                                      onPressed: () async {
                                        try {
                                          await Provider.of<ApiService>(context, listen: false).addFavorite(pokemon);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Añadido a favoritos')),
                                          );
                                        } catch (e) {
                                          final errorMessage = e.toString();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(errorMessage.contains('Pokemon ya está en favoritos') ? 'Pokemon ya está en favoritos' : 'Failed to add to favorites')),
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.upgrade, color: Colors.blue, size: 36),
                                      onPressed: () async {
                                        setState(() {
                                          _isEvolving = true;
                                        });
                                        _controller.forward(from: 0.0);
                                        try {
                                          final evolvedPokemon = await Provider.of<ApiService>(context, listen: false).evolvePokemon(pokemon.name);
                                          setState(() {
                                            _isEvolving = false;
                                          });
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PokemonDetailScreen(pokemonName: evolvedPokemon.name),
                                            ),
                                          );
                                        } catch (e) {
                                          setState(() {
                                            _isEvolving = false;
                                          });
                                          final errorMessage = e.toString();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(errorMessage.contains('Pokemon no tiene más evoluciones') ? 'Pokemon no tiene más evoluciones' : 'Failed to evolve')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              // Pestañas de información y estadísticas
                              TabBar(
                                tabs: [
                                  Tab(text: 'Información'),
                                  Tab(text: 'Estadísticas'),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Muestra los tipos del Pokémon
                                          Text('Tipos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          Wrap(
                                            spacing: 8,
                                            children: pokemon.types.map((type) => Chip(
                                              label: Text(type, style: TextStyle(color: Colors.white)),
                                              backgroundColor: _getColorFromName(pokemon.color).withOpacity(0.7),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            )).toList(),
                                          ),
                                          SizedBox(height: 8),
                                          // Muestra las habilidades del Pokémon
                                          Text('Habilidades:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          Wrap(
                                            spacing: 8,
                                            children: pokemon.abilities.map((ability) => Chip(
                                              label: Text(ability),
                                              backgroundColor: _getColorFromName(pokemon.color).withOpacity(0.5),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            )).toList(),
                                          ),
                                          SizedBox(height: 8),
                                          // Muestra la cadena de evoluciones del Pokémon
                                          Text('Evoluciones:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          pokemon.evolutionChain.isNotEmpty
                                              ? Row(
                                                  children: pokemon.evolutionChain.map((evolution) {
                                                    return Row(
                                                      children: [
                                                        Card(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                          elevation: 4,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Image.network(evolution.image, width: 70, height: 70),
                                                                Text(evolution.name),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        if (evolution != pokemon.evolutionChain.last)
                                                          Icon(Icons.arrow_forward, color: _getColorFromName(evolution.color), size: 30),
                                                      ],
                                                    );
                                                  }).toList(),
                                                )
                                              : Text('No existen evoluciones'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: pokemon.stats.map((stat) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Muestra las estadísticas del Pokémon
                                              Text('${stat.name}: ${stat.baseStat}', style: TextStyle(fontSize: 18)),
                                              SizedBox(height: 4),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: LinearProgressIndicator(
                                                  value: stat.baseStat / 100,
                                                  backgroundColor: Colors.grey[300],
                                                  color: _getColorFromName(pokemon.color),
                                                  minHeight: 10,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Animación de evolución
                if (_isEvolving)
                  FadeTransition(
                    opacity: _animation,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitFadingCircle(
                              color: Colors.white,
                              size: 100.0,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Level Up!',
                              style: TextStyle(
                                fontFamily: 'PressStart2P',
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: Text('No hay datos'));
          }
        },
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