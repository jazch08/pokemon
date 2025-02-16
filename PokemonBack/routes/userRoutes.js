import express from "express";
import { addFavoritePokemon, getFavoritePokemons } from "../controllers/userController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = express.Router();

router.post("/add-favorite", authMiddleware, addFavoritePokemon);

router.get("/favorites", authMiddleware, getFavoritePokemons);

export default router;
