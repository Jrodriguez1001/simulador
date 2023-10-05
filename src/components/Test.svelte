<script>
  function calcular() {
    eje_x = [];
    eje_x2 = [];
    eje_y = [];
    eje_y2 = [];
    eje_y3 = [];

    const amplitud = document.getElementById("amplitud");
    const amortiguamiento = document.getElementById("amortiguamiento");
    const frecuencia = document.getElementById("frecuencia");

    for (
      let index = 0;
      index < Math.log(0.001) / Math.log(Math.E ** -amortiguamiento.value);
      index += Math.PI / frecuencia.value
    ) {
      eje_x.push(index);
    }
    const cuadrosPorMinuto = Math.trunc((Math.PI * 100) / frecuencia.value);
    console.log(cuadrosPorMinuto);
    eje_x.forEach((p) => {
      eje_x2.push(p.toFixed(2));
    });

    eje_x.forEach((p) => {
      eje_y.push(
        amplitud.value *
          Math.E ** (-amortiguamiento.value * p) *
          Math.sin(frecuencia.value * p + Math.PI / 2)
      );
      eje_y2.push(amplitud.value * Math.E ** (-amortiguamiento.value * p));
      eje_y3.push(-amplitud.value * Math.E ** (-amortiguamiento.value * p));
    });

    document.getElementById("myChart").remove();
    const container = document.getElementById("contenedor");
    container.innerHTML = `
  <div class='col s3'>
    <p>Para encontrar los tiempos de Amplitud maxima y Amplitud minima</p>
    <img src='./public/assets/amplitud1.png' alt='formula para amplitud 1'/>
    <img src='./public/assets/amplitud2.png' alt='formula para amplitud 2 '/>
    <p>La formula para la amplitud por instante de tiempo es :</p>
    <p>x = ${amplitud.value}e<sup>-${amortiguamiento.value}</sup>sen(${frecuencia.value}t)</p>
  </div>
  <div class='col s8'>
    <canvas id='myChart'></canvas>
  </div>
  <div class='col s1'>
    <div id='bloque' style='background: black; width: 25px; height: 25px'></div>
  </div>
  `;
    const ctx = document.getElementById("myChart");

    //Inicio test
    const totalDuration =
      (Math.log(0.001) / Math.log(Math.E ** -amortiguamiento.value)) * 1000;
    const delayBetweenPoints = totalDuration / eje_x.length;
    const previousY = (ctx) =>
      ctx.index === 0
        ? ctx.chart.scales.y.getPixelForValue(100)
        : ctx.chart
            .getDatasetMeta(ctx.datasetIndex)
            .data[ctx.index - 1].getProps(["y"], true).y;
    const animation = {
      x: {
        type: "number",
        easing: "linear",
        duration: delayBetweenPoints,
        from: NaN, // the point is initially skipped
        delay(ctx) {
          if (ctx.type !== "data" || ctx.xStarted) {
            return 0;
          }
          ctx.xStarted = true;
          return ctx.index * delayBetweenPoints;
        },
      },
      y: {
        type: "number",
        easing: "linear",
        duration: delayBetweenPoints,
        from: previousY,
        delay(ctx) {
          if (ctx.type !== "data" || ctx.yStarted) {
            return 0;
          }
          ctx.yStarted = true;
          return ctx.index * delayBetweenPoints;
        },
      },
    };

    // Fin test

    new Chart(ctx, {
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
            label: "Amplitud maxima",
            data: eje_y2,
            tension: 0.5,
            spanGaps: true,
            radius: 0,
            borderWidth: 1,
          },
          {
            label: "Amplitud minima",
            data: eje_y3,
            tension: 0.5,
            spanGaps: true,
            radius: 0,
            borderWidth: 1,
          },
        ],
      },
      options: {
        animation,
        interaction: {
          intersect: true,
        },
        plugins: {
          title: {
            display: true,
            text: "Amplitud a través del tiempo",
          },
        },
        scales: {
          x: {
            type: "linear",
          },
        },
      },
    });
    //Inicio del movimiento
    const bloquecito = document.getElementById("bloque");

    var margin = 0;
    const alturaContenedor = container.clientHeight;
    console.log(alturaContenedor);
    const formateado = [];
    const movimientoTraslado = [];
    eje_y.forEach((p) => {
      formateado.push(
        ((p - amplitud.value) * -1 * alturaContenedor) / (2 * amplitud.value)
      );
    });
    for (let index = 1; index < formateado.length; index++) {
      for (let i = 0; i < cuadrosPorMinuto; i++) {
        movimientoTraslado.push(
          (formateado[index] - formateado[index - 1]) / cuadrosPorMinuto
        );
      }
    }
    var bloque = setInterval(movimiento, 10);
    var valor = 0;
    function movimiento() {
      if (valor < movimientoTraslado.length) {
        console.log(margin);
        bloquecito.style.marginTop = margin + "px";
        margin += movimientoTraslado[valor];
        valor += 1;
      }
    }
    //Fin del movimiento
  }
</script>

<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Simulador - Resistencia de Materiales</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"
    />
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"
    ></script>
    <link rel="stylesheet" href="index.css" />
  </head>
  <body style="background-color: blanchedalmond">
    <div class="container" style="background-color: white; padding: 25px">
      <h2 style="margin-top: 0">
        Simulador de resistencia de Materiales (Elasticidad)
      </h2>
      <p>La ecuación del movimiento expresada de manera diferencial es:</p>
      <img src="./public/assets/test1.png" alt="imagen de ecuación 1" />
      <p>La solución de la ecuación diferencial se resuelve en:</p>
      <img src="./public/assets/test2.png" alt="imagen de ecuación 2" />
      <div>
        <form onsubmit="return false;" style="margin-bottom: 20px">
          <div class="row">
            <div class="col s4">
              <p>Amplitud inicial (A):</p>
              <input id="amplitud" type="number" required min="0" />
            </div>
            <div class="col s4">
              <p>Amortiguamiento (-y):</p>
              <input id="amortiguamiento" type="number" required min="0" />
            </div>
            <div class="col s4">
              <p>Frecuencia angular (w):</p>
              <input id="frecuencia" type="number" required min="0" />
            </div>
          </div>
          <button
            id="boton"
            onclick="calcular()"
            class="btn waves-effect waves-light"
            style="width: 100%"
          >
            Calcular
          </button>
        </form>
      </div>
      <div id="contenedor" class="row">
        <canvas id="myChart" />
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  </body>
</html>

<style>
  body {
    margin: 0;
    padding: 0;
  }
</style>
