<section>
  <div class="container">
    <h1>Integrantes</h1>
    <div class="participantes">
      <div class="docentes">
        <h2>Docentes</h2>
        <div>
          <ul>
            <li>Gonzales Ormeño, Pablo Guillermo</li>
            <li>Herrera Salazar, José Luis</li>
            <li>Ochoa Carbajal, Hernan</li>
            <li>Arqque Pantigozo Antonio</li>
            <li>Peláez Osorio, Mario</li>
          </ul>
        </div>
      </div>
      <div class="alumnos">
        <h2>Alumnos</h2>
        <div>
          <ul>
            <li>Gomez Huamani, Steve Edward</li>
            <li>Gonzales Gomez, Dylan Carusso</li>
            <li>Rodriguez Mejía Jean Piere</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</section>

<style>
  section {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  .container {
    background-color: #fff;
    border-radius: 20px;
    min-width: 70%;
    display: flex;
    flex-direction: column;
    gap: 40px;
    height: 600px;
    align-items: center;
    margin: 50px 0px;
    padding: 40px;
  }

  .participantes {
    display: flex;
    flex-direction: row;
    gap: 5rem;
    width: 100%;
    justify-content: center;
  }

  ul {
    padding: 5px;
  }

  li {
    list-style: circle;
    font-size: 1.2rem;
    font-weight: 500;
    margin: 10px 0px;
  }

  .docentes {
    border: 1px solid #000;
    border-radius: 20px;
    padding: 20px;
  }

  .alumnos {
    border: 1px solid #000;
    border-radius: 20px;
    padding: 20px;
  }
</style>
