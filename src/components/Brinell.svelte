<script lang="ts">
  import { onMount } from "svelte";

  let D: string;
  let masa: string;
  let ballSize = getRandomDiameter();
  let F: number;
  let HB: number;
  const totalTime = 30;
  let timeElapsed = 0;
  let ballPosition = 0;
  let isAnimating = false;
  let interval;
  function calculateBrinellHardness() {
    const gravity = 9.807;
    const numMasa = parseFloat(masa);
    const diameter = parseFloat(D);
    F = 2 * numMasa * gravity;
    HB = (2 * F) / (Math.PI * diameter * (diameter - Math.sqrt(Math.pow(diameter, 2) - Math.pow(ballSize, 2))));
    console.log(Math.PI * diameter * (diameter - Math.sqrt(Math.pow(diameter, 2) - Math.pow(ballSize, 2))))
    console.log(Math.pow(diameter, 2))
    console.log(Math.pow(ballSize, 2))
    console.log(F)
  }

  function getRandomDiameter() {
    return Math.floor(Math.random() * 7) + 2;
  }

  //validmos los inputs
  function validateInputs() {
    if (D == null || D == "") {
      alert("Ingrese el diámetro de la esfera");
      return false;
    }
    if (masa == null || masa == "") {
      alert("Ingrese la masa");
      return false;
    }
    return true;
  }

  function startAnimation() {
    if (!validateInputs()) return;

    calculateBrinellHardness();
    ballPosition = ballSize / 30;

    if (isAnimating) return;
    isAnimating = true;
    timeElapsed = 0;
    interval = setInterval(() => {
      if (timeElapsed < totalTime) {
        if (ballPosition < ballSize * 2) {
          ballPosition = ballPosition + 0.5;
        }
        timeElapsed += 1;
      } else {
        clearInterval(interval);
        isAnimating = false;
      }
    }, 1000);
  }

  function resetAnimation() {
    clearInterval(interval);
    isAnimating = false;
    startAnimation();
  }
  function cancelAnimation() {
    if (interval) {
      clearInterval(interval);
    }
    isAnimating = false;
    timeElapsed = 0;
    ballPosition = 0;
    // Resetear cualquier otro estado o valor si es necesario
  }
  onMount(() => {
    return () => {
      if (interval) clearInterval(interval);
    };
  });
</script>

<section>
  <div class="container">
    <h1>Calculadora de Dureza Brinell</h1>
    <div class="content">
      <div class="right">
        <div>
          <img src="/assets/imagen1.png" alt="formula de brinnel">
          <div class="input-form">
            Diámetro de la bola de acero (mm):
            <input type="number" bind:value={D} step="0.1" required />
          </div>
          <div class="input-form">
            Fuerza a Ejecutar (Kgf):
            <input type="number" bind:value={masa} step="0.1" required />
          </div>
          <div>
            <h4>Sugerencias</h4>
            <ul>
              <li>Diametro de la bola: 10 mm</li>
              <li>Dureza: 187.5 a 3000 Kgf</li>
            </ul>
          </div>
        </div>
        <div>
          <button
            on:click={startAnimation}
            class="button button-primary"
            disabled={isAnimating}>Iniciar Animación</button
          >
          {#if timeElapsed > 0 && timeElapsed < totalTime}
            <button on:click={cancelAnimation} class="button button-secondary"
              >Cancelar</button
            >

            <button on:click={resetAnimation} class="button button-primary"
              >Volver a Empezar</button
            >
          {/if}
          {#if timeElapsed > 0}
            <div class="time"><p>Tiempo: {timeElapsed}s</p></div>
          {/if}
          {#if timeElapsed == totalTime}
            <div class="result">
              <div>
                El tamaño de la muesca es <span>{ballSize}mm</span>
              </div>
              <div>
                El número de Brinner es <span>{HB.toFixed(4)}</span>
              </div>
            </div>
          {/if}
        </div>
      </div>

      <div class="left">
        <div class="rectangulo"> Material
          <div class="ball" style="bottom: {200 - ballPosition * 3}px">Acero</div>
        </div>
      </div>
    </div>
  </div>
</section>

<style>
  .input-form {
    display: flex;
    justify-content: space-between;
    width: 80%;
    gap: 10px;
  }

  .left {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 50%;
  }

  .content {
    display: flex;
    flex-direction: row;
    align-items: center;
    width: 100%;
    gap: 50px;
  }
  h1 {
    color: #333;
    font-size: 24px;
    margin-bottom: 20px;
  }

  .right {
    width: 50%;
  }
  input {
    margin-bottom: 16px;
    padding: 10px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 4px;
  }

  .result {
    font-size: 14px;
    color: #333;
    padding: 10px;
    border-radius: 4px;
    border: 2px solid #333;
  }

  .result span {
    font-weight: bold;
  }

  section {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .container {
    background-color: #fff;
    border-radius: 20px;
    min-width: 70%;
    display: flex;
    flex-direction: column;
    gap: 40px;
    height: 800px;
    align-items: center;
    margin: 50px 0px;
    padding: 40px;
  }
  .ball {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background-color: #292F36;
    z-index: 1;
    position: absolute;
    bottom: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #fff;
  }
  .rectangulo {
    width: 100%;
    font-size: 18px;
    font-weight: 600;
    height: 200px;
    background-color: #FFC857;
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .button {
    padding: 10px 20px;
    margin: 10px 0;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    transition:
      background-color 0.3s,
      color 0.3s;
  }

  .button-primary {
    background-color: #4caf50;
    color: white;
  }

  .button-primary:hover {
    background-color: #3e8e41;
  }

  .button-secondary {
    background-color: #ff6b6b;
    color: white;
  }

  .button-secondary:hover {
    background-color: #ff5c5c;
  }

  .button:disabled {
    background-color: #ccc;
    color: #666;
    cursor: not-allowed;
  }

.right img{
  width: 200px;
  align-self: center;
}
</style>
