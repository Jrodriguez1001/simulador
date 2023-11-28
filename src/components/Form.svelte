<script lang="ts">
  import Chart from "chart.js/auto";
  import Graph from "./Graph.svelte";
  import Tabla from "./Tabla.svelte";

  interface XValues {
    tiempo: number;
    valor: number;
  }

  type Parametro = "amplitud" | "amortiguamiento" | "frecuencia";

  let valoresX: XValues[] = [];

  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  let amplitud: number | null = null;
  let amortiguamiento: number | null = null;
  let frecuencia: number | null = null;

  let maxAmp: number;
  let timeouts: number[] = [];

  let eje_x: number[] = [];
  let eje_x2: number[] = [];

  let eje_y: number[] = [];
  let eje_y2: number[] = [];
  let eje_y3: number[] = [];

  let myChart: Chart;
  let canvasElement: HTMLCanvasElement;

  let squareAmp: HTMLDivElement;
  let squareContainer: HTMLDivElement;

  function resetAxis() {
    eje_x = [];
    eje_x2 = [];
    eje_y = [];
    eje_y2 = [];
    eje_y3 = [];
  }

  function calcular() {
    resetMovements();

    if (
      amplitud === null ||
      amortiguamiento === null ||
      frecuencia === null ||
      amplitud === 0 ||
      amortiguamiento === 0 ||
      frecuencia === 0
    ) {
      return;
    }
    resetAxis();

    for (
      let index = 0;
      index < Math.log(0.001) / Math.log(Math.E ** -amortiguamiento);
      index += Math.PI / frecuencia
    ) {
      eje_x.push(index);
    }

    const cuadrosPorMinuto = Math.trunc((Math.PI * 100) / frecuencia);
    eje_x.forEach((p) => {
      const toPush = Number(p.toFixed(2));
      eje_x2.push(toPush);
    });

    eje_x.forEach((p) => {
      eje_y.push(
        amplitud *
          Math.E ** (-amortiguamiento * p) *
          Math.sin(frecuencia * p + Math.PI / 2)
      );
      eje_y2.push(amplitud * Math.E ** (-amortiguamiento * p));
      eje_y3.push(-amplitud * Math.E ** (-amortiguamiento * p));
    });

    if (myChart) {
      myChart.destroy(); // Destruir el gráfico anterior si existe
    }

    myChart = new Chart(canvasElement.getContext("2d"), {
      type: "line",
      data: {
        labels: eje_x2,
        datasets: [
          {
            label: "Amplitud vs Tiempo",
            data: eje_y,
            tension: 0.5,
            borderWidth: 1,
            spanGaps: true,
          },
          {
            label: "Amplitud máxima",
            data: eje_y2,
            tension: 0.5,
            spanGaps: true,
            borderWidth: 1,
          },
          {
            label: "Amplitud mínima",
            data: eje_y3,
            tension: 0.5,
            spanGaps: true,
            borderWidth: 1,
          },
        ],
      },
      options: {
        plugins: {
          title: {
            display: true,
            text: "Amplitud a través del tiempo",
          },
        },
        scales: {
          x: {
            type: "linear",
            title: {
              display: true, // Añadido
              text: "Tiempo (s)", // Añadido
            },
          },
          y: {
            title: {
              display: true, // Añadido
              text: "Amplitud (m)", // Añadido
            },
          },
        },
      },
    });
    dispatch("updateValues", {
      amplitud,
      amortiguamiento,
      frecuencia,
      graphGenerated: true,
      valoresX,
    });
    triggerSquare();
  }

  function triggerValueChange(tipo: Parametro, value: number) {
    switch (tipo) {
      case "amplitud": {
        if (amplitud === null) amplitud = 0;
        amplitud += value;
        if (amplitud < 0) amplitud = 0;
        break;
      }
      case "amortiguamiento": {
        if (amortiguamiento === null) amortiguamiento = 0;
        amortiguamiento += value;
        if (amortiguamiento < 0) amortiguamiento = 0;
        break;
      }
      case "frecuencia": {
        if (frecuencia === null) frecuencia = 0;
        frecuencia += value;
        if (frecuencia < 0) frecuencia = 0;
        break;
      }
      default:
        return tipo as never;
    }

    calcular();
  }

  function handleInput(event: Event, type: Parametro) {
    const value = (event.target as HTMLInputElement).value;
    switch (type) {
      case "amplitud": {
        if (value === "") return (amplitud = null);
        amplitud = +value;
        break;
      }
      case "amortiguamiento": {
        if (value === "") return (amortiguamiento = null);
        amortiguamiento = +value;
        break;
      }
      case "frecuencia": {
        if (value === "") return (frecuencia = null);
        frecuencia = +value;
        break;
      }
      default:
        return type as never;
    }
  }

  function findRelativeValue(val1: number, range1: number, range2: number) {
    return (val1 * range2) / range1;
  }

  function translateTo(duration: number, val: number) {
    squareAmp.style.transitionDuration = duration + "s";
    squareAmp.style.translate = `0 calc(-50% + ${val * -1}px)`;
  }

  function resetMovements() {
    timeouts.forEach((t) => clearTimeout(t));
    timeouts = [];
    translateTo(0, 0);
  }

  function triggerSquare() {
    const timeAxis = [...eje_x];
    const ampAxis = [...eje_y];

    const squareContainerTotalHeight =
      squareContainer.getBoundingClientRect().height;
    const maxY = Math.max(...ampAxis);
    const rangeY = maxY * 2;

    maxAmp = maxY;

    const movement: { time: number; val: number }[] = [];

    timeAxis.forEach((val, i) => {
      const valY = ampAxis[i];
      const realValue = findRelativeValue(
        valY,
        rangeY,
        squareContainerTotalHeight
      );
      movement.push({
        time: val,
        val: realValue,
      });
    });

    movement.forEach(({ time, val }, i) => {
      const timeoutId = setTimeout(() => {
        const deltaSeconds =
          i !== movement.length - 1 ? movement[i + 1].time - time : time;
        translateTo(deltaSeconds, val);
      }, time * 1000);
      timeouts.push(timeoutId);
    });
  }

  $: {
    valoresX = [];
    if (amplitud && amortiguamiento && frecuencia) {
      calcular();
      for (let t = 1; t <= 10; t++) {
        let x =
          amplitud * Math.exp(-amortiguamiento) * Math.sin(frecuencia * t);
        valoresX.push({ tiempo: t, valor: x });
      }
      dispatch("updateValues", {
        amplitud,
        amortiguamiento,
        frecuencia,
        graphGenerated: true,
        valoresX,
      });
    } else if (myChart) {
      myChart.destroy();
      dispatch("updateValues", {
        amplitud: null,
        amortiguamiento: null,
        frecuencia: null,
        graphGenerated: false,
        valoresX: [],
      });
    }
  }
