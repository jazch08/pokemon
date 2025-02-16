import User from "../models/User.js";
import axios from "axios";

// Agregar un Pokémon a los favoritos del usuario
export const addFavoritePokemon = async (req, res) => {
  const { pokemonId } = req.body;
  const { id } = req.user;

  try {
    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }
    // Verificar si el Pokémon ya está en los favoritos
    const isFavorite = user.favoritePokemons.includes(pokemonId);
    if (isFavorite) {
      return res.status(400).json({ message: "Este Pokémon ya es favorito" });
    }
    // Agregar el Pokémon a los favoritos del usuario
    user.favoritePokemons.push(pokemonId);
    await user.save();

    res.status(200).json({ message: "Pokémon agregado a favoritos" });
  } catch (error) {
    res.status(500).json({ message: "Error al agregar Pokémon a favoritos", error });
  }
};

// Obtener los Pokémon favoritos del usuario
export const getFavoritePokemons = async (req, res) => {
  const { id } = req.user;
  try {
    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }
    // Obtener los detalles de los Pokémon favoritos
    const favoritePokemons = await Promise.all(
      user.favoritePokemons.map(async (pokemonId) => {
        try {
          const { data: pokemonData } = await axios.get(`https://pokeapi.co/api/v2/pokemon/${pokemonId}`);
          const { data: speciesData } = await axios.get(pokemonData.species.url);
          return {
            name: pokemonData.name,
            image: pokemonData.sprites.front_default,
            color: speciesData.color.name,
          };
        } catch (error) {
          console.error(`Error al obtener datos del Pokémon con ID ${pokemonId}:`, error);
          return null;
        }
      })
    );

    // Filtra los resultados nulos
    const validFavoritePokemons = favoritePokemons.filter(pokemon => pokemon !== null);

    res.status(200).json(validFavoritePokemons);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener los Pokémon favoritos", error });
  }
};
