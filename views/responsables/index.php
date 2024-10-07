<?php
require_once '../header.php';

?>
<div class="container">
  <table class="table table-striped" id="tb-activo-resp">
    <colgroup>
      <col style="width: 2%;">
      <col style="width: 3%;">
      <col style="width: 5%;">
      <col style="width: 3%;">
      <col style="width: 3%;">
      <col style="width: 5%;">
    </colgroup>
    <thead>
      <tr class="text-center">
        <th>#</th>
        <th>Cod. Identificación</th>
        <th>Descripción</th>
        <th>Ubicacion</th>
        <th>Responsable</th>
        <th>Ver Detalles</th>
      </tr>
    </thead>
    <tbody>

    </tbody>
  </table>

  <!-- INICIO MODAL -->
  <div class="modal fade" id="modal-activo-resp" tabindex="-1" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="modalLabel">Detalles del Activo</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body" id="div-content">
          <p><strong>Modelo:</strong> <span id="det-modelo"></span></p>
          <p><strong>Fecha Adquisición:</strong> <span id="det-fecha-adquisicion"></span></p>
          <p><strong>Condición:</strong> <span id="det-condicion"></span></p>
          <p><strong>Ubicación Actual:</strong> <span id="det-ubicacion"></span></p>
          <p><strong>Estado:</strong> <span id="det-estado"></span></p>
          <p><strong>Fecha Asignacion:</strong> <span id="det-fecha-asignacion"></span></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
        </div>
      </div>
    </div>
  </div>
  <!-- FIN MODAL -->

  <img  alt="" id="imgTest">
</div>
<?php require_once '../footer.php' ?>
<script src="../../js/responsables/index.js"></script>
</body>
</html>