</script>

<div class="complete">
  <div class="one">
    <div class="form">
      <div class="input-only">
        <p class="label-text">Amplitud (<em>A</em>):</p>
        <div class="input-btns">
          <div class="input-p">
            <input
              value={amplitud !== null ? amplitud : ""}
              on:input={(event) => handleInput(event, "amplitud")}
              type="number"
              min="0"
            />
            <p>(metros)</p>
          </div>
          <div class="button-container">
            <button on:click={() => triggerValueChange("amplitud", -1)}
              >-</button
            >
            <button on:click={() => triggerValueChange("amplitud", 1)}>+</button
            >
          </div>
        </div>
      </div>

      <div class="input-only">
        <p class="label-text">Coeficiente de amortiguamiento (-&gamma;):</p>
        <div class="input-btns">
          <div class="input-p">
            <input
              value={amortiguamiento !== null ? amortiguamiento : ""}
              on:input={(event) => handleInput(event, "amortiguamiento")}
              type="number"
              min="0"
            />
            <p>(s<sup>-1</sup>)</p>
          </div>
          <div class="button-container">
            <button on:click={() => triggerValueChange("amortiguamiento", -1)}
              >-</button
            >
            <button on:click={() => triggerValueChange("amortiguamiento", 1)}
              >+</button
            >
          </div>
        </div>
      </div>

      <div class="input-only">
        <p class="label-text">Frecuencia angular (&omega;):</p>
        <div class="input-btns">
          <div class="input-p">
            <input
              value={frecuencia !== null ? frecuencia : ""}
              on:input={(event) => handleInput(event, "frecuencia")}
              type="number"
              min="0"
            />
            <p>(rad/s)</p>
          </div>

          <div class="button-container">
            <button on:click={() => triggerValueChange("frecuencia", -1)}
              >-</button
            >
            <button on:click={() => triggerValueChange("frecuencia", 1)}
              >+</button
            >
          </div>
        </div>
      </div>
    </div>
    <Tabla {amplitud} {amortiguamiento} {frecuencia} {valoresX} />
  </div>
  <div class="two">
    <div class="image">
      <img src="/assets/zwickroell.jpg" alt="maquina-zwickroell" />
    </div>

    <Graph bind:maxAmp bind:canvasElement bind:squareContainer bind:squareAmp />
  </div>
</div>

<style>
  .form {
    background-color: #ffffff;
    padding: 20px;
    margin-bottom: 1em;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  .form input[type="number"] {
    margin-left: 10px;
    padding: 5px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 16px;
    width: 50px;
  }
  /* Estilo para quitar los spinners en navegadores basados en WebKit (Chrome, Safari, etc.) */
  input[type="number"]::-webkit-inner-spin-button,
  input[type="number"]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
  /* Estilo para quitar los spinners en Firefox */
  input[type="number"]::-moz-inner-spin-button,
  input[type="number"]::-moz-outer-spin-button {
    -moz-appearance: none;
    margin: 0;
  }
  /* Estilo para quitar los spinners en Internet Explorer */
  input[type="number"]::-ms-clear {
    display: none;
  }
  .button-container {
    display: flex;
    gap: 0.5em;
  }
  .form button {
    background-color: #007bff; /* Color azul */
    color: #fff; /* Texto blanco */
    border: none;
    border-radius: 2px;
    width: 1.8em;
    height: 1.8em;
    cursor: pointer;
    transition: background-color 0.3s; /* Transición suave del color de fondo */
  }
  .form button:hover {
    background-color: #0056b3; /* Color azul oscuro al pasar el cursor por encima */
  }

  .form button:active {
    background-color: #003d80; /* Color azul aún más oscuro al hacer clic */
  }
  .input-only {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .label-text {
    width: 50%;
    font-size: 1rem;
  }

  .input-btns {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 50%;
  }
  .input-p {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .input-p input {
    margin-right: 5px;
  }

  .complete {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 50px;
    gap:1rem;
  }

  .image img {
    width: 400px;
  }

  .one {
    display: flex;
    flex-direction: column;
  }
  .two {
    display: flex;
    flex-direction: column;
  }
</style>
