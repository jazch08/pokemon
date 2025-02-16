import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

// Pantalla de inicio de sesión
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // Controlador para el campo de texto del correo electrónico
  final _passwordController = TextEditingController(); // Controlador para el campo de texto de la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cuerpo de la pantalla de inicio de sesión
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen de letrero
                Image.asset(
                  'assets/letrero.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                // Tarjeta blanca con los formularios y botones
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Campo de texto para el correo electrónico
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                        // Campo de texto para la contraseña
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true, // Oculta el texto para la contraseña
                        ),
                        SizedBox(height: 20),
                        // Botón de inicio de sesión
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              // Llama al método login() del ApiService para iniciar sesión
                              await Provider.of<ApiService>(context, listen: false).login(
                                _emailController.text,
                                _passwordController.text,
                              );
                              // Navega a la pantalla principal después del inicio de sesión exitoso
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                              );
                            } catch (e) {
                              // Muestra un mensaje de error si ocurre un problema durante el inicio de sesión
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Fallo al iniciar sesión')),
                              );
                            }
                          },
                          child: Text('Login'),
                        ),
                        // Botón para navegar a la pantalla de registro
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}