<template>
    <div class="scoreboard">
      <h2>SCORE</h2>
      <ul>
        <li>
          {{ players.name1 }} :: {{ scores.player1 }}
        </li>
        <li>
          {{ players.name2 }} :: {{ scores.player2 }}
        </li>
      </ul>
    </div>
  </template>
  
  <script>
    import io from "socket.io-client";
  export default {
    data() {
      return {
        players: {
          name1: 'Player 1',
          name2: 'Player 2',
        },
        scores: {
          player1: 0,
          player2: 0
        }
      };
    },
    created() {
      this.socket = io("http://localhost:3000");
    },
    mounted() {
      this.socket.on('updateScores', (data) => {
        this.scores = data;
      });
      }
  }
  </script>
  
  <style scoped>
  .scoreboard {
    border: 2px solid #ff4500; /* Orange border for basketball theme */
    background-color: #f0f0f0; /* Light gray background */
    padding: 10px;
    margin: 10px;
    width: 300px;
  }
  
  h2 {
    text-align: center;
    color: #ff4500; /* Orange color for basketball theme */
  }
  
  ul {
    list-style: none;
    padding: 0;
    text-align: center;
  }
  
  li {
    font-size: 1.2em;
    margin: 10px 0;
  }
  
  /* Style the player names and scores */
  li span {
    display: block;
    font-weight: bold;
    color: #333; /* Dark color for text */
  }
  
  /* Style the score numbers */
  li span.score {
    font-size: 1.5em;
    color: #ff4500; /* Orange color for scores */
  }
  </style>
  
  