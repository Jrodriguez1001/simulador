<script lang="ts">
  import Form from "./Form.svelte";
  import Tabla from "./Tabla.svelte";

  interface XValues { 
    tiempo: number, 
    valor: number 
  }

  interface EventValues {
    detail: {
      amplitud : number;
      amortiguamiento : number;
      frecuencia : number;
      graphGenerated: boolean;
      valoresX : XValues[];
    }
  }

  let amplitud : number;
  let amortiguamiento : number;
  let frecuencia : number;
  let showTabla = false;
  let valoresX : XValues[] = [];

  function handleUpdateValues(event: EventValues) {
    amplitud = event.detail.amplitud;
    amortiguamiento = event.detail.amortiguamiento;
    frecuencia = event.detail.frecuencia;
    showTabla = event.detail.graphGenerated;
    valoresX = event.detail.valoresX;
  }
</script>

<main class="container">
  <div class="contentLayout">
    <h1>Simulador de Resistencia de Materiales</h1>
    <div class="description">
      <p>La ecuación del movimiento expresada de manera diferencial es:</p>
      <div class="ecuacion-one">
        <img src="./assets/test1.png" alt="imagen de ecuación 1" />
      </div>
    </div>
    <div class="solution">
      <p>La solución de la ecuación diferencial se resuelve en:</p>
      <div class="ecuacion-two">
        <img src="./assets/test2.png" alt="imagen de ecuación 2" />
      </div>
    </div>
    <Tabla {amplitud} {amortiguamiento} {frecuencia} {valoresX} /> 
  </div>
  <div>
    <Form on:updateValues={handleUpdateValues} />
  </div>
</main>

<style>
  .container {
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: Arial, sans-serif;
    width: 100%;
    margin-top: 120px;
  }
.container h1{
  margin-bottom: 2em;
  text-align: center;
}
.contentLayout {
  display: flex;
  flex-direction: column;
  flex: 1;
  padding: 2em;
}
  .description {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    margin-bottom: 20px;
  }
  .solution {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 40px;
    margin-bottom: 60px;
  }
  .ecuacion-one {
    border-radius: 10px;
    box-shadow: 1px 2px 8px #c2c2c2;
    padding: 5px;
  }
  .ecuacion-two {
    border-radius: 10px;
    box-shadow: 1px 2px 8px #c2c2c2;
    padding: 5px;
  }
 
</style>
