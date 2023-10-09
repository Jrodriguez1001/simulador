<script>
  import Chart from "chart.js/auto";
  import { onMount } from "svelte";
  let isMounted = false;
  let valoresX = [];

  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  let amplitud = null;
  let amortiguamiento = null;
  let frecuencia = null;
  let eje_x = [];
  let eje_x2 = [];
  let eje_y = [];
  let eje_y2 = [];
  let eje_y3 = [];
  let myChart;
  let canvasElement;

  function calcular() {
    if (amplitud === null || amortiguamiento === null || frecuencia === null) {
      return;
    }
    eje_x = [];
    eje_x2 = [];
    eje_y = [];
    eje_y2 = [];
    eje_y3 = [];

    for (
      let index = 0;
      index < Math.log(0.001) / Math.log(Math.E ** -amortiguamiento);
      index += Math.PI / frecuencia
    ) {
      eje_x.push(index);
    }

    const cuadrosPorMinuto = Math.trunc((Math.PI * 100) / frecuencia);
    eje_x.forEach((p) => {
      eje_x2.push(p.toFixed(2));
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
            radius: 0,
            borderWidth: 1,
          },
          {
            label: "Amplitud mínima",
            data: eje_y3,
            tension: 0.5,
            spanGaps: true,
            radius: 0,
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
  }
  function incrementarValor(tipo) {
    if (tipo === "amplitud" && amplitud === null) {
      amplitud = 0;
    } else if (tipo === "amortiguamiento" && amortiguamiento === null) {
      amortiguamiento = 0;
    } else if (tipo === "frecuencia" && frecuencia === null) {
      frecuencia = 0;
    }

    if (tipo === "amplitud") {
      amplitud += 1;
    } else if (tipo === "amortiguamiento") {
      amortiguamiento += 1;
    } else if (tipo === "frecuencia") {
      frecuencia += 1;
    }

    calcular();
  }

  function decrementarValor(tipo) {
    // Si es null, establecer a 0
    if (tipo === "amplitud" && amplitud === null) {
      amplitud = 0;
    } else if (tipo === "amortiguamiento" && amortiguamiento === null) {
      amortiguamiento = 0;
    } else if (tipo === "frecuencia" && frecuencia === null) {
      frecuencia = 0;
    }

    // Decrementar el valor
    if (tipo === "amplitud") {
      amplitud -= 1;
      if (amplitud < 0) amplitud = 0; // Asegurar que no sea menor que 0
    } else if (tipo === "amortiguamiento") {
      amortiguamiento -= 1;
      if (amortiguamiento < 0) amortiguamiento = 0; // Asegurar que no sea menor que 0
    } else if (tipo === "frecuencia") {
      frecuencia -= 1;
      if (frecuencia < 0) frecuencia = 0; // Asegurar que no sea menor que 0
    }

    calcular();
  }
  function handleInput(event, type) {
    let value = event.target.value;
    if (value === "") {
      if (type === "amplitud") amplitud = null;
      if (type === "amortiguamiento") amortiguamiento = null;
      if (type === "frecuencia") frecuencia = null;
    } else {
      if (type === "amplitud") amplitud = +value;
      if (type === "amortiguamiento") amortiguamiento = +value;
      if (type === "frecuencia") frecuencia = +value;
    }
  }
  onMount(() => {
    isMounted = true;
    // calcular();
  });
  $: {
    valoresX = [];
    if (amplitud && amortiguamiento && frecuencia) {
      calcular();
      for (let t = 1; t <= 10; t++) {
        let x =
          amplitud * Math.exp(-amortiguamiento * t) * Math.sin(frecuencia * t);
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

<div class="contenedero">
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
        <div>
          <button on:click={() => decrementarValor("amplitud")}>-</button>
          <button on:click={() => incrementarValor("amplitud")}>+</button>
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
        <div>
          <button on:click={() => decrementarValor("amortiguamiento")}>-</button
          >
          <button on:click={() => incrementarValor("amortiguamiento")}>+</button
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

        <div>
          <button on:click={() => decrementarValor("frecuencia")}>-</button>
          <button on:click={() => incrementarValor("frecuencia")}>+</button>
        </div>
      </div>
    </div>
  </div>
  <div id="contenedor">
    <canvas id="myChart" bind:this={canvasElement} width="600" height="400" />
  </div>
</div>

<style>
  #myChart {
    display: block;
    max-width: 600px;
    height: 400px;
  }
  .form {
    background-color: #ffffff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    width: fit-content;
    margin: 20px auto;
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

  .form button {
    background-color: #007bff; /* Color azul */
    color: #fff; /* Texto blanco */
    border: none;
    border-radius: 4px;
    padding: 5px 10px;
    margin-left: 5px;
    cursor: pointer; /* Cambia el cursor a una mano al pasar por encima */
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
  .contenedero{
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: row;
    gap: 40px;
    margin-bottom: 40px;
  }
</style>
