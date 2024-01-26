<template>
  <div id="app">
    <GameBlock />
    <Scoreboard />
  </div>
</template>

<script>
import Scoreboard from './components/ScoreBoard.vue'
import GameBlock from './components/GameBlock.vue'

export default {
  name: 'app',
  components: {
    GameBlock,
    Scoreboard
  }
}
</script>

<style></style>
