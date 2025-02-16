# 🏆 Pokémon App & API  

Este repositorio contiene dos proyectos desarrollados para gestionar información de Pokémon:  

- **`pokemon_app`** → Aplicación móvil desarrollada en **Flutter** 📱  
- **`PokemonBack`** → API desarrollada con **Node.js (Express)** 🌎  

Ambos proyectos están organizados en una carpeta raíz para facilitar el desarrollo y despliegue.

---

## 📂 Estructura del Proyecto  

```
pokemon_app
│
├── lib
│   ├── models
│   │   ├── pokemon.dart
│   │   ├── pokemon_data.dart
│   │   └── user.dart
│   ├── screens
│   │   ├── configuration_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── login_screen.dart
│   │   ├── pokemon_detail_screen.dart
│   │   ├── pokemon_list_screen.dart
│   │   └── register_screen.dart
│   ├── services
│   │   └── api_service.dart
│   └── widgets
│       └── pokemon_card.dart
├── main.dart


PokemonBack
│
├── controllers
│   ├── authController.js
│   ├── pokemonController.js
│   └── userController.js
├── models
│   └── User.js
├── routes
│   ├── authRoutes.js
│   ├── pokemonRoutes.js
│   └── userRoutes.js
├── middlewares
│   └── authMiddleware.js
├── config
│   └── db.js
├── server.js
└── package.json
```


---

## ⚡ Requisitos Previos  

Antes de comenzar, asegúrate de tener instaladas las herramientas necesarias:

### 🔹 Backend (Node.js + Express)  
- [Node.js](https://nodejs.org/) (versión recomendada: **18.x o superior**)
- [MongoDB](https://www.mongodb.com/) o cualquier base de datos que uses  
- Un cliente HTTP como **Postman** o `curl` para probar la API  
Nota: Si utiliza **Postman**, este proyecto tiene una colección de Postman para facilitar la prueba de la API.

### 🔹 Frontend (Flutter)  
- [Flutter SDK](https://flutter.dev/) (versión recomendada: **3.x o superior**)  
- [Dart](https://dart.dev/)  
- Un emulador o dispositivo físico (Android/iOS)  
- [Android Studio](https://developer.android.com/studio) para desarrollo y depuración de aplicaciones Flutter en Android.

---

## 🚀 Instalación

### 1️⃣ Clonar el repositorio  
```bash
git clone https://github.com/jazch08/pokemon.git
cd pokemon
```

### 2️⃣ Instalar PokemonBack
```bash
cd PokemonBack
npm install
cp .env.example .env
```

**Ejemplo de `.env`:**

```plaintext
PORT=3000
MONGO_URI=mongodb://localhost:27017/pokemon
JWT_SECRET=mi-secreto
```

#### 3️⃣ Ejecutar PokemonBack 
```bash
npm start
```

### 4️⃣ Instalar pokemon_app
```bash
cd pokemon_app
flutter pub get
```

### 5️⃣ Ejecutar pokemon_app
```bash
flutter run
```
### 5️⃣ Conexión a la API
Para que la aplicación Flutter pueda comunicarse correctamente con el backend, asegúrate de que en `pokemon_app/lib/services/api_service.dart` la URL del backend sea la correcta:

```dart
const String baseUrl = "http://10.0.2.2:5000";
```
📌 Importante:
* Si estás ejecutando la app en un emulador de Android, usa 10.0.2.2 en lugar de localhost, ya que este es el alias interno para acceder a la máquina host desde el emulador.

🚀 Exponer la API para pruebas remotas

Si necesitas acceder al backend desde fuera de tu red local (por ejemplo, en un dispositivo móvil sin conexión a la misma WiFi), puedes usar herramientas como:

- [ngrok](https://ngrok.com/)
```bash
ngrok http 5000
```
- Opciones de Visual Studio Code en el apartado de puertos

Una vez expuesta la API, usa la URL pública generada en `baseUrl`.

```dart
const String baseUrl = "https://my-public-api.ngrok.io";
```


### 6️⃣ Adicionales

Si enfrentas problemas con la compilación en Android debido a la versión de NDK, edita el archivo android/app/build.gradle.kts y cambia la línea:
```gradle
ndkVersion "28.0.0"
```

Asegúrate de actualizar el SDK de NDK a la versión adecuada, mayor o igual a 27. Luego de cambiar el archivo, vuelve a compilar el proyecto, limpiandolo y reinstalando las dependencias.

```bash
flutter clean
flutter pub get
flutter run
```

---
## 🎥 Muesrtra de Funcionamiento

