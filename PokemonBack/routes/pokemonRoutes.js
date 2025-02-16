import express from "express";
import { getPokemons, getPokemonByName, evolvePokemon } from "../controllers/pokemonController.js";
import authMiddleware from "../middlewares/authMiddleware.js";

const router = express.Router();

router.get("/", authMiddleware, getPokemons);

router.get("/:name", authMiddleware, getPokemonByName);

router.get("/:name/evolve", authMiddleware, evolvePokemon);

export default router;
