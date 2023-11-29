<script lang="ts">
  import Form from "./Form.svelte";

  interface XValues {
    tiempo: number;
    valor: number;
  }

  interface EventValues {
    detail: {
      amplitud: number;
      amortiguamiento: number;
      frecuencia: number;
      graphGenerated: boolean;
      valoresX: XValues[];
    };
  }

  let amplitud: number;
  let amortiguamiento: number;
  let frecuencia: number;
  let showTabla = false;
  let valoresX: XValues[] = [];

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
      <Form on:updateValues={handleUpdateValues} />
    </div>
  </div>
</main>

<style>
  .container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 0.5rem 2rem;
  }
  .container h2 {
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
    border-radius: 10px;
    /* width: 100%; */
  }
</style>
