<script>
  export let amplitud;
  export let amortiguamiento;
  export let frecuencia;
  export let valoresX = [];
</script>

{#if amplitud && amortiguamiento && frecuencia}
  <div>
    <div>Se tabulan los valores de x para cada instante de tiempo:</div>
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
          <td>{item.valor.toFixed(2)}</td>
        {/each}
      </tr>
    </table>
  </div>
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
  table th,
  table td {
    border: 5px solid white;
    text-align: center;
    padding: 0.5em;
    background-color: #1d6fb8;
    color: white;
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
