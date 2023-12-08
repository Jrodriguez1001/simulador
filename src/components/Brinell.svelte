<script>
    let D = 10; // Diámetro de la esfera (puedes cambiar este valor)
    let masa = 1; 
    let d = getRandomDiameter(); // Diámetro de la muesca aleatorio entre 2 y 8
    let result = null; // Variable para almacenar el resultado del cálculo
  
    function calculateBrinellHardness() {
      // Fórmula para el cálculo de dureza Brinell: HB = (2 * F) / (π * D * √(D^2 - d^2))
      let F = 2 * masa * 9.807; // Fuerza = 2 * masa * gravedad de la Tierra
      let HB = (2*F) / ((Math.PI * D) * (D - Math.sqrt(D * D - d * d)));
      result = `La dureza Brinell es: ${HB.toFixed(2)}`;
    }
  
    function getRandomDiameter() {
      // Generar un diámetro aleatorio entre 2 y 8
      return Math.random() * (8 - 2) + 2;
    }
  </script>
  
  <style>
    /* Estilos para el formulario */
    main {
      font-family: 'Arial', sans-serif;
      text-align: center;
      margin-top: 50px;
    }
  
    h1 {
      color: #333;
      font-size: 24px;
      margin-bottom: 20px;
    }
  
    form {
      display: flex;
      flex-direction: column;
      max-width: 300px;
      margin: auto;
      background-color: #f4f4f4;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
  
    label {
      margin-bottom: 8px;
      font-size: 14px;
      color: #333;
    }
  
    input {
      margin-bottom: 16px;
      padding: 10px;
      font-size: 14px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
  
    button {
      padding: 10px;
      background-color: #4caf50;
      color: white;
      border: none;
      cursor: pointer;
      border-radius: 4px;
      transition: background-color 0.3s ease;
    }
  
    button:hover {
      background-color: #45a049;
    }
  
    .result {
      margin-top: 20px;
      font-weight: bold;
      font-size: 18px;
      color: #fff;
      background-color: #4caf50;
      padding: 10px;
      border-radius: 4px;
    }
  </style>
  
  <main>
    <h1>Calculadora de Dureza Brinell</h1>
  
    <form on:submit|preventDefault={calculateBrinellHardness}>
      <label>
        Diámetro de la esfera (D):
        <input type="number" bind:value={D} step="0.1" />
      </label>
  
      <label>
        Masa (Kilopondio):
        <input type="number" bind:value={masa} step="0.1" />
      </label>
  
      <label>
        Diámetro de la muesca (d):
        <input type="text" value={d.toFixed(2)} readonly />
      </label>
  
      <button type="submit">Calcular Dureza Brinell</button>
    </form>
  
    {#if result}
      <div class="result">{result}</div>
    {/if}
  </main>
  