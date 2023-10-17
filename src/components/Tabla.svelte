<script>
  export let amplitud;
  export let amortiguamiento;
  export let frecuencia;
  export let valoresX = [];
  $: console.log(valoresX);
</script>

<p>Para encontrar los tiempos de Amplitud máxima y Amplitud mínima</p>
<div class="formula">
  <img src="./assets/amplitud1.png" alt="imagen de ecuación 1" />
  <img src="./assets/amplitud2.png" alt="imagen de ecuación 2" />
</div>
{#if amplitud && amortiguamiento && frecuencia}
  <div>
    <p>La fórmula para la amplitud por instante de tiempo es:</p>
    <div class="amplitudeContainer">
      x = {amplitud}e<sup>-{amortiguamiento}</sup>sen({frecuencia}t)
    </div>
  </div>
  <div>
      Se tabulan los valores de x para cada instante de tiempo:
  </div>
  <table>
    <tr>
      <th>Tiempo (s)</th>
      {#each valoresX as item}
        <td>{item.tiempo}</td>
      {/each}
    </tr>
    <tr>
      <th>Valor de x</th>
      {#each valoresX as item}
        <td>{item.valor.toFixed(2)}</td> <!-- Puedes ajustar la precisión según necesites -->
      {/each}
    </tr>
  </table>
{/if}  

<style>
  p {
    font-size: 1em;
  }
  table {
    min-width: 40%;
    margin: auto;
    margin-top: 1.6em;
    border-collapse: collapse;
  }
  th {
    font-weight: 500;
  }
  table th, table td {
    border: 5px solid white; 
    text-align: center;
    padding: 0.5em;
    background-color: #1D6FB8;
    color:white;
    border-radius: 12px;

  }
  .amplitudeContainer {
    text-align: center;
    margin-bottom: 2em;
  }
  .formula {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 2em;
    margin-bottom: 0.5em;
  }
</style>