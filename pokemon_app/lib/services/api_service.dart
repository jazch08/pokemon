import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pokemon_data.dart';
import '../models/pokemon.dart';
import '../models/user.dart';

// Clase que maneja las llamadas a la API y la autenticación del usuario
class ApiService with ChangeNotifier {
  String _token = '';
  User? _user;

  // Getter para obtener el usuario actual
  User? get user => _user;

  // URL base de la API
  String baseUrl = 'https://7lpqfzcb-5000.use.devtunnels.ms/api';

  // Método para establecer el usuario
  void setUser(User user) {
    _user = user;
  }

  // Método para establecer el token
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      _token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token);
      notifyListeners();
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  // Método para registrar un nuevo usuario
  Future<void> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      await login(email, password);
    } else {
      throw Exception('Fallo al registrar');
    }
  }

  // Método para obtener la lista de todos los Pokémon
  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemons'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Falló al cargar los pokemons');
    }
  }

  // Método para obtener la lista de Pokémon favoritos del usuario
  Future<List<Pokemon>> fetchFavoritePokemons() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/favorites'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Falló al cargar los pokemons favoritos');
    }
  }

  // Método para añadir un Pokémon a la lista de favoritos del usuario
  Future<void> addFavorite(PokemonData pokemon) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/add-favorite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'pokemonId': pokemon.id}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw Exception('Pokemon ya está en favoritos');
    } else {
      throw Exception('Falla al añadir a favoritos');
    }
  }

  // Método para evolucionar un Pokémon
  Future<Pokemon> evolvePokemon(String name) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemons/${name}/evolve'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Evolve: $data');
      return Pokemon.fromJson(data);
    } else if (response.statusCode == 400) {
      throw Exception('Pokemon no tiene más evoluciones');
    } else {
      throw Exception('Falla al evolucionar el Pokémon');
    }
  }

  // Método para obtener los detalles de un Pokémon específico
  Future<PokemonData> fetchPokemonDetail(String name) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pokemons/$name'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PokemonData.fromJson(data);
    } else {
      throw Exception('Fallo al cargar el detalle del Pokémon');
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = '';
    _user = null;
    notifyListeners();
  }

}