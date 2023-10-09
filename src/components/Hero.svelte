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

<div class="container">
  <h1>Simulador de Resistencia de Materiales</h1>

  <div>La ecuación del movimiento expresada de manera diferencial es:</div>
  <div class="formula">
    <img src="./assets/test1.png" alt="imagen de ecuación 1" />
  </div>
  <div>La solución de la ecuación diferencial se resuelve en:</div>
  <div class="formula">
    <img src="./assets/test2.png" alt="imagen de ecuación 1" />
  </div>
  <Form on:updateValues={handleUpdateValues} />
  {#if amplitud && amortiguamiento && frecuencia && showTabla}
    <Tabla {amplitud} {amortiguamiento} {frecuencia} {valoresX} />
  {/if}
</div>

<style>
  .container {
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    font-family: Arial, sans-serif;
    width: 100%;
  }

  .formula {
    margin-top: 20px;
  }
</style>
