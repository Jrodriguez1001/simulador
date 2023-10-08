<script>
  export let amplitud;
  export let amortiguamiento;
  export let frecuencia;
  export let valoresX = [];
</script>

<div>Para encontrar los tiempos de Amplitud máxima y Amplitud mínima</div>
<div class="formula">
  <img src="./assets/amplitud1.png" alt="imagen de ecuación 1" />
  <img src="./assets/amplitud2.png" alt="imagen de ecuación 2" />
</div>
<div>La fórmula para la amplitud por instante de tiempo es:</div>
<div>
  x = {amplitud}e<sup>-{amortiguamiento}t</sup>sen({frecuencia}t)
</div>
<div>
    tabulamos los valores de x para cada instante de tiempo
</div>
<table>
    <thead>
      <tr>
        <th>Tiempo (s)</th>
        <th>Valor de x</th>
      </tr>
    </thead>
    <tbody>
      {#each valoresX as item}
        <tr>
          <td>{item.tiempo}</td>
          <td>{item.valor.toFixed(2)}</td> <!-- Puedes ajustar la precisión según necesites -->
        </tr>
      {/each}
    </tbody>
  </table>
