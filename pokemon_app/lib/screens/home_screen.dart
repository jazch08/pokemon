import 'package:flutter/material.dart';
import 'pokemon_list_screen.dart';
import 'favorites_screen.dart';
import 'configuration_screen.dart';


// Pantalla principal de la aplicación con navegación
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PokemonListScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

// Método que se llama cuando se selecciona una pestaña
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza el índice de la pestaña seleccionada
    });
  }

  @override
  Widget build(BuildContext context) {
    // Muestra la pantalla correspondiente al índice seleccionado
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Pokémon List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}