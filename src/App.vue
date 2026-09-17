<template>
  <div class="app">
    <h1 class="title">🎮 Pokédex Interativa</h1>

    <nav class="abas">
      <button
        :class="{ ativa: abaAtual === 'aleatorio' }"
        @click="abaAtual = 'aleatorio'"
      >
        🔄 Pokémon Aleatório
      </button>
      <button
        :class="{ ativa: abaAtual === 'pacote' }"
        @click="abaAtual = 'pacote'"
      >
        🎴 Abrir Pacote
      </button>
    </nav>

    <RandomPokemon v-if="abaAtual === 'aleatorio'" />
    <CardPack v-else />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import RandomPokemon from './components/RandomPokemon.vue'
import CardPack from './components/CardPack.vue'

const abaAtual = ref('aleatorio')
</script>

<style scoped>
.app {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.title {
  margin-top: 24px;
  margin-bottom: 4px;
}

.abas {
  display: flex;
  gap: 10px;
  margin: 16px 0 8px;
}

.abas button {
  padding: 10px 18px;
  border: 2px solid #3b4cca;
  background: white;
  color: #3b4cca;
  border-radius: 20px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.2s;
}

.abas button:hover {
  transform: scale(1.04);
}

.abas button.ativa {
  background: #3b4cca;
  color: white;
}
</style>