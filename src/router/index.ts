import { createRouter, createWebHistory } from 'vue-router'
import RandomPokemon from '../components/RandomPokemon.vue'
import CardPack from '../components/CardPack.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: RandomPokemon,
    },
    {
      path: '/pacote',
      name: 'pacote',
      component: CardPack,
    },
  ],
})

export default router
