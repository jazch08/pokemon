import jwt from "jsonwebtoken";
import User from "../models/User.js";

// Middleware de autenticación
const authMiddleware = async (req, res, next) => {
  // Obtener el token de la cabecera de autorización
  const token = req.header("Authorization")?.replace("Bearer ", "");

  if (!token) {
    return res.status(401).json({ message: "Authorization denied" });
  }

  try {
    // Verificar y decodificar el token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = await User.findById(decoded.id).select("-password");
    // Pasar al siguiente middleware o controlador
    next();
  } catch (error) {
    res.status(401).json({ message: "Token is not valid" });
  }
};

export default authMiddleware;