<script>
  import Chart from "chart.js/auto";
  import { onMount } from "svelte";
  let isMounted = false;
  let valoresX = [];

  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();
  let amplitud = 1;
  let amortiguamiento = 1;
  let frecuencia = 1;
  let eje_x = [];
  let eje_x2 = [];
  let eje_y = [];
  let eje_y2 = [];
  let eje_y3 = [];
  let myChart;
  let canvasElement;

  function calcular() {
    if (!isMounted) return;
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
    });
  }
  onMount(() => {
    isMounted = true;
    calcular();
  });
  $: {
    valoresX = [];
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
  }
</script>

<label
  >Amplitud (<em>A</em>): <input bind:value={amplitud} type="number" /> (metros)</label
>
<label
  >Coeficiente de amortiguamiento (-&gamma;): <input
    bind:value={amortiguamiento}
    type="number"
  />
  (s<sup>-1</sup>)</label
>
<label>
  Frecuencia angular (&omega;):<input bind:value={frecuencia} type="number" /> (rad/s)</label
>

<!-- <button on:click={calcular}>Dibujar Gráfico</button> -->
<div id="contenedor">
  <canvas id="myChart" bind:this={canvasElement} width="600" height="400" />
</div>

<style>
  #myChart {
    display: block;
    max-width: 600px; /* El ancho máximo que desees */
    height: 400px; /* Altura */
  }
</style>
