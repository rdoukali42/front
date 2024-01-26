<template>
  <div class="canvas-container">
    <div class="canvas-background"></div>
    <img id="ball" src="../assets/ball.png" style="display:none;" />
    <img id="kan" src="../assets/kan2.png" style="display:none;" />
    <img id="line" src="../assets/bar.png" style="display:none;" />
    <canvas ref="game" width="640" height="480" style="border: 1px solid black;">
    </canvas>
    <p></p> <p></p> <p></p> <p></p> <p></p> <p></p> <p></p> <p></p> <p></p> <p></p> <p></p> <p></p>
    <!-- <div style="position: absolute; left: 50px; top: 700px;">
      Player 1: {{ scores.player1 }}
    </div>
    <div style="position: absolute; left: 250px; top: 700px;">
      Player 2: {{ scores.player2 }}
    </div> -->
      <button @click="player(1)" style="position: absolute; left: 150px; top: 400px;">Player 1</button>
      <button @click="player(2)" style="position: absolute; left: 430px; top: 400px;">Player 2</button>
      <!-- <button @click="boot(111)" style="position: absolute; left: 430px; top: 450px;">Boot Pro Max</button>
      <button @click="boot(222)" style="position: absolute; left: 150px; top: 450px;">Easy Boot</button> -->
      <button v-if="buttonClicked" @click="stop" style="position: absolute; left: 300px; top: 440px;">Pause</button>
      <button v-if="!buttonClicked" @click="start" style="position: absolute; left: 300px; top: 440px;">Play</button>

      <div v-if="!buttonClicked" class="buttonChoices" id="buttonChoices" style="position: absolute; left: 290px; top: 350px;">
        <label>
          <input type="radio" v-model="this.bootid" name="choice" value="222"> Easy
        </label><br>
        <label>
          <input type="radio" v-model="this.bootid" name="choice" value="111"> Hard
        </label><br>
      </div>
      <!-- <button @click="move('down')" style="position: absolute; left: 50px; top: 500px;">↓</button>
      <button @click="move('up')" style="position: absolute; left: 100px; top: 500px;">↑</button> -->
      <div class="digital-number" style="position: absolute; left: 255px; top: 20px;">{{ scores.player1 }}</div>
      <div class="digital-number" style="position: absolute; left: 340px; top: 20px;">{{ scores.player2 }}</div>
      <div v-if="scores.player2 > 4" class="Winner" style="position: absolute; left: 240px; top: 180px;">Player 2</div>
      <div v-if="scores.player1 > 4" class="Winner" style="position: absolute; left: 240px; top: 180px;">Player 1</div>
      <div v-if="scores.player1 > 4 || scores.player2 > 4" class="Win" style="position: absolute; left: 217px; top: 222px;">WIN</div>
  </div>
  <!-- <div class="button-container">
  <button @click="move('down')">↓</button>
  <button @click="move('up')">↑</button>
  <button @click="stopG()">STOP</button>
  <button @click="newG()">Play</button>
</div> -->

</template>

<style scoped>

.buttonChoices {
  font-family: "slashed-zero", monospace;
    font-size: 1em;
    /* letter-spacing: 1em; */
    color: limegreen;
    padding: 0.2em;
}
.digital-number {
            font-variant-numeric: slashed-zero;
            /* font-family: "slashed-zero", monospace; */
            font-size: 3em;
            letter-spacing: 1em;
            color: limegreen;
            padding: 0.2em;
        }

