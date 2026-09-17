<template>
  <div
    class="pokemon-card"
    :class="pokemon.tipoPrincipal"
    @mousemove="tiltCard"
    @mouseleave="resetTilt"
    :style="tiltStyle"
  >
    <div class="card-header">
      <span class="hp">HP {{ pokemon.hp }}</span>
      <h2 class="name">{{ pokemon.nome }}</h2>
      <span class="numero">#{{ String(pokemon.id).padStart(3, '0') }}</span>
    </div>

    <div class="image-container">
      <img :src="imagemAtual" :alt="pokemon.nome" @click="pular" />
    </div>

    <div class="types">
      <span
        v-for="tipo in pokemon.tipos"
        :key="tipo"
        class="type-badge"
        :class="tipo"
      >
        {{ tipo }}
      </span>
    </div>

    <div class="stats">
      <div class="stat-bar">
        <span class="stat-label">HP</span>
        <div class="bar-bg">
          <div class="bar-fill hp-fill" :style="{ width: barraLargura(pokemon.hp) }"></div>
        </div>
        <span class="stat-valor">{{ pokemon.hp }}</span>
      </div>
      <div class="stat-bar">
        <span class="stat-label">ATK</span>
        <div class="bar-bg">
          <div class="bar-fill atk-fill" :style="{ width: barraLargura(pokemon.ataque) }"></div>
        </div>
        <span class="stat-valor">{{ pokemon.ataque }}</span>
      </div>
      <div class="stat-bar">
        <span class="stat-label">DEF</span>
        <div class="bar-bg">
          <div class="bar-fill def-fill" :style="{ width: barraLargura(pokemon.defesa) }"></div>
        </div>
        <span class="stat-valor">{{ pokemon.defesa }}</span>
      </div>
    </div>

    <button v-if="mostrarBotaoShiny" @click="shiny = !shiny" class="btn-shiny" :class="{ ativo: shiny }">
      ✨ {{ shiny ? 'Shiny ON' : 'Ver Shiny' }}
    </button>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  pokemon: { type: Object, required: true },
  mostrarBotaoShiny: { type: Boolean, default: true },
})

const shiny = ref(false)
const tiltStyle = ref({})

const imagemAtual = computed(() =>
  shiny.value ? props.pokemon.imagemShiny : props.pokemon.imagem
)

function barraLargura(valor) {
  const max = 150
  return Math.min((valor / max) * 100, 100) + '%'
}

function tiltCard(evento) {
  const card = evento.currentTarget
  const rect = card.getBoundingClientRect()
  const x = evento.clientX - rect.left
  const y = evento.clientY - rect.top
  const centroX = rect.width / 2
  const centroY = rect.height / 2
  const rotX = ((y - centroY) / centroY) * -8
  const rotY = ((x - centroX) / centroX) * 8
  tiltStyle.value = {
    transform: `perspective(600px) rotateX(${rotX}deg) rotateY(${rotY}deg) scale(1.02)`,
  }
}

function resetTilt() {
  tiltStyle.value = {
    transform: 'perspective(600px) rotateX(0) rotateY(0) scale(1)',
  }
}

function pular(evento) {
  const img = evento.currentTarget
  img.classList.remove('pulo')
  void img.offsetWidth // reinicia a animação
  img.classList.add('pulo')
}
</script>

<style scoped>
.pokemon-card {
  width: 260px;
  border: 10px solid #eed535;
  border-radius: 15px;
  padding: 14px;
  box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.3);
  transition: background 0.5s ease, transform 0.15s ease-out;
  will-change: transform;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 6px;
}

.numero {
  font-size: 0.75rem;
  opacity: 0.7;
  font-weight: bold;
}

.name {
  margin: 0;
  font-size: 1.15rem;
  letter-spacing: 1px;
  flex: 1;
  text-align: center;
}

.hp {
  color: #ff1111;
  font-weight: bold;
  font-size: 0.8rem;
}

.image-container {
  background: #f0f0f0;
  border: 4px solid #b0b0b0;
  border-radius: 8px;
  display: flex;
  justify-content: center;
  margin: 10px 0;
}

.image-container img {
  width: 150px;
  height: 150px;
  object-fit: contain;
  cursor: pointer;
  transition: transform 0.15s;
}

.image-container img:hover {
  transform: scale(1.08);
}

.image-container img.pulo {
  animation: pular 0.4s ease;
}

@keyframes pular {
  0% { transform: translateY(0) scale(1); }
  30% { transform: translateY(-16px) scale(1.05); }
  60% { transform: translateY(0) scale(0.97); }
  100% { transform: translateY(0) scale(1); }
}

.types {
  display: flex;
  gap: 8px;
  justify-content: center;
  margin-bottom: 12px;
  flex-wrap: wrap;
}

.type-badge {
  padding: 3px 10px;
  border-radius: 20px;
  color: white;
  font-size: 0.75rem;
  text-transform: uppercase;
  font-weight: bold;
}

.stats {
  background: rgba(255, 255, 255, 0.6);
  padding: 10px;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.stat-bar {
  display: flex;
  align-items: center;
  gap: 8px;
}

.stat-label {
  width: 30px;
  font-size: 0.7rem;
  font-weight: bold;
}

.stat-valor {
  width: 28px;
  font-size: 0.7rem;
  text-align: right;
}

.bar-bg {
  flex: 1;
  height: 9px;
  background: rgba(0, 0, 0, 0.15);
  border-radius: 6px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  border-radius: 6px;
  transition: width 0.6s ease;
}

.hp-fill { background: #ff5959; }
.atk-fill { background: #f5a623; }
.def-fill { background: #4a90d9; }

.btn-shiny {
  margin-top: 10px;
  width: 100%;
  padding: 7px;
  border: none;
  border-radius: 20px;
  background: #eee;
  cursor: pointer;
  font-weight: bold;
  font-size: 0.85rem;
  transition: background 0.2s, transform 0.15s;
}

.btn-shiny:hover {
  transform: scale(1.03);
}

.btn-shiny.ativo {
  background: linear-gradient(90deg, #ffd700, #ffec8b);
}
</style>