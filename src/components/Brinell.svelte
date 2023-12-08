<script lang="ts">
    import { createEventDispatcher } from "svelte";
  
    const dispatch = createEventDispatcher();
  
    let diametroEsfera: number | null = null;
    let diametroHuella: number | null = null;
    let cargaAplicada: number | null = null;
    let resultadoBrinell: number | null = null;
  
    function calcularDurezaBrinell() {
      if (
        diametroEsfera !== null &&
        diametroHuella !== null &&
        cargaAplicada !== null
      ) {
        const D = parseFloat(diametroEsfera);
        const d = parseFloat(diametroHuella);
        const P = parseFloat(cargaAplicada);
  
        const durezaBrinell =
          (2 * P) / (Math.PI * D * (D - Math.sqrt(D ** 2 - d ** 2)));
  
        resultadoBrinell = durezaBrinell.toFixed(2);
  
        // Envía el resultado al componente padre
        dispatch("updateDurezaBrinell", resultadoBrinell);
      } else {
        // Manejar el caso en el que no se ingresaron todos los valores necesarios
        alert("Ingrese todos los valores necesarios para calcular la dureza Brinell.");
      }
    }
  </script>
  
  <div class="brinell-container">
    <h2>Prueba de Dureza Brinell</h2>
  
    <div class="form">
      <div class="input-only">
        <p class="label-text">Diámetro de la esfera (D):</p>
        <input
          value={diametroEsfera !== null ? diametroEsfera : ""}
          on:input={(event) => (diametroEsfera = event.target.value)}
          type="number"
          min="0"
        />
      </div>
  
      <div class="input-only">
        <p class="label-text">Diámetro de la huella (d):</p>
        <input
          value={diametroHuella !== null ? diametroHuella : ""}
          on:input={(event) => (diametroHuella = event.target.value)}
          type="number"
          min="0"
        />
      </div>
  
      <div class="input-only">
        <p class="label-text">Carga aplicada (P):</p>
        <input
          value={cargaAplicada !== null ? cargaAplicada : ""}
          on:input={(event) => (cargaAplicada = event.target.value)}
          type="number"
          min="0"
        />
      </div>
  
      <button on:click={calcularDurezaBrinell}>Calcular Dureza Brinell</button>
  
      {#if resultadoBrinell !== null}
        <p>Resultado Dureza Brinell: {resultadoBrinell}</p>
      {/if}
    </div>
  </div>
  
  <style>
    .brinell-container {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }
  
    .form {
      background-color: #ffffff;
      padding: 20px;
      margin-top: 1em;
      border-radius: 10px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
  
    .input-only {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  
    .label-text {
      width: 50%;
      font-size: 1rem;
    }
  
    input[type="number"] {
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
  
    button {
      background-color: #007bff; /* Color azul */
      color: #fff; /* Texto blanco */
      border: none;
      border-radius: 2px;
      width: 1.8em;
      height: 1.8em;
      cursor: pointer;
      transition: background-color 0.3s; /* Transición suave del color de fondo */
    }
  
    button:hover {
      background-color: #0056b3; /* Color azul oscuro al pasar el cursor por encima */
    }
  
    button:active {
      background-color: #003d80; /* Color azul aún más oscuro al hacer clic */
    }
  </style>
  