.Winner {
    /* font-variant-numeric: slashed-zero; */
    font-family: "slashed-zero", monospace;
    font-size: 2em;
    /* letter-spacing: 1em; */
    color: limegreen;
    padding: 0.2em;
}
.Win {
    /* font-variant-numeric: slashed-zero; */
    font-family: "slashed-zero", monospace;
    font-size: 3em;
    letter-spacing: 1em;
    color: limegreen;
    padding: 0.2em;
}
  .canvas-container {
    position: relative;
    width: 640px;
    height: 480px;
    border: 1px solid black;
  }

  canvas {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  .canvas-background {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url('../assets/pong.png');
    background-size: cover;
  }
</style>

<script>
  import io from "socket.io-client";
  export default {
    name: 'GameBlock',
    data() {
      return {
        socket: {},
        context: {},
        position: {
          lx: 0,
          ly: 0,
          x: 0,
          y: 0
        },
        gameState: 0,
        oposition: {
          lx: 0,
          ly: 0,
          x: 0,
          y: 0
        },
        ballposition: {
          lx: 0,
          ly: 0,
          x: 0,
          y: 0
        },
        scores: {
          player1: 0,
          player2: 0
        },
        lastpl: 1,
        intervalId: null,
        clientId: null,
        bootid: null,
        buttonClicked: false
      }
    },
    created() {
      this.socket = io("http://localhost:3000");
      // this.clientId = prompt("Enter client ID (11 or 22):");
      // this.newG();
      // this.socket.emit("identify", this.clientId);
    },
    beforeUnmount() {
      window.removeEventListener('keydown', this.onKeyDown);
      window.removeEventListener('keyup', this.onKeyUp);
    },
    mounted() {
      // console.log("CL ID :: " + this.clientId);
      // this.intervalId = setInterval(() => { 
      //   this.ballmove();
      // }, 200);
      this.context = this.$refs.game.getContext("2d");
      // this.socket.on("position", data => {
      //   this.position = data;
      //   this.context.clearRect(this.position.lx, this.position.ly, 10, 120);
      //   // this.context.fillRect(this.position.x, this.position.y, 10, 120);
      //   this.context.drawImage(document.getElementById('kan'), this.position.x, this.position.y, 10, 120);
      //   window.addEventListener('keydown', this.onKeyDown);
      //   window.addEventListener('keyup', this.onKeyUp);
      // });
      this.socket.on("message", data => {
        console.log(data);
      });
      this.socket.on('updateScores', (data) => {
        this.scores = data;
      });
      // this.socket.on('updateScores', (data) => {
      //   this.scores = data;
      // });
      this.socket.on("ballposition", data => {
        this.ballposition = data;
        this.context.drawImage(document.getElementById('line'), 10, 0, 620, 10);
        this.context.drawImage(document.getElementById('line'), 10, 470, 620, 10);
        this.context.drawImage(document.getElementById('kan'), this.position.x, this.position.y, 10, 120);
        this.context.clearRect(this.ballposition.lx, this.ballposition.ly, 10, 10);
        if (this.ballposition.lx == 0)
          this.context.fillRect(this.ballposition.x, this.ballposition.y, 10, 10);
        // this.context.fillRect(this.ballposition.x, this.ballposition.y, 10, 10);
        this.context.drawImage(document.getElementById('ball'), this.ballposition.x, this.ballposition.y, 10, 10);
      });
      this.socket.on("lose", data => {
          this.ballposition = data;
          this.context.clearRect(this.ballposition.x, this.ballposition.y, 10, 10);
          this.stop();
      });
      this.socket.on("newstart", data => {
          this.ballposition = data;
          this.ddelay(5);
      });
      this.socket.on("dataup", (data1, data2) => {
        if (this.clientId == 11)
          {
            this.position = data1;
            this.oposition = data2;
          }
        else
          {
            this.position = data2;
            this.oposition = data1;
          }
          this.context.clearRect(this.position.lx, this.position.ly, 10, 120);
          this.context.drawImage(document.getElementById('kan'), this.position.x, this.position.y, 10, 120);
          this.context.clearRect(this.oposition.lx, this.oposition.ly, 10, 120);
          this.context.drawImage(document.getElementById('kan'), this.oposition.x, this.oposition.y, 10, 120);
          window.addEventListener('keydown', this.onKeyDown);
          window.addEventListener('keyup', this.onKeyUp);
      });
    },
    methods: {
      loop() {
        this.ballmove();
        if (this.bootid)
          this.bootmove();
        if (this.gameState)
          requestAnimationFrame(this.loop);
      },
      boot(num) {
        this.bootid = num;
      },
      bootmove() {
        this.socket.emit("boot", this.bootid);
      },
      start() {
        if (this.scores.player1 > 4 || this.scores.player2 > 4)
          {
            this.scores.player1 = 0;
            this.scores.player2 = 0;
          }
        this.stop();
        this.gameState = 1;
        this.loop();
        this.buttonClicked = true;
      },
      player(num)
      {
        if (num == 1)
          this.clientId = 11;
        else
          this.clientId = 22;
      },
      stop(){
        this.gameState = 0;
        console.log("K.IO");
        this.socket.on("stop", this.ballposition);
        this.buttonClicked = false;
      },
      newG(){
        return {
          intervalId: setInterval(() => { 
        this.ballmove();
      }, 200)
        }
      },
      ballmove() {
        this.socket.emit("ballmove", this.clientId);
      },
      move(direction) {
        this.socket.emit("move", direction, this.clientId);
      },
      onKeyDown(event) {
      if (event.key === 'ArrowDown') {
        this.move('down');}
      else if (event.key === 'ArrowUp') {
        this.move('up');}
    },
    async delay(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
    },
    async ddelay(num) {
      this.stop();
      await this.delay(num * 1000);
      this.start();
    }
    }
}
</script>


<style scoped>
.button-container {
  display: flex;
  justify-content: space-between;
  margin-top: 10px;
}

.button-container button {
  font-size: 20px;
  padding: 10px 20px;
  margin: 0 5px;
  background-color: #007bff;
  color: #ffffff;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.button-container button:hover {
  background-color: #0056b3;
}
</style>
