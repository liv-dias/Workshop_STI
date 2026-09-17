// Composable com toda a lógica de comunicação com a PokeAPI.
// Assim, tanto o componente de "Pokémon Aleatório" quanto o de
// "Abertura de Pacote" reutilizam o mesmo código, sem duplicação.

const MAX_ID_GERACAO_1 = 151

// Transforma a resposta bruta da API no formato usado pelos componentes
function montarPokemon(dados) {
  return {
    id: dados.id,
    nome: dados.name.toUpperCase(),
    imagem:
      dados.sprites.other['official-artwork'].front_default ||
      dados.sprites.front_default,
    imagemShiny:
      dados.sprites.other['official-artwork'].front_shiny ||
      dados.sprites.front_shiny ||
      dados.sprites.front_default,
    tipos: dados.types.map((t) => t.type.name),
    tipoPrincipal: dados.types[0].type.name,
    hp: dados.stats.find((s) => s.stat.name === 'hp').base_stat,
    ataque: dados.stats.find((s) => s.stat.name === 'attack').base_stat,
    defesa: dados.stats.find((s) => s.stat.name === 'defense').base_stat,
  }
}

// Busca um único Pokémon por id ou nome
async function fetchPokemon(idOuNome) {
  const resposta = await fetch(`https://pokeapi.co/api/v2/pokemon/${idOuNome}`)
  if (!resposta.ok) {
    throw new Error(`Pokémon "${idOuNome}" não encontrado`)
  }
  const dados = await resposta.json()
  return montarPokemon(dados)
}

// Busca um Pokémon aleatório (por padrão, limitado à 1ª geração)
async function fetchPokemonAleatorio(maxId = MAX_ID_GERACAO_1) {
  const idAleatorio = Math.floor(Math.random() * maxId) + 1
  return fetchPokemon(idAleatorio)
}

// Busca vários Pokémons aleatórios e diferentes entre si (para o pacote de cartas)
async function fetchPokemonsAleatoriosUnicos(quantidade, maxId = MAX_ID_GERACAO_1) {
  const idsEscolhidos = new Set()

  while (idsEscolhidos.size < quantidade) {
    idsEscolhidos.add(Math.floor(Math.random() * maxId) + 1)
  }

  const promessas = [...idsEscolhidos].map((id) => fetchPokemon(id))
  return Promise.all(promessas)
}

export function usePokemonApi() {
  return {
    fetchPokemon,
    fetchPokemonAleatorio,
    fetchPokemonsAleatoriosUnicos,
  }
}