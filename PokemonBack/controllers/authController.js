import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User from "../models/User.js";

// Registro de usuario
export const register = async (req, res) => {
  const { username, email, password } = req.body;

  try {
    // Verificar si el usuario ya existe
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "El correo ya está registrado" });
    }

    // Encriptar la contraseña del usuario
    const encryptedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({ username, email, password: encryptedPassword });
    await newUser.save();

    res.status(201).json({ message: "Usuario creado" });
  } catch (error) {
    res.status(500).json({ message: "Error en el servidor", error });
  }
};

// Login de usuario
export const login = async (req, res) => {
  const { email, password } = req.body;

  try {
    // Verificar si el usuario existe
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    // Comparar la contraseña
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Contraseña incorrecta" });
    }

    // Generar token de autenticación
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "100000h",
    });

    res.status(200).json({ message: "Login exitoso", token });
  } catch (error) {
    res.status(500).json({ message: "Error en el servidor", error });
  }
};
