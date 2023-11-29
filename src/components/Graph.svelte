<script lang="ts">
  export let maxAmp: number;
  export let canvasElement: HTMLCanvasElement;
  export let squareContainer: HTMLDivElement;
  export let squareAmp: HTMLDivElement;
</script>

<div class="table-main-container">
  <div id="contenedor">
    <canvas id="myChart" bind:this={canvasElement} width="390" height="260" />
  </div>
  <div class="amp-square-container" bind:this={squareContainer}>
    <div class="amp-square" bind:this={squareAmp}></div>
    <div class="divider" />
    <div class="top-mark">{maxAmp ?? "?"}</div>
    <div class="start-mark">- 0</div>
    <div class="bottom-mark">{maxAmp ? maxAmp * -1 : "?"}</div>
  </div>
</div>

<style>
  .table-main-container {
    display: flex;
    flex: 1;
  }
  #contenedor {
    flex: 1;
    width: 390px;
    height: 260px;
  }
  #myChart {
    display: block;
    max-width: 460px;
    height: 260px;
  }
  .amp-square-container {
    color: gray;
    position: relative;
    transition-timing-function: cubic-bezier(0.68, -0.55, 0.27, 1.55);
    width: 14px;
  }
  .amp-square {
    content: "";
    position: absolute;
    top: 50%;
    translate: 0 -50%;
    display: block;
    width: 14px;
    height: 14px;
    border-radius: 100%;
    background-color: gray;
  }
  .divider {
    content: "";
    position: absolute;
    height: 106%;
    right: 0;
    top: 3px;
    display: block;
    border-right: 1px solid gray;
  }
  .top-mark {
    position: absolute;
    text-wrap: nowrap;
    left: 120%;
    top: -2%;
  }
  .start-mark {
    position: absolute;
    text-wrap: nowrap;
    margin-top: -2px;
    left: 95%;
    top: 50%;
    translate: 0 -50%;
  }
  .bottom-mark {
    position: absolute;
    text-wrap: nowrap;
    left: 120%;
    top: 102%;
  }
</style>
