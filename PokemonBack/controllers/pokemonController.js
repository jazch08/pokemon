import axios from "axios";

// Obtener una lista de Pokémon
export const getPokemons = async (req, res) => {
  try {
    const { data } = await axios.get("https://pokeapi.co/api/v2/pokemon?limit=20");
    const pokemons = await Promise.all(
      data.results.map(async (pokemon) => {
        const { data: pokemonData } = await axios.get(pokemon.url);
        const { data: speciesData } = await axios.get(pokemonData.species.url);
        return {
          name: pokemon.name,
          image: pokemonData.sprites.front_default,
          color: speciesData.color.name,
        };
      })
    );
    res.status(200).json(pokemons);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener los Pokémon", error });
  }
};

// Obtener detalles de un Pokémon por nombre
export const getPokemonByName = async (req, res) => {
  const { name } = req.params;

  try {
    // Obtener detalles del Pokémon por nombre
    const { data: pokemonData } = await axios.get(`https://pokeapi.co/api/v2/pokemon/${name}`);
    const { data: speciesData } = await axios.get(pokemonData.species.url);
    const { data: evolutionData } = await axios.get(speciesData.evolution_chain.url);

    // Formatear la cadena de evoluciones
    const formatEvolutionChain = async (chain) => {
      const evolutionChain = [];
      let currentChain = chain;

      while (currentChain) {
        if (currentChain.species.name === name) {
          await findEvolutions(currentChain);
          break;
        }
        currentChain = currentChain.evolves_to[0];
      }

      async function findEvolutions(chain) {
        for (const evolution of chain.evolves_to) {
          const { data: evolutionPokemonData } = await axios.get(`https://pokeapi.co/api/v2/pokemon/${evolution.species.name}`);
          const { data: evolutionSpeciesData } = await axios.get(evolutionPokemonData.species.url);
          if (evolutionPokemonData.id > pokemonData.id) {
            evolutionChain.push({
              name: evolutionPokemonData.name,
              id: evolutionPokemonData.id,
              image: evolutionPokemonData.sprites.front_default,
              color: evolutionSpeciesData.color.name,
            });
          }
          await findEvolutions(evolution);
        }
      }

      return evolutionChain;
    };

    // Crear un objeto con los detalles del Pokémon
    const pokemonDetails = {
      name: pokemonData.name,
      id: pokemonData.id,
      image: pokemonData.sprites.front_default,
      color: speciesData.color.name,
      types: pokemonData.types.map(typeInfo => typeInfo.type.name),
      abilities: pokemonData.abilities.map(abilityInfo => abilityInfo.ability.name),
      stats: pokemonData.stats.map(statInfo => ({
        name: statInfo.stat.name,
        base_stat: statInfo.base_stat,
      })),
      evolution_chain: await formatEvolutionChain(evolutionData.chain),
    };

    res.status(200).json(pokemonDetails);
  } catch (error) {
    res.status(500).json({ message: "Error al obtener los detalles del Pokémon", error });
  }
};

// Evolucionar un Pokémon
export const evolvePokemon = async (req, res) => {
  const { name } = req.params;

  try {
    // Obtener detalles del Pokémon por nombre
    const { data: pokemonData } = await axios.get(`https://pokeapi.co/api/v2/pokemon/${name}`);
    const { data: speciesData } = await axios.get(pokemonData.species.url);
    const { data: evolutionData } = await axios.get(speciesData.evolution_chain.url);

    let currentChain = evolutionData.chain;

    // Recorrer la cadena de evoluciones
    while (currentChain) {
      if (currentChain.species.name === name) {
        if (currentChain.evolves_to.length > 0) {
          const nextEvolution = currentChain.evolves_to[0];
          const { data: evolutionPokemonData } = await axios.get(`https://pokeapi.co/api/v2/pokemon/${nextEvolution.species.name}`);
          const { data: evolutionSpeciesData } = await axios.get(evolutionPokemonData.species.url);
          return res.status(200).json({
            name: evolutionPokemonData.name,
            id: evolutionPokemonData.id,
            image: evolutionPokemonData.sprites.front_default,
            color: evolutionSpeciesData.color.name,
          });
        } else {
          return res.status(400).json({ message: "El Pokémon no puede evolucionar más" });
        }
      }
      currentChain = currentChain.evolves_to[0];
    }

    res.status(404).json({ message: "Pokémon no encontrado en la cadena evolutiva" });
  } catch (error) {
    res.status(500).json({ message: "Error al obtener la evolución del Pokémon", error });
  }
};