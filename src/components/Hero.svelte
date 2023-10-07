<script>
    import Form from "./Form.svelte";
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
  <Form />
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
