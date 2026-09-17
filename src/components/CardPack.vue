<template>
  <div class="container">
    <div v-if="!cartas.length && !loading" class="pacote-fechado" @click="abrirPacote">
      <div class="pacote-visual">🎴</div>
      <p>Clique para abrir um pacote!</p>
    </div>

    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <span>Abrindo pacote...</span>
    </div>

    <div v-else-if="erro" class="erro-msg">😵 {{ erro }}</div>

    <TransitionGroup v-if="cartas.length" name="carta" tag="div" class="cartas-grid">
      <div
        v-for="(carta, i) in cartas"
        :key="carta.id"
        class="flip-wrapper"
        @click="virarCarta(i)"
      >
        <div class="flip-inner" :class="{ virada: carta.revelada }">
          <!-- Verso da carta -->
          <div class="face verso">
            <div class="pokebola"></div>
          </div>
          <!-- Frente da carta -->
          <div class="face frente">
            <PokemonCard :pokemon="carta.dados" :mostrar-botao-shiny="false" />
          </div>
        </div>
      </div>
    </TransitionGroup>

    <div v-if="cartas.length" class="acoes">
      <button @click="revelarTodas" class="btn-secundario">👁️ Revelar todas</button>
      <button @click="abrirPacote" class="btn-variar">🎴 Abrir novo pacote</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import PokemonCard from './PokemonCard.vue'
import { usePokemonApi } from '../composables/usePokemonApi'

const QUANTIDADE_POR_PACOTE = 4

const { fetchPokemonsAleatoriosUnicos } = usePokemonApi()

const cartas = ref([])
const loading = ref(false)
const erro = ref(null)

async function abrirPacote() {
  loading.value = true
  erro.value = null
  cartas.value = []

  try {
    const pokemons = await fetchPokemonsAleatoriosUnicos(QUANTIDADE_POR_PACOTE)
    cartas.value = pokemons.map((dados) => ({ dados, revelada: false }))
  } catch (e) {
    erro.value = 'Não foi possível abrir o pacote. Tente novamente.'
    console.error(e)
  } finally {
    loading.value = false
  }
}

function virarCarta(indice) {
  cartas.value[indice].revelada = true
}

function revelarTodas() {
  cartas.value.forEach((carta) => (carta.revelada = true))
}
</script>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  padding: 20px;
  min-height: 400px;
}

/* Pacote fechado, clicável */
.pacote-fechado {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  padding: 40px;
  border: 3px dashed #3b4cca;
  border-radius: 16px;
  transition: transform 0.15s, background 0.2s;
}

.pacote-fechado:hover {
  transform: scale(1.03);
  background: rgba(59, 76, 202, 0.06);
}

.pacote-visual {
  font-size: 4rem;
  animation: flutuar 2s ease-in-out infinite;
}

@keyframes flutuar {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}

.loading {
  font-size: 1.1rem;
  font-weight: bold;
  height: 300px;
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
  height: 300px;
  display: flex;
  align-items: center;
  font-weight: bold;
  color: #c0392b;
}

/* Grade de cartas */
.cartas-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  justify-content: center;
}

.carta-enter-active {
  transition: all 0.4s ease;
}

.carta-enter-from {
  opacity: 0;
  transform: translateY(30px) scale(0.8);
}

/* Efeito de virar a carta em 3D */
.flip-wrapper {
  perspective: 1000px;
  cursor: pointer;
}

.flip-inner {
  position: relative;
  width: 260px;
  height: 380px;
  transition: transform 0.6s;
  transform-style: preserve-3d;
}

.flip-inner.virada {
  transform: rotateY(180deg);
  cursor: default;
}

.face {
  position: absolute;
  inset: 0;
  backface-visibility: hidden;
  border-radius: 15px;
}

.verso {
  background: linear-gradient(135deg, #3b4cca, #2a3a8f);
  display: flex;
  align-items: center;
  justify-content: center;
  border: 10px solid #1f2a6b;
}

.pokebola {
  width: 70px;
  height: 70px;
  border-radius: 50%;
  background:
    linear-gradient(to bottom, #eee 0%, #eee 48%, #333 48%, #333 52%, #d33 52%, #d33 100%);
  border: 4px solid #222;
  position: relative;
}

.pokebola::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 22px;
  height: 22px;
  background: #eee;
  border: 4px solid #222;
  border-radius: 50%;
  transform: translate(-50%, -50%);
}

.frente {
  transform: rotateY(180deg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.acoes {
  display: flex;
  gap: 12px;
  margin-top: 24px;
  flex-wrap: wrap;
  justify-content: center;
}

.btn-variar,
.btn-secundario {
  padding: 12px 24px;
  font-size: 1rem;
  font-weight: bold;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s;
}

.btn-variar {
  background-color: #3b4cca;
  color: white;
}

.btn-variar:hover {
  transform: scale(1.05);
  background-color: #2a3a8f;
}

.btn-secundario {
  background-color: #eee;
  color: #333;
}

.btn-secundario:hover {
  transform: scale(1.05);
  background-color: #ddd;
}
</style>