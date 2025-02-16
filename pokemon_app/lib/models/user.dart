// Clase que representa un usuario
class User {
  final String username;
  final String email;

  // Constructor de la clase User
  User({required this.username, required this.email});

  // Método de fábrica para crear una instancia de User a partir de un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'], 
    );
  }

  // Constructor para crear un usuario vacío
  User.empty() : username = '', email = '';
}