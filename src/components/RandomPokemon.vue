<template>
  <div class="container">
    <div class="search-bar">
      <input
        v-model="busca"
        @keyup.enter="buscarPorNomeOuId"
        type="text"
        placeholder="Buscar por nome ou nº (ex: pikachu, 25)"
      />
      <button @click="buscarPorNomeOuId" class="btn-search">🔍</button>
    </div>

    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <span>Carregando Pokémon...</span>
    </div>

    <div v-else-if="erro" class="erro-msg">😵 {{ erro }}</div>

    <Transition name="card" mode="out-in">
      <PokemonCard v-if="!loading && pokemon" :key="pokemon.id" :pokemon="pokemon" />
    </Transition>

    <button @click="buscarAleatorio" class="btn-variar">🔄 Variar Pokémon</button>

    <p class="hint">Dica: aperte <kbd>Espaço</kbd> para sortear outro!</p>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import PokemonCard from './PokemonCard.vue'
import { usePokemonApi } from '../composables/usePokemonApi'

const { fetchPokemonAleatorio, fetchPokemon } = usePokemonApi()

const pokemon = ref(null)
const loading = ref(true)
const erro = ref(null)
const busca = ref('')

async function buscarAleatorio() {
  loading.value = true
  erro.value = null
  try {
    pokemon.value = await fetchPokemonAleatorio()
  } catch (e) {
    erro.value = 'Não foi possível carregar o Pokémon. Tente novamente.'
    console.error(e)
  } finally {
    loading.value = false
  }
}

async function buscarPorNomeOuId() {
  const termo = busca.value.trim().toLowerCase()
  if (!termo) return

  loading.value = true
  erro.value = null
  try {
    pokemon.value = await fetchPokemon(termo)
    busca.value = ''
  } catch (e) {
    erro.value = `Não encontrei "${termo}". Verifique o nome ou número.`
  } finally {
    loading.value = false
  }
}

function aoApertarTecla(e) {
  if (e.code === 'Space' && !loading.value) {
    e.preventDefault()
    buscarAleatorio()
  }
}

onMounted(() => {
  buscarAleatorio()
  window.addEventListener('keydown', aoApertarTecla)
})

onUnmounted(() => {
  window.removeEventListener('keydown', aoApertarTecla)
})
</script>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  padding: 20px;
}

.search-bar {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
}

.search-bar input {
  padding: 10px 14px;
  border-radius: 20px;
  border: 2px solid #3b4cca;
  outline: none;
  font-size: 0.95rem;
  width: 240px;
}

.btn-search {
  border: none;
  background: #3b4cca;
  color: white;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  cursor: pointer;
  font-size: 1rem;
  transition: transform 0.15s;
}

.btn-search:hover {
  transform: scale(1.1);
}

.loading {
  font-size: 1.1rem;
  font-weight: bold;
  height: 320px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 5px solid #ddd;
  border-top-color: #3b4cca;
  border-radius: 50%;
  animation: girar 0.8s linear infinite;
}

@keyframes girar {
  to { transform: rotate(360deg); }
}

.erro-msg {
  height: 320px;
  display: flex;
  align-items: center;
  font-weight: bold;
  color: #c0392b;
}

.card-enter-active,
.card-leave-active {
  transition: all 0.28s ease;
}

.card-enter-from {
  opacity: 0;
  transform: scale(0.8) rotate(-4deg);
}

.card-leave-to {
  opacity: 0;
  transform: scale(0.8) rotate(4deg);
}

.btn-variar {
  margin-top: 20px;
  padding: 12px 24px;
  font-size: 1rem;
  font-weight: bold;
  background-color: #3b4cca;
  color: white;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s;
}

.btn-variar:hover {
  transform: scale(1.05);
  background-color: #2a3a8f;
}

.btn-variar:active {
  transform: scale(0.96);
}

.hint {
  margin-top: 10px;
  font-size: 0.8rem;
  opacity: 0.6;
}

.hint kbd {
  background: #eee;
  border-radius: 4px;
  padding: 2px 6px;
  border: 1px solid #ccc;
}
</style>