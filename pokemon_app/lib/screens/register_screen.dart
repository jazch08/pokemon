import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

// Pantalla de registro de usuario
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los campos de texto
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cuerpo de la pantalla de registro
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
                        // Campo de texto para el nombre de usuario
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(labelText: 'Nombre de usuario'),
                        ),
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
                        // Botón de registro
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              // Llama al método register() del ApiService para registrar al usuario
                              await Provider.of<ApiService>(context, listen: false).register(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                              );
                              // Navega a la pantalla de inicio de sesión después del registro exitoso
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            } catch (e) {
                              // Muestra un mensaje de error si ocurre un problema durante el registro
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Fallo al registrar')),
                              );
                            }
                          },
                          child: Text('Register'),
                        ),
                        // Botón para navegar a la pantalla de inicio de sesión
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Login'),
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