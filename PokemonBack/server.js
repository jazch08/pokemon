import express from "express";
import dotenv from "dotenv";
import connectDB from "./config/db.js";
import authRoutes from "./routes/authRoutes.js";
import pokemonRoutes from "./routes/pokemonRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import morgan from "morgan";
// import cors from "cors";

dotenv.config();
connectDB();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(express.json());
app.use(morgan("dev"));
// app.use(cors());

app.use("/api/auth", authRoutes);
app.use("/api/pokemons", pokemonRoutes);
app.use("/api/users", userRoutes);

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
