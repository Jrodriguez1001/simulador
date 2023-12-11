<script>
  import { onMount } from "svelte";

  let D;
  let ballSize = getRandomDiameter();
  let masa;
  let F;
  let HB;
  const totalTime = 30;
  let timeElapsed = 0;
  let ballPosition = 0;
  let isAnimating = false;
  let interval;
  function calculateBrinellHardness() {
    F = 2 * masa * 9.807;
    HB = (2 * F) / (Math.PI * D * (D - Math.sqrt(D * D - ballSize * ballSize)));
    console.log(HB);
  }

  function getRandomDiameter() {
    return Math.floor(Math.random() * 7) + 2;
  }

  function startAnimation() {
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

  onMount(() => {
    return () => {
      if (interval) clearInterval(interval);
    };
  });
</script>

<section>
  <div class="container">
    <div class="title"><h1>Calculadora de Dureza Brinell</h1></div>
    <div class="content">
      <div class="right">
        <div>
          <div>
            Diámetro de la esfera (D):
            <input type="number" bind:value={D} step="0.1" />
          </div>
          <div>
            Masa (Kilopondio):
            <input type="number" bind:value={masa} step="0.1" />
          </div>
          {#if timeElapsed == totalTime}
            <div class="result">{HB}</div>
          {/if}
        </div>
        <div>
          <button on:click={startAnimation} disabled={isAnimating}
            >Iniciar Animación</button
          >
          <button on:click={resetAnimation}>Volver a Empezar</button>
          <div class="time"><p>Tiempo: {timeElapsed}s</p></div>

        </div>
      </div>

      <div class="left">

        <div class="rectangulo">
          <div class="ball" style="bottom: {200 - ballPosition}px"></div>
        </div>
      </div>
    </div>
  </div>
</section>

<style>
  .title {
    margin-bottom: 100px;
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
    margin-top: 20px;
    font-weight: bold;
    font-size: 18px;
    color: #fff;
    background-color: #4caf50;
    padding: 10px;
    border-radius: 4px;
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
    width: 50%;
    display: flex;
    flex-direction: column;
    height: 600px;
    align-items: center;
    margin-top: 100px;
    padding: 40px;
  }
  .ball {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background-color: #555;
    z-index: 1;
    position: absolute;
    bottom: 100%;
  }
  .rectangulo {
    width: 100%;
    height: 200px;
    background-color: #888;
    position: relative;
    display: flex;
    justify-content: center;
  }
</style>
