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
  <div class="simulator-container">
    <h2>Simulador de Resistencia de Materiales</h2>
    <div class="content-container">
      <div class="content-one">
        <div class="description">
          <p>La ecuación del movimiento expresada de manera diferencial es:</p>
          <div class="ecuacion">
            <img src="./assets/test1.png" alt="imagen de ecuación 1" />
          </div>
        </div>
        <div class="solution">
          <p>La solución de la ecuación diferencial se resuelve en:</p>
          <div class="ecuacion">
            <img src="./assets/test2.png" alt="imagen de ecuación 2" />
          </div>
        </div>
        <Tabla {amplitud} {amortiguamiento} {frecuencia} {valoresX} /> 
      </div>
      <Form on:updateValues={handleUpdateValues} />
    </div>
  </div>
</main>

<style>
  .container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: .5rem 2rem;
  }
  .container h2{
    margin-bottom: 2rem;
    text-align: center;
    color: white;
    font-size: 2rem;
  }
  .simulator-container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .content-container {
    display: flex;
    justify-content: center;
    background-color: white;
    gap: 2rem;
    padding: 2rem 5rem;
    border-radius: 10px;
    /* width: 100%; */
  }


  .description {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    margin-bottom: 20px;
  }

  .description p {
    text-align: center;
    margin-bottom: 1rem;
    font-size: 1rem;
    color: #1D6FB8;
  }

  .solution {
    display: flex;
    margin-bottom: 2rem;
    gap: 1rem;
  }

  .solution p {
    text-align: center;
    margin-bottom: 1rem;
    font-size: 1rem;
    color: #1D6FB8;
  }

  .ecuacion {
    border-radius: 10px;
    box-shadow: 1px 2px 8px #c2c2c2;
    padding: 5px;
  }
 
</style>
