import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

// Pantalla de configuración con imagen de Pokébola y botón de cerrar sesión
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de la aplicación con el título
      appBar: AppBar(
        title: Text('Settings'),
      ),
      // Cuerpo de la pantalla de configuración con imagen de Pokébola
      body: Container(
        color: Colors.lightBlue[50], // Fondo de color pastel
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen de Pokébola
              Image.asset(
                'assets/pokebola.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              // Botón de cerrar sesión
              ElevatedButton(
                onPressed: () async {
                  // Llama al método logout() del ApiService para cerrar sesión
                  await Provider.of<ApiService>(context, listen: false).logout();
                  // Navega a la pantalla de inicio de sesión después de cerrar sesión
